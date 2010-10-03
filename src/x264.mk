# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# x264
PKG             := x264
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 20101002-2245
$(PKG)_CHECKSUM := 65c72fc336dc1170b6f62549f92e1e8bd97b30d0
$(PKG)_SUBDIR   := $(PKG)-snapshot-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-snapshot-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://www.videolan.org/developers/x264.html
$(PKG)_URL      := http://ftp.videolan.org/pub/videolan/$(PKG)/snapshots/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://ftp.videolan.org/pub/videolan/x264/snapshots/' | \
    $(SED) -n 's,.*<a href="x264-snapshot-\([0-9][^"]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --cross-prefix='$(TARGET)'- \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-pthread
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
