# This file is part of MXE.
# See index.html for further information.

PKG             := libxml2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.8
$(PKG)_CHECKSUM := 66bcefd98a6b7573427cf66f9d3841b59eb5b8c3
$(PKG)_SUBDIR   := libxml2-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://xmlsoft.org/libxml2/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS := xz
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/GNOME/libxml2/tags | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | grep -v 'rc' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,`uname`,MinGW,g' '$(1)/xml2-config.in'
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --without-debug \
        --prefix='$(HOST_PREFIX)' \
        --with-zlib='$(HOST_PREFIX)' \
        --without-python \
        --without-threads && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install noinst_PROGRAMS= DESTDIR='$(3)'

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf "$(3)$(HOST_PREFIX)/share/gtk-doc"; \
      rm -rf "$(3)$(HOST_PREFIX)/share/doc/$($(PKG)_SUBDIR)/html"; \
      rm -rf "$(3)$(HOST_PREFIX)/share/doc/$($(PKG)_SUBDIR)/examples"; \
    fi
endef

