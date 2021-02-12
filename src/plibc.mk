# This file is part of MXE.
# See index.html for further information.

PKG             := plibc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.7
$(PKG)_CHECKSUM := b545c602dc5b381fcea9d096910dede95168fbeb
$(PKG)_SUBDIR   := PlibC-$($(PKG)_VERSION)
$(PKG)_FILE     := plibc-$($(PKG)_VERSION)-src.tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/plibc/files/plibc/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'TODO: Updates for package plibc  need to be fixed.' >&2;
    echo $(plibc_VERSION)
endef

define $(PKG)_BUILD
    chmod 0755 '$(1)/configure'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
