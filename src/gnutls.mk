# This file is part of MXE.
# See index.html for further information.

PKG             := gnutls
$(PKG)_CHECKSUM := d3531761f2754e81f72428d482c0689f0a5e064f
$(PKG)_SUBDIR   := gnutls-$($(PKG)_VERSION)
$(PKG)_FILE     := gnutls-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnu.org/gnu/gnutls/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc nettle zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gnutls.git;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>gnutls_\([0-9]*_[0-9]*[012468]_[^<]*\)<.*,\1,p' | \
    $(SED) 's,_,.,g' | \
    grep -v '^2\.' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's, sed , $(SED) ,g' '$(1)/gl/tests/Makefile.am'
    cd '$(1)' && aclocal -I m4 -I gl/m4 -I src/libopts/m4 --install
    cd '$(1)' && autoconf
    cd '$(1)' && automake --add-missing
    # AI_ADDRCONFIG referenced by src/serv.c but not provided by mingw.
    # Value taken from http://msdn.microsoft.com/en-us/library/windows/desktop/ms737530%28v=vs.85%29.aspx
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-guile \
        --with-included-libtasn1 \
        --with-included-libcfg \
        --without-p11-kit \
        --disable-silent-rules \
        CPPFLAGS='-DWINVER=0x0501 -DAI_ADDRCONFIG=0x0400 -DIPV6_V6ONLY=27' \
        LIBS='-lws2_32' \
        ac_cv_prog_AR='$(TARGET)-ar'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libgnutls.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgnutls.dll.a' '$(PREFIX)/$(TARGET)/lib/libgnutls.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgnutls.dll' '$(PREFIX)/$(TARGET)/bin/libgnutls.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgnutls.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgnutls.la'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-g++' '$(PREFIX)/$(TARGET)/lib/libgnutlsxx.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgnutlsxx.dll.a' '$(PREFIX)/$(TARGET)/lib/libgnutlsxx.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgnutlsxx.dll' '$(PREFIX)/$(TARGET)/bin/libgnutlsxx.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgnutlsxx.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgnutlsxx.la'; \
 \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-g++' '$(PREFIX)/$(TARGET)/lib/libgnutls-openssl.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgnutls-openssl.dll.a' '$(PREFIX)/$(TARGET)/lib/libgnutls-openssl.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgnutls-openssl.dll' '$(PREFIX)/$(TARGET)/bin/libgnutls-openssl.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgnutls-openssl.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgnutls-openssl.la'; \
    fi

##    '$(TARGET)-gcc' \
##        -W -Wall -Werror -ansi -pedantic \
##        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-gnutls.exe' \
##        `'$(TARGET)-pkg-config' gnutls --cflags --libs`
endef
