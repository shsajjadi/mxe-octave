# This file is part of MXE.
# See index.html for further information.

PKG             := libmng
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.2
$(PKG)_CHECKSUM := 7dd35369ff5916e1823cbacef984ab1b87714b69
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)-devel/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib jpeg lcms

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libmng/files/libmng-devel/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf --install && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
	$(ENABLE_SHARED_OR_STATIC) \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
endef
