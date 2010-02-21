# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# TRE
PKG             := tre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.0
$(PKG)_CHECKSUM := a41692e64b40ebae3cffe83931ddbf8420a10ae3
$(PKG)_SUBDIR   := tre-$($(PKG)_VERSION)
$(PKG)_FILE     := tre-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://laurikari.net/tre/
$(PKG)_URL      := http://laurikari.net/tre/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://laurikari.net/tre/download.html' | \
    $(SED) -n 's,.*tre-\([a-z0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-nls
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
