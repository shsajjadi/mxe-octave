# This file is part of MXE.
# See index.html for further information.

PKG             := lzo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.06
$(PKG)_CHECKSUM := a11768b8a168ec607750842bbef406f11547b904
$(PKG)_SUBDIR   := lzo-$($(PKG)_VERSION)
$(PKG)_FILE     := lzo-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.oberhumer.com/opensource/lzo/download/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.oberhumer.com/opensource/lzo/download/' | \
    grep 'lzo-' | \
    grep -v 'minilzo-' | \
    $(SED) -n 's,.*lzo-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
