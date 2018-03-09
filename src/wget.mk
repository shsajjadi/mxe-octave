# This file is part of MXE.
# See index.html for further information.

PKG             := wget
$(PKG)_VERSION  := 1.14
$(PKG)_CHECKSUM := cfa0906e6f72c1c902c29b52d140c22ecdcd617e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads gnutls libntlm libidn

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://git.savannah.gnu.org/cgit/wget.git/refs/' | \
    $(SED) -n "s,.*<a href='/cgit/wget.git/tag/?h=v\([0-9.]*\)'>.*,\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    # avoid conflict with base64_encode from gnutls
    $(SED) -i 's/^base64_encode /wget_base64_encode /;' '$(1)/src/utils.c'
    $(SED) -i 's/-lidn/`i686-pc-mingw32-pkg-config --libs libidn`/g;' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --with-ssl=gnutls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
