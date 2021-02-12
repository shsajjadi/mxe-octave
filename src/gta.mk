# This file is part of MXE.
# See index.html for further information.

PKG             := gta
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.8
$(PKG)_CHECKSUM := 795832a042be4102321d862246cc4afdb929dc57
$(PKG)_SUBDIR   := libgta-$($(PKG)_VERSION)
$(PKG)_FILE     := libgta-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.savannah.gnu.org/releases/gta/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib bzip2 xz

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=gta.git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>libgta-\([0-9.]*\)<.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --disable-reference \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
