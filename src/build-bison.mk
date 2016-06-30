# This file is part of MXE.
# See index.html for further information.

PKG             := build-bison
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.4
$(PKG)_CHECKSUM := 8270497aad88c7dd4f2c317298c50513fb0c3c8e
$(PKG)_SUBDIR   := bison-$($(PKG)_VERSION)
$(PKG)_FILE     := bison-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/bison/$($(PKG)_FILE)
$(PKG)_DEPS     := build-xz

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
