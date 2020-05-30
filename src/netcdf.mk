# This file is part of MXE.
# See index.html for further information.

PKG             := netcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7.4
$(PKG)_CHECKSUM := dce4851dd65bf8ec985f11711bb5a8aa299515b9
$(PKG)_SUBDIR   := netcdf-c-$($(PKG)_VERSION)
$(PKG)_FILE     := netcdf-c-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.unidata.ucar.edu/pub/netcdf/$($(PKG)_FILE)
$(PKG)_DEPS     := curl hdf5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.unidata.ucar.edu/pub/netcdf/' | \
    $(SED) -n 's,.*netcdf-c-\([0-9]\.[^>]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_CONFIGURE_OPTIONS := --enable-dll
endif

$(PKG)_CONFIGURE_POST_HOOK := $(CONFIGURE_POST_HOOK)
ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_CONFIGURE_POST_HOOK += -x
endif

define $(PKG)_BUILD
    if [ $(MXE_SYSTEM) = msvc ]; then \
        cd '$(1)' && autoreconf -f -i -v; \
    fi
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_CONFIGURE_OPTIONS) \
	&& $($(PKG)_CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' LDFLAGS='-no-undefined -L$(HOST_LIBDIR)'
    $(MAKE) -C '$(1)' -j 1 install LDFLAGS='-no-undefined -L$(HOST_LIBDIR)' $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
  
    if [ ! "x$(MXE_NATIVE_BUILD)" = "xyes" ]; then \
      $(LN_SF) '$(HOST_BINDIR)/nc-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)nc-config'; \
    fi
endef
