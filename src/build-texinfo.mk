# This file is part of MXE.
# See index.html for further information.

PKG             := build-texinfo
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := ed5aa2b93910dde4eacd5d649329a49db701878c
$(PKG)_SUBDIR   := texinfo-$($(PKG)_VERSION)
$(PKG)_FILE     := texinfo-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/texinfo/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
