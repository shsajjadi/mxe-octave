# This file is part of MXE.
# See index.html for further information.

PKG             := nettle
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1061754feb69dd01354525fa7eb6154b28ac887d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' getopt.o getopt1.o
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    if [ -d $(PREFIX)/$(TARGET)/lib64 ]; then \
      $(INSTALL) -d $(MXE_LIBDIR)/pkgconfig; \
      mv $(PREFIX)/$(TARGET)/lib64/pkgconfig/* $(MXE_LIBDIR)/pkgconfig; \
      rmdir $(PREFIX)/$(TARGET)/lib64/pkgconfig; \
      mv $(PREFIX)/$(TARGET)/lib64/* $(MXE_LIBDIR); \
    fi
endef
