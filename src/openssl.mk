# This file is part of MXE.
# See index.html for further information.

PKG             := openssl
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 91b684de947cb021ac61b8c51027cc4b63d894ce
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.openssl.org/source/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libgcrypt

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE := ./config
else
  $(PKG)_CONFIGURE := ./Configure $(MXE_SYSTEM)
  $(PKG)_CROSS_COMPILE_MAKE_ARG := CROSS_COMPILE='$(TARGET)-'
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openssl.org/source/' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    grep -v '^0\.9\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$(MXE_CC) -I$(HOST_INCDIR) -L$(HOST_LIBDIR)' \
        $($(PKG)_CONFIGURE) \
        zlib \
        shared \
        no-capieng \
        --prefix='$(HOST_PREFIX)' \
        --libdir=lib
    $(MAKE) -C '$(1)' install -j 1 \
        CC='$(MXE_CC) -I$(HOST_INCDIR) -L$(HOST_LIBDIR)' \
        RANLIB='$(MXE_RANLIB)' \
        $($(PKG)_CROSS_COMPILE_MAKE_ARG) \
        AR='$(MXE_AR) rcu'
endef
