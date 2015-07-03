# This file is part of MXE.
# See index.html for further information.

PKG             := zeromq
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.2
$(PKG)_CHECKSUM := 86c17096f7f4bf46cbcd2ad242cf8fec8a7cfb7b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.zeromq.org/$($(PKG)_FILE)
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
