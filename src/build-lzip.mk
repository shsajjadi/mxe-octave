# This file is part of MXE.
# See index.html for further information.

PKG             := build-lzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.18
$(PKG)_CHECKSUM := ef42f3209d02c3b3c217a61c8f127bcb8747b128
$(PKG)_SUBDIR   := lzip-$($(PKG)_VERSION)
$(PKG)_FILE     := lzip-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.savannah.gnu.org/releases/lzip/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && './configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
endef
