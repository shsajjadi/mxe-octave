# This file is part of MXE.
# See index.html for further information.

PKG             := libidn
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.33
$(PKG)_CHECKSUM := 57872fdc665dcc585e16f4ac0bb35374b1103f7e
$(PKG)_SUBDIR   := libidn-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=libidn.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-csharp \
        --prefix='$(HOST_PREFIX)' \
        --with-libiconv-prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DIABLE_PROGS) DESTDIR='$(3)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
