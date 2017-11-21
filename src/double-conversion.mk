# This file is part of MXE.
# See index.html for further information.

PKG             := double-conversion
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.0
$(PKG)_CHECKSUM := d900d4d946beb493a03cd6c9b180ed2bcbd0f20e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/google/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

$(PKG)_CMAKE_FLAGS :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/google/double-conversion/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $($(PKG)_CMAKE_FLAGS) \
        -DBUILD_TESTING=no \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        .

    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)' -j '1' VERBOSE=1 DESTDIR='$(3)' install
endef
