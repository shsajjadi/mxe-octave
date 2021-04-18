# This file is part of MXE.
# See index.html for further information.

PKG             := eigen
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.7
$(PKG)_CHECKSUM := f13a31c7ec3b87cf6e58b6fb05aa8b887091b71c
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-323c052e1731
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://gitlab.com/libeigen/$(PKG)/-/archive/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://eigen.tuxfamily.org/index.php?title=Main_Page#Download' | \
    $(GREP) 'released!' | \
    $(SED) -n 's,.*>Eigen \([0-9.]*\) released!.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && \
    cmake \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' DESTDIR='$(3)' install
endef
