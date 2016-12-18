# This file is part of MXE.
# See index.html for further information.

PKG             := zeromq
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.6
$(PKG)_CHECKSUM := b956df8c6f77c174683b51fbee67f99c94945651
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/$(PKG)/$(PKG)4-1/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --without-libsodium \
        $(ENABLE_SHARED_OR_STATIC) 
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
