# This file is part of MXE.
# See index.html for further information.

PKG             := build-lzip
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.21
$(PKG)_CHECKSUM := 08bea2f275d639bfe85fe30887d269b96eac34e1
$(PKG)_SUBDIR   := lzip-$($(PKG)_VERSION)
$(PKG)_FILE     := lzip-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.savannah.gnu.org/releases/lzip/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.savannah.gnu.org/releases/lzip | \
    $(SED) -n 's,.*<a href="lzip-\([0-9][\.0-9]*\)\.tar\.gz.*,\1,p' | \
    $(SORT) -V | tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && './configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
endef
