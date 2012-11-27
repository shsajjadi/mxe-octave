# This file is part of MXE.
# See index.html for further information.

PKG             := libssh2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7fc084254dabe14a9bc90fa3d569faa7ee943e19
$(PKG)_SUBDIR   := libssh2-$($(PKG)_VERSION)
$(PKG)_FILE     := libssh2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libssh2.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgcrypt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.libssh2.org/download/?C=M;O=D' | \
    grep 'libssh2-' | \
    $(SED) -n 's,.*libssh2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./buildconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --without-openssl \
        --with-libgcrypt \
        PKG_CONFIG='$(TARGET)-pkg-config'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= html_DATA=

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libssh2.exe' \
        `'$(TARGET)-pkg-config' --cflags --libs libssh2`

    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libssh2.a' -lgcrypt; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/'; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libssh2.dll.a' '$(PREFIX)/$(TARGET)/lib/libssh2.dll.a'; \
      $(INSTALL) -m644 '$(PREFIX)/$(TARGET)/lib/libssh2.dll' '$(PREFIX)/$(TARGET)/bin/libssh2.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libssh2.dll'; \
    fi
endef
