# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libical
PKG             := libical
$(PKG)_VERSION  := 0.48
$(PKG)_CHECKSUM := 4693cd0438be9f3727146ac1a46aa5b1b93b8c86
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://freeassociation.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeassociation/$(PKG)/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/freeassociation/files/$(PKG)/' | \
    $(SED) -n 's,.*/$(PKG)-\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && mkdir build
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DSTATIC_LIBRARY=true
    $(MAKE) -C '$(1)/build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libical.exe' \
        `'$(TARGET)-pkg-config' libical --cflags --libs`
endef
