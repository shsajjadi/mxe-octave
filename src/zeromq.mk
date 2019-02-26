# This file is part of MXE.
# See index.html for further information.

PKG             := zeromq
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.1
$(PKG)_CHECKSUM := 6cce22d830eaf95feff7cab00744df13ad7ab7f3
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://github.com/$(PKG)/libzmq/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/zeromq/libzmq/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
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
