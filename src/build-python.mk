# This file is part of MXE.
# See index.html for further information.

PKG             := build-python
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.7
$(PKG)_CHECKSUM := 1db01d7f325d8ceaf986976800106018b82ae45a
$(PKG)_SUBDIR   := Python-$($(PKG)_VERSION)
$(PKG)_FILE     := Python-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.python.org/ftp/python/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := 
ifneq ($(USE_SYSTEM_GCC),yes)
    $(PKG)_DEPS     += build-gcc
endif

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
