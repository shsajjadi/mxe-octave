# This file is part of MXE.
# See index.html for further information.

PKG             := libffi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.1
$(PKG)_CHECKSUM := 280c265b789e041c02e5c97815793dfc283fb1e6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://sourceware.org/pub/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/atgreen/libffi/tags' | \
    grep '<a href="/atgreen/libffi/archive/' | \
    $(SED) -n 's,.*href="/atgreen/libffi/archive/v\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(ENABLE_SHARED_OR_STATIC) \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/$(TARGET)' -j '$(JOBS)'
    $(MAKE) -C '$(1)/$(TARGET)' -j 1 install DESTDIR='$(3)'

endef
