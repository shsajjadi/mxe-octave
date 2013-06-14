# This file is part of MXE.
# See index.html for further information.

PKG             := libxml++
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 446714be0becb1d1bca914a9a545af96a24de26e
$(PKG)_SUBDIR   := libxml++-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml++-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://ftp.gnome.org/pub/GNOME/sources/libxml++/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := libxml2 glibmm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/libxml++/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CXX="$(MXE_CXX) -mthreads" ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
