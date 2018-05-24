# This file is part of MXE.
# See index.html for further information.

PKG             := gtkmm2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.24.0
$(PKG)_CHECKSUM := 9b9e68360fb3f5faa7f221acba56f0d75a8198d2
$(PKG)_SUBDIR   := gtkmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkmm-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnome.org/pub/gnome/sources/gtkmm/$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     := gtk2 libsigc++ pangomm cairomm atkmm

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/GNOME/gtkmm/tags | \
    $(SED) -n 's|.*releases/tag/\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        MAKE=$(MAKE)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= doc_install='# DISABLED: doc-install.pl'

    '$(MXE_CXX)' \
        -W -Wall -Werror -pedantic -std=c++0x \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-gtkmm2.exe' \
        `'$(MXE_PKG_CONFIG)' gtkmm-2.4 --cflags --libs`
endef
