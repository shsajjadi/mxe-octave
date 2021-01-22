# This file is part of MXE.
# See index.html for further information.

PKG             := nettle
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7
$(PKG)_CHECKSUM := 7b3fca06e91ed9fc7689748aca858a1dd166bd17
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lysator.liu.se/~nisse/archive/$($(PKG)_FILE)
$(PKG)_DEPS     := gmp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lysator.liu.se/~nisse/archive/' | \
    $(SED) -n 's,.*nettle-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'pre' | \
    grep -v 'rc' | \
    $(SORT) |
    tail -1
endef

ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
	CCAS=gcc \
	--disable-shared \
	--disable-documentation \
        --prefix='$(HOST_PREFIX)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' getopt.o getopt1.o
    $(MAKE) -C '$(1)' -j '$(JOBS)' all-here
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libnettle.a' \
        --install '$(INSTALL)' --libdir '$(1)' --bindir '$(1)' -lgmp
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libhogweed.a' \
        --install '$(INSTALL)' --libdir '$(1)' --bindir '$(1)' -lnettle -lgmp
    $(MAKE) -C '$(1)' -j '$(JOBS)'

    $(MAKE) -C '$(1)' -j 1 install-info install-headers install-pkgconfig DESTDIR='$(3)'
    $(MAKE) -C '$(1)/tools' -j 1 install DESTDIR='$(3)'
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libnettle.a' \
        --install '$(INSTALL)' --libdir '$(3)$(HOST_LIBDIR)' --bindir '$(3)$(HOST_BINDIR)' -lgmp
    $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libhogweed.a' \
        --install '$(INSTALL)' --libdir '$(3)$(HOST_LIBDIR)' --bindir '$(3)$(HOST_BINDIR)' -lnettle -lgmp
endef
else
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
	--disable-documentation \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' SUBDIRS=
    $(MAKE) -C '$(1)' -j 1 SUBDIRS= install DESTDIR='$(3)'
endef
endif
