# This file is part of MXE.
# See index.html for further information.

PKG             := zeromq
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.3
$(PKG)_CHECKSUM := d78bc504194d6908df40a2b9e41849b181b02491
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
        --disable-perf \
        --without-libsodium \
        $(ENABLE_SHARED_OR_STATIC) 

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
