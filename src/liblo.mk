# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# liblo
PKG             := liblo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.26
$(PKG)_CHECKSUM := 21942c8f19e9829b5842cb85352f98c49dfbc823
$(PKG)_SUBDIR   := liblo-$($(PKG)_VERSION)
$(PKG)_FILE     := liblo-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://liblo.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/liblo/liblo/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/liblo/files/liblo/) | \
    $(SED) -n 's,.*liblo-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
