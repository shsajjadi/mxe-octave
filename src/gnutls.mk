# This file is part of MXE.
# See index.html for further information.

PKG             := gnutls
$(PKG)_VERSION  := 3.6.14
$(PKG)_CHECKSUM := bea1b5abcb691acf014e592f41d0a9580a41216a
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.6/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.6/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext gmp libidn2 libtasn1 libunistring nettle zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://gnupg.org/ftp/gcrypt/gnutls/v3.6/ | \
    $(SED) -n 's,.*gnutls-\([1-9]\+\.[0-9]\+.[0-9]\+\)\..*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

$(PKG)_WINDOWS_CONFIGURE_OPTIONS := \
   CPPFLAGS='-D_WIN32_WINNT=0x0600' --disable-rpath 

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_CONFIGURE_OPTIONS := $($(PKG)_WINDOWS_CONFIGURE_OPTIONS)
endif
ifeq ($(MXE_SYSTEM),msvc)
  $(PKG)_CONFIGURE_OPTIONS := $($(PKG)_WINDOWS_CONFIGURE_OPTIONS)
endif

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf -fi 
    cd '$(1)/.build' && ../configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-nls \
        --disable-guile \
        --disable-doc \
        --disable-tests \
        --enable-local-libopts \
        --without-p11-kit \
        --disable-silent-rules \
        $($(PKG)_CONFIGURE_OPTIONS) \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)'
endef
