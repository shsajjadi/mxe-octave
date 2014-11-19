# This file is part of MXE.
# See index.html for further information.

PKG             := gc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.2d
$(PKG)_CHECKSUM := b43573800e27361da78f05a2e98394521cfa04fc
$(PKG)_SUBDIR   := $(PKG)-7.2
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.hpl.hp.com/personal/Hans_Boehm/$(PKG)/$(PKG)_source/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --enable-threads=win32 \
        --enable-cplusplus
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
