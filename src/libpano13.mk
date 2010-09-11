# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libpano13
PKG             := libpano13
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.17
$(PKG)_CHECKSUM := 418689985ea622bc234cd4eccec42180c12821b2
$(PKG)_SUBDIR   := libpano13-$(word 1,$(subst _, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := libpano13-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://panotools.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/panotools/libpano13/libpano13-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff libpng zlib

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/api/file/index/project-id/96188/rss?path=/libpano13' | \
    grep '/download</link>' | \
    $(SED) -n 's,.*libpano13-\([0-9].*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,WINDOWSX\.H,windowsx.h,'                                                  '$(1)/sys_win.h'
    $(SED) -i 's,\$${WINDRES-windres},$(TARGET)-windres,'                                  '$(1)/build/win32/compile-resource'
    $(SED) -i 's,m4 -DBUILDNUMBER=\$$buildnumber,$(SED) "s/BUILDNUMBER/\$$buildnumber/g",' '$(1)/build/win32/compile-resource'
    $(SED) -i 's,mv.*libpano13\.dll.*,,'                                                   '$(1)/Makefile.in'
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --with-jpeg='$(PREFIX)/$(TARGET)'/lib \
        --with-tiff='$(PREFIX)/$(TARGET)'/lib \
        --with-png='$(PREFIX)/$(TARGET)'/lib \
        --with-zlib='$(PREFIX)/$(TARGET)'/lib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
