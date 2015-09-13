# This file is part of MXE.
# See index.html for further information.

PKG             := tiff
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.5
$(PKG)_CHECKSUM := 76477a8ca914c132922ca2738ffe629b840e7446
$(PKG)_SUBDIR   := tiff-$($(PKG)_VERSION)
$(PKG)_FILE     := tiff-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/libtiff/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/libtiff/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib jpeg
ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS += xz
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.remotesensing.org/libtiff/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --without-x && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= DESTDIR='$(3)'

    rm -f '$(3)$(HOST_LIBDIR)/libtiff.la'
    rm -f '$(3)$(HOST_LIBDIR)/lib/libtiffxx.la'
endef
