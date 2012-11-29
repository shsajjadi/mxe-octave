# This file is part of MXE.
# See index.html for further information.

PKG             := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e776d44375dc1a710560b98ae8437d5da6e32cf
$(PKG)_SUBDIR   := libgcrypt-$($(PKG)_VERSION)
$(PKG)_FILE     := libgcrypt-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libgpg_error

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/' | \
    $(SED) -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v '^1\.4\.' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-gpg-error-prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    ln -sf '$(PREFIX)/$(TARGET)/bin/libgcrypt-config' '$(PREFIX)/bin/$(TARGET)-libgcrypt-config'

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(PREFIX)/$(TARGET)/bin/test-libgcrypt.exe' \
        `$(TARGET)-libgcrypt-config --cflags --libs`

    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libgcrypt.a'; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgcrypt.dll.a' '$(PREFIX)/$(TARGET)/lib/libgcrypt.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgcrypt.dll' '$(PREFIX)/$(TARGET)/bin/libgcrypt.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgcrypt.dll'; \
    fi
endef
