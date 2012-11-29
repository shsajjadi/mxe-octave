# This file is part of MXE.
# See index.html for further information.

PKG             := libgpg_error
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 95b324359627fbcb762487ab6091afbe59823b29
$(PKG)_SUBDIR   := libgpg-error-$($(PKG)_VERSION)
$(PKG)_FILE     := libgpg-error-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls \
        --disable-languages
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libgpg-error.a'; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin/'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgpg-error.dll.a' '$(PREFIX)/$(TARGET)/lib/libgpg-error.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libgpg-error.dll' '$(PREFIX)/$(TARGET)/bin/libgpg-error.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libgpg-error.dll'; \
    fi
endef
