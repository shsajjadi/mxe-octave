# This file is part of MXE.
# See index.html for further information.

PKG             := libxml2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.4
$(PKG)_CHECKSUM := 958ae70baf186263a4bd801a81dd5d682aedd1db
$(PKG)_SUBDIR   := libxml2-$($(PKG)_VERSION)
$(PKG)_FILE     := libxml2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://xmlsoft.org/libxml2/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS := xz
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.gnome.org/browse/libxml2/refs/tags' | \
    grep '<a href=' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?h=v\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
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

