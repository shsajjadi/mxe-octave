# This file is part of MXE.
# See index.html for further information.

PKG             := gnutls
$(PKG)_VERSION  := 3.6.8
$(PKG)_CHECKSUM := e1243188791af409bca118d31faf3ec3d5f0a5ab
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnutls.org/gcrypt/gnutls/v3.6/$($(PKG)_FILE)
$(PKG)_URL_2    := https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnutls/v3.5/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext libidn2 libunistring nettle pcre zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://gnupg.org/ftp/gcrypt/gnutls/v3.6/ | \
    $(SED) -n 's,.*gnutls-\([1-9]\+\.[0-9]\+.[0-9]\+\)\..*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

$(PKG)_WINDOWS_CONFIGURE_OPTIONS := \
   CPPFLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400 -DIPV6_V6ONLY=27' \
   LIBS='-lws2_32'

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_CONFIGURE_OPTIONS := $($(PKG)_WINDOWS_CONFIGURE_OPTIONS)
endif
ifeq ($(MXE_SYSTEM),msvc)
  $(PKG)_CONFIGURE_OPTIONS := $($(PKG)_WINDOWS_CONFIGURE_OPTIONS)
endif

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/gl/tests/Makefile.am'
    cd '$(1)' && autoreconf -fi  -I m4 -I src/libopts/m4
    if [ "$(MXE_NATIVE_BUILD)" = no ]; then \
      $(SED) -i 's/libopts_cv_with_libregex=no/libopts_cv_with_libregex=yes/g;' '$(1)/configure'; \
    fi
    # AI_ADDRCONFIG referenced by src/serv.c but not provided by mingw.
    # Value taken from http://msdn.microsoft.com/en-us/library/windows/desktop/ms737530%28v=vs.85%29.aspx
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-nls \
        --disable-guile \
        --disable-doc \
        --disable-tests \
        --with-included-libtasn1 \
        --with-libregex='$(HOST_PREFIX)' \
        --with-regex-header=pcreposix.h \
        --with-libregex-cflags="`$(MXE_PKG_CONFIG) libpcreposix --cflags`" \
        --with-libregex-libs="`$(MXE_PKG_CONFIG) libpcreposix --libs`" \
        --with-included-libcfg \
        --enable-local-libopts \
        --without-p11-kit \
        --disable-silent-rules \
        $($(PKG)_CONFIGURE_OPTIONS) \
        ac_cv_prog_AR='$(MXE_AR)' && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
