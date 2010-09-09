# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Expat XML Parser
PKG             := expat
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := 663548c37b996082db1f2f2c32af060d7aa15c2d
$(PKG)_SUBDIR   := expat-$($(PKG)_VERSION)
$(PKG)_FILE     := expat-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://expat.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/expat/expat/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/expat/files/) | \
    $(SED) -n 's,.*expat-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
