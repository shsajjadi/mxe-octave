# This file is part of MXE.
# See index.html for further information.

PKG             := x264
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20141130-2245
$(PKG)_CHECKSUM := e2a4f5dd0a773a3e89f7c5cf1b3d2efc95f282b8
$(PKG)_SUBDIR   := $(PKG)-snapshot-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-snapshot-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://download.videolan.org/pub/videolan/$(PKG)/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    date -d yesterday +%Y%m%d-2245
endef

ifeq ($(MXE_NATIVE_BUILD),no)
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --cross-prefix='$(MXE_TOOL_PREFIX)' \
        --disable-lavf \
        --disable-swscale \
        --enable-win32thread
    $(MAKE) -C '$(1)' -j 1 uninstall
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
else
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-lavf \
        --disable-swscale
    $(MAKE) -C '$(1)' -j 1 uninstall
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
endif
