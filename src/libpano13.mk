# This file is part of MXE.
# See index.html for further information.

PKG             := libpano13
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.18_rc2
$(PKG)_CHECKSUM := 23849bdbdfc9176a2b53d157e58bd24aa0e7276e
$(PKG)_SUBDIR   := $(PKG)-$(word 1,$(subst _, ,$($(PKG)_VERSION)))
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/panotools/$(PKG)/$($(PKG)_SUBDIR)/$($(PKG)_FILE)
$(PKG)_DEPS     := jpeg tiff libpng zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/api/file/index/project-id/96188/rss?path=/libpano13' | \
    $(SED) -n 's,.*libpano13-\([0-9].*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,WINDOWSX\.H,windowsx.h,'                                                  '$(1)/sys_win.h'
    $(SED) -i 's,\$${WINDRES-windres},$(MXE_WINDRES),'                                  '$(1)/build/win32/compile-resource'
    $(SED) -i 's,m4 -DBUILDNUMBER=\$$buildnumber,$(SED) "s/BUILDNUMBER/\$$buildnumber/g",' '$(1)/build/win32/compile-resource'
    $(SED) -i 's,\(@HAVE_MINGW_TRUE@am__objects_4 = .*\),\1 ppm.lo,'                       '$(1)/Makefile.in'
    $(SED) -i 's,\(@HAVE_MINGW_TRUE@WIN_SRC = .*\),\1 ppm.c,'                              '$(1)/Makefile.in'
    $(SED) -i 's,mv.*libpano13\.dll.*,,'                                                   '$(1)/Makefile.in'
    cd '$(1)' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --with-jpeg='$(HOST_LIBDIR)' \
        --with-tiff='$(HOST_LIBDIR)' \
        --with-png='$(HOST_LIBDIR)' \
        --with-zlib='$(HOST_LIBDIR)' \
        LIBS="`'$(MXE_PKG_CONFIG)' --libs libtiff-4`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
