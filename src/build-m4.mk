# This file is part of MXE.
# See index.html for further information.

PKG             := build-m4
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 44b3ed8931f65cdab02aee66ae1e49724d2551a4
$(PKG)_SUBDIR   := m4-$($(PKG)_VERSION)
$(PKG)_FILE     := m4-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/m4/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
define $(PKG)_BUILD
    echo "Ignoring build-m4  for native mingw build"
endef
else
define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
endif
