# This file is part of MXE.
# See index.html for further information.

PKG             := netcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.0
$(PKG)_CHECKSUM := 246e4963e66e1c175563cc9a714e9da0a19b8b07
$(PKG)_SUBDIR   := netcdf-$($(PKG)_VERSION)
$(PKG)_FILE     := netcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := curl hdf5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.unidata.ucar.edu/downloads/netcdf/current/index.jsp' | \
    $(SED) -n 's,.*netcdf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
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
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_CONFIGURE_OPTIONS) \
	&& $($(PKG)_CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
