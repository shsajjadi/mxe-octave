# This file is part of MXE.
# See index.html for further information.

PKG             := wt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.3
$(PKG)_CHECKSUM := d3870671a303d64878a1c9fe22765a643e515051
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/emweb/wt/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := boost openssl libharu graphicsmagick pango postgresql sqlite

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/emweb/wt/tags' | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    # build wt libraries
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DCONFIGDIR='$(HOST_PREFIX)/etc/wt' \
        -DBUILD_EXAMPLES=OFF \
        -DBUILD_TESTS=OFF \
        -DSHARED_LIBS=OFF \
        -DBOOST_DYNAMIC=OFF \
        -DBOOST_PREFIX='$(HOST_PREFIX)' \
        -DBOOST_COMPILER=_win32 \
        -DSSL_PREFIX='$(HOST_PREFIX)' \
        -DOPENSSL_LIBS="`'$(MXE_PKG_CONFIG)' --libs-only-l openssl`" \
        -DGM_PREFIX='$(HOST_PREFIX)' \
        -DGM_LIBS="`'$(MXE_PKG_CONFIG)' --libs-only-l GraphicsMagick++`" \
        -DPANGO_FT2_LIBS="`'$(MXE_PKG_CONFIG)' --libs-only-l pangoft2`" \
        -DWT_CMAKE_FINDER_INSTALL_DIR='/lib/wt' \
        $(CMAKE_CCACHE_FLAGS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)'

    $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
endef
