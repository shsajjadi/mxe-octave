# This file is part of MXE.
# See index.html for further information.

PKG             := libiconv
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := be7d67e50d72ff067b2c0291311bc283add36965
$(PKG)_SUBDIR   := libiconv-$($(PKG)_VERSION)
$(PKG)_FILE     := libiconv-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/libiconv/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.gnu.org/software/libiconv/' | \
    grep 'libiconv-' | \
    $(SED) -n 's,.*libiconv-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/windows/windres-options'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        CPPFLAGS='$(MXE_CPPFLAGS)' \
        --disable-nls
    $(MAKE) -C '$(1)/libcharset' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/lib'        -j '$(JOBS)' install
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/include/iconv.h.inst' '$(HOST_INCDIR)/iconv.h'
endef
