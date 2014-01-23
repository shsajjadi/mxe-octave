# This file is part of MXE.
# See index.html for further information.

PKG             := build-python
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 8328d9f1d55574a287df384f4931a3942f03da64
$(PKG)_SUBDIR   := Python-$($(PKG)_VERSION)
$(PKG)_FILE     := Python-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.python.org/ftp/python/2.7.6/$($(PKG)_FILE)
$(PKG)_DEPS     := build-gcc

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
