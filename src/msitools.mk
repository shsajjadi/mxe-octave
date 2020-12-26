# This file is part of MXE.
# See index.html for further information.

PKG             := msitools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.92
$(PKG)_CHECKSUM := 695933981b679f71a5aed21d14d2fb54ae0e7102
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/$(PKG)/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcab glib libgsf libxml2

$(PKG)_PREFIX   := '$(HOST_PREFIX)'

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_CONFIGURE_EXTRA_OPTIONS := \
        UUID_CFLAGS=-I. \
        UUID_LIBS=-lrpcrt4 \
        WIXL_CFLAGS="`PKG_CONFIG_PATH=$(HOST_LIBDIR)/pkgconfig $(MXE_PKG_CONFIG) --cflags gio-2.0 libgcab-1.0 libxml-2.0`" \
        WIXL_LIBS="`PKG_CONFIG_PATH=$(HOST_LIBDIR)/pkgconfig $(MXE_PKG_CONFIG) --libs gio-2.0 libgcab-1.0 libxml-2.0` -lrpcrt4"
    $(PKG)_PREFIX := $(shell cd $(HOST_PREFIX) && pwd -W)
endif

define $(PKG)_BUILD
    cd '$(1)' && './configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$($(PKG)_PREFIX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
	$($(PKG)_CONFIGURE_EXTRA_OPTIONS) \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install noinst_PROGRAMS=
endef
