# This file is part of MXE.
# See index.html for further information.

PKG             := nettle
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 1061754feb69dd01354525fa7eb6154b28ac887d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    tail -1
endef

ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
	CCAS=gcc \
	--disable-shared \
        --prefix='$(HOST_PREFIX)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' getopt.o getopt1.o
    $(MAKE) -C '$(1)' -j '$(JOBS)' all-here
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libnettle.a' \
        --install '$(INSTALL)' --libdir '$(1)' --bindir '$(1)' -lgmp
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libhogweed.a' \
        --install '$(INSTALL)' --libdir '$(1)' --bindir '$(1)' -lnettle -lgmp
    $(MAKE) -C '$(1)' -j '$(JOBS)'

    $(MAKE) -C '$(1)' -j 1 install-info install-headers install-pkgconfig
    $(MAKE) -C '$(1)/tools' -j 1 install
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libnettle.a' \
        --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)' -lgmp
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libhogweed.a' \
        --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)' -lnettle -lgmp
endef
else
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' getopt.o getopt1.o
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    if [ -d $(HOST_PREFIX)/lib64 ]; then \
      $(INSTALL) -d $(HOST_LIBDIR)/pkgconfig; \
      mv $(HOST_PREFIX)/lib64/pkgconfig/* $(HOST_LIBDIR)/pkgconfig; \
      rmdir $(HOST_PREFIX)/lib64/pkgconfig; \
      mv $(HOST_PREFIX)/lib64/* $(HOST_LIBDIR); \
    fi
endef
endif
