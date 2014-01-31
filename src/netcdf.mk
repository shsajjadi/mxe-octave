# This file is part of MXE.
# See index.html for further information.

PKG             := netcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.0
$(PKG)_CHECKSUM := 31b4b3b17146cc8c14a8c7be3fe5f28e5a8a5deb
$(PKG)_SUBDIR   := netcdf-$($(PKG)_VERSION)
$(PKG)_FILE     := netcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.unidata.ucar.edu/downloads/netcdf/ftp/netcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := curl hdf5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.unidata.ucar.edu/downloads/netcdf/current/index.jsp' | \
    $(SED) -n 's,.*netcdf-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

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
        --enable-dll \
	&& $($(PKG)_CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
