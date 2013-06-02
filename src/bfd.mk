# This file is part of MXE.
# See index.html for further information.

PKG             := bfd
$(PKG)_IGNORE    = $(binutils_IGNORE)
$(PKG)_CHECKSUM  = $(binutils_CHECKSUM)
$(PKG)_SUBDIR    = $(binutils_SUBDIR)
$(PKG)_FILE      = $(binutils_FILE)
$(PKG)_URL       = $(binutils_URL)
$(PKG)_URL_2     = $(binutils_URL2)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo $(binutils_VERSION)
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
