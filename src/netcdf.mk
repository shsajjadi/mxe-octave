# This file is part of MXE.
# See index.html for further information.

PKG             := netcdf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.3.2
$(PKG)_CHECKSUM := 6e1bacab02e5220954fe0328d710ebb71c071d19
$(PKG)_SUBDIR   := netcdf-$($(PKG)_VERSION)
$(PKG)_FILE     := netcdf-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.unidata.ucar.edu/pub/netcdf/old/$($(PKG)_FILE)
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
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_CONFIGURE_OPTIONS) \
	&& $($(PKG)_CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
