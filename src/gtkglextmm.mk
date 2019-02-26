# This file is part of MXE.
# See index.html for further information.

PKG             := gtkglextmm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0
$(PKG)_CHECKSUM := 5cd489e07517a88262cd6050f723227664e82996
$(PKG)_SUBDIR   := gtkglextmm-$($(PKG)_VERSION)
$(PKG)_FILE     := gtkglextmm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gtkglext/gtkglextmm/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gtkglext gtkmm2

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://ftp.gnome.org/pub/gnome/sources/gtkglextmm/1.2/' | \
    $(SED) -n 's,.*gtkglextmm-\(1[^>]*\)\.tar.*,\1,ip' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        bin_PROGRAMS= \
        sbin_PROGRAMS= \
        noinst_PROGRAMS= \
        INFO_DEPS=

    '$(MXE_CXX)' \
        -W -Wall -Werror -pedantic -std=c++0x \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-gtkglextmm.exe' \
        `'$(MXE_PKG_CONFIG)' gtkglextmm-1.2 --cflags --libs`
endef
