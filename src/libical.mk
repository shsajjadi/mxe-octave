# This file is part of MXE.
# See index.html for further information.

PKG             := libical
$(PKG)_VERSION  := 0.48
$(PKG)_CHECKSUM := 4693cd0438be9f3727146ac1a46aa5b1b93b8c86
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeassociation/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freeassociation/files/$(PKG)/' | \
    $(SED) -n 's,.*/$(PKG)-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && mkdir build
    cd '$(1)/build' && cmake .. \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DSTATIC_LIBRARY=true \
        -DHAVE_PTHREAD_H=false \
        -DCMAKE_HAVE_PTHREAD_H=false
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' ical-header
    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build' -j 1 install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-libical.exe' \
        `'$(MXE_PKG_CONFIG)' libical --cflags --libs`
endef
