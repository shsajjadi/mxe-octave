# This file is part of MXE.
# See index.html for further information.

PKG             := bfd
$(PKG)_IGNORE    = $(build-binutils_IGNORE)
$(PKG)_VERSION  := 2.22
$(PKG)_CHECKSUM  = $(build-binutils_CHECKSUM)
$(PKG)_SUBDIR    = $(build-binutils_SUBDIR)
$(PKG)_FILE      = $(build-binutils_FILE)
$(PKG)_URL       = $(build-binutils_URL)
$(PKG)_URL_2     = $(build-binutils_URL2)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(build-binutils_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)/bfd' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --target='$(TARGET)' \
        --prefix='$(HOST_PREFIX)' \
        --enable-install-libbfd \
        $(ENABLE_SHARED_OR_STATIC)
    $(MAKE) -C '$(1)/bfd' -j '$(JOBS)'
    $(MAKE) -C '$(1)/bfd' -j 1 install
endef
