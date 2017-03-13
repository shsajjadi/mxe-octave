# This file is part of MXE.
# See index.html for further information.

PKG             := libidn2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.16
$(PKG)_CHECKSUM := 26311b538897a8ed0569922132f2139ee3ec6a28
$(PKG)_SUBDIR   := libidn2-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://alpha.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext libiconv libunistring

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://gitlab.com/jas/libidn2/tags' | \
    $(SED) -n 's,^libidn2-\([0-9\.]*)$,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS) DESTDIR='$(3)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
