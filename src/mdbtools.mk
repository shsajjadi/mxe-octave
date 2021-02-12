# This file is part of MXE.
# See index.html for further information.

# mdbtools
PKG             := mdbtools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.7
$(PKG)_CHECKSUM := 62fe0703fd8691e4536e1012317406bdb72594cf
$(PKG)_SUBDIR   := brianb-mdbtools-004cc9f
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/brianb/$(PKG)/tarball/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/brianb/mdbtools/tags' | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | \
    head -1
endef

define $(PKG)_BUILD
    '$(SED)' -i 's/libtooloze/libtoolize/g;' '$(1)/autogen.sh'
    cd '$(1)' && NOCONFIGURE=1 ./autogen.sh
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=
endef
