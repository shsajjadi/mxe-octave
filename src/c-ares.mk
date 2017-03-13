# This file is part of MXE.
# See index.html for further information.

PKG             := c-ares
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.0
$(PKG)_CHECKSUM := 8abfce61d2d788fb60a3441d05275162a460cbed
$(PKG)_SUBDIR   := c-ares-$($(PKG)_VERSION)
$(PKG)_FILE     := c-ares-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://c-ares.haxx.se/download/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://c-ares.haxx.se/download/?C=M;O=D' | \
    $(SED) -n 's,.*c-ares-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_CONFIGURE_OPTS)
        
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_DOCS) 
    $(MAKE) -C '$(1)' -j 1 DESTDIR='$(3)' $(MXE_DISABLE_DOCS) install
endef
