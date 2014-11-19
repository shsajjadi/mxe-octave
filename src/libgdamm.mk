# This file is part of MXE.
# See index.html for further information.

# libgdamm
PKG             := libgdamm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.3
$(PKG)_CHECKSUM := f6126d7b46720e3ea4f3d49e03add2e52da233be
$(PKG)_SUBDIR   := libgdamm-$($(PKG)_VERSION)
$(PKG)_FILE     := libgdamm-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/libgdamm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := libgda glibmm

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libgdamm need to be fixed.' >&2;
    echo $(libgdamm_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        CXX='$(MXE_CXX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
