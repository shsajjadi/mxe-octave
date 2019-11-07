# This file is part of MXE.
# See index.html for further information.

# sox
PKG             := sox
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 14.4.0
$(PKG)_CHECKSUM := d809cab382c7a9d015491c69051a9d1c1a1a44f1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := ffmpeg flac lame libmad libsndfile vorbis
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += libgomp
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/sox/files/sox/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # set pkg-config cflags and libs
    $(SED) -i 's,^\(Cflags:.*\),\1 -fopenmp,' '$(1)/sox.pc.in'
    $(SED) -i '/Libs.private/d'               '$(1)/sox.pc.in'
    echo Libs.private: `grep sox_LDADD '$(1)/src/optional-fmts.am' | \
    $(SED) 's, sox_LDADD += ,,g' | tr -d '\n'` >>'$(1)/sox.pc.in'

    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC)

    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= EXTRA_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-sox.exe' \
        `'$(MXE_PKG_CONFIG)' sox --cflags --libs`
endef
