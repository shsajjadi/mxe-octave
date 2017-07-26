# This file is part of MXE.
# See index.html for further information.

PKG             := zeromq
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.2.1
$(PKG)_CHECKSUM := 2145aef176dbc944822a9b4585273d17e9b9fb7b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/$(PKG)/libzmq/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
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
