# This file is part of MXE.
# See index.html for further information.

PKG             := sqlite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3080500
$(PKG)_CHECKSUM := 7f667e10ccebc26ab2086b8a30cb0a600ca0acae
$(PKG)_SUBDIR   := $(PKG)-autoconf-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-autoconf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.sqlite.org/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.sqlite.org/download.html' | \
    $(SED) -n 's,.*sqlite-autoconf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-readline \
        --disable-threadsafe
    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
