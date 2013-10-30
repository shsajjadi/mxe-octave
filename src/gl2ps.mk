# This file is part of MXE.
# See index.html for further information.

PKG             := gl2ps
$(PKG)_CHECKSUM := 792e11db0fe7a30a4dc4491af5098b047ec378b1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-source
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://geuz.org/$(PKG)/src/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $(gl2ps_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(MXE_AR)' \
        -DCMAKE_RANLIB='$(MXE_RANLIB)' \
        .
    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1 install
endef
