# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# pixman
PKG             := pixman
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.2
$(PKG)_CHECKSUM := beef0a10373f4c551698a376d62af158ac167d87
$(PKG)_SUBDIR   := pixman-$($(PKG)_VERSION)
$(PKG)_FILE     := pixman-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://cairographics.org/
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://cairographics.org/releases/?C=M;O=D' | \
    grep '<a href="pixman-' | \
    $(SED) -n 's,.*<a href="pixman-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^0\.16\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
