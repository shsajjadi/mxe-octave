# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# id3lib
PKG             := id3lib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.3
$(PKG)_CHECKSUM := c92c880da41d1ec0b242745a901702ae87970838
$(PKG)_SUBDIR   := id3lib-$($(PKG)_VERSION)
$(PKG)_FILE     := id3lib-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://id3lib.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/id3lib/id3lib/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/id3lib/files/id3lib/) | \
    $(SED) -n 's,.*id3lib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf && autoconf && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
