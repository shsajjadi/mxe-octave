# This file is part of MXE.
# See index.html for further information.

PKG             := rapidjson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := a3e0d043ad3c2d7638ffefa3beb30a77c71c869f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/Tencent/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/Tencent/$(PKG)/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && \
    cmake \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DRAPIDJSON_BUILD_DOC=Off \
        -DRAPIDJSON_BUILD_EXAMPLES=Off \
        -DRAPIDJSON_BUILD_TESTS=Off \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' DESTDIR='$(3)' install
endef

