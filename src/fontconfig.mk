# fontconfig

PKG             := fontconfig
$(PKG)_VERSION  := 2.7.1
$(PKG)_CHECKSUM := 2e66fdf848f5002ba9a095998604ead2d3c392f1
$(PKG)_SUBDIR   := fontconfig-$($(PKG)_VERSION)
$(PKG)_FILE     := fontconfig-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://fontconfig.org/
$(PKG)_URL      := http://fontconfig.org/release/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc freetype expat

define $(PKG)_UPDATE
    wget -q -O- 'http://fontconfig.org/release/' | \
    $(SED) -n 's,.*fontconfig-\([0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # ensure there is no (buggy) attempt to install the *.dll.a file
    # (remove this line of you want to link dynamically)
    $(SED) 's,^install-data-local:.*,install-data-local:,' -i '$(1)/src/Makefile.in'
    # wine confuses the cross-compiling detection, so set it explicitly
    $(SED) 's,cross_compiling=no,cross_compiling=yes,' -i '$(1)/configure'
    $(SED) 's,^\(Libs:.*\),\1 @EXPAT_LIBS@ @FREETYPE_LIBS@,' -i '$(1)/fontconfig.pc.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --with-arch='$(TARGET)' \
        --with-freetype-config='$(PREFIX)/$(TARGET)/bin/freetype-config' \
        --with-expat='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
