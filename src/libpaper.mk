# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libpaper
PKG             := libpaper
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.24
$(PKG)_CHECKSUM := 6927f75d126373d32d89751d2a7fe3e99cc9b4a1
$(PKG)_SUBDIR   := libpaper-$($(PKG)_VERSION)
$(PKG)_FILE     := libpaper_$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://packages.debian.org/unstable/libpaper1
$(PKG)_URL      := http://ftp.debian.org/debian/pool/main/libp/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://packages.debian.org/unstable/source/libpaper' | \
    $(SED) -n 's,.*libpaper_\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
