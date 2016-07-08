# This file is part of MXE.
# See index.html for further information.

PKG             := build-xz
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.2
$(PKG)_CHECKSUM := 14663612422ab61386673be78fbb2556f50a1f08
$(PKG)_SUBDIR   := xz-$($(PKG)_VERSION)
$(PKG)_FILE     := xz-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://tukaani.org/xz/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://tukaani.org/xz/' | \
    $(SED) -n 's,.*xz-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && './configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --disable-threads \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
endef
