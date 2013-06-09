# This file is part of MXE.
# See index.html for further information.

PKG             := openal
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e6d69db13ec15465b83a45ef89978e8a0f55beca
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := openal-soft-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://kcat.strangesoft.net/openal-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc portaudio

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://kcat.strangesoft.net/openal-releases/?C=M;O=D' | \
    $(SED) -n 's,.*"openal-soft-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC \
        -DEXAMPLES=FALSE
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-openal.exe' \
        `'$(MXE_PKG_CONFIG)' openal --cflags --libs`
endef
