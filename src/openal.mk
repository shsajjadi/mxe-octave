# This file is part of MXE.
# See index.html for further information.

PKG             := openal
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15.1
$(PKG)_CHECKSUM := 018a9cd414db6b2ba5924261a59f34e8ce7b603a
$(PKG)_SUBDIR   := openal-soft-$($(PKG)_VERSION)
$(PKG)_FILE     := openal-soft-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/kcat/openal-soft/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := portaudio

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/kcat/openal-soft/tags' | \
    $(SED) -n 's|.*releases/tag/openal-soft-\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/build' && cmake .. \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DEXAMPLES=FALSE
    $(MAKE) -C '$(1)/build' -j '$(JOBS)' install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(1)/test-openal.exe' \
        `'$(MXE_PKG_CONFIG)' openal --cflags --libs`
endef

