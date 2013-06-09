# This file is part of MXE.
# See index.html for further information.

PKG             := gdal
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 7eda6a4d735b8d6903740e0acdd702b43515e351
$(PKG)_SUBDIR   := gdal-$($(PKG)_VERSION)
$(PKG)_FILE     := gdal-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.osgeo.org/gdal/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.remotesensing.org/gdal/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib libpng tiff libgeotiff jpeg jasper giflib expat sqlite curl geos postgresql gta

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://trac.osgeo.org/gdal/wiki/DownloadSource' | \
    $(SED) -n 's,.*gdal-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # The option '--without-threads' means native win32 threading without pthread.
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-bsb \
        --with-grib \
        --with-ogr \
        --with-vfk \
        --with-pam \
        --without-threads \
        --with-libz='$(HOST_PREFIX)' \
        --with-png='$(HOST_PREFIX)' \
        --with-libtiff='$(HOST_PREFIX)' \
        --with-geotiff='$(HOST_PREFIX)' \
        --with-jpeg='$(HOST_PREFIX)' \
        --with-jasper='$(HOST_PREFIX)' \
        --with-gif='$(HOST_PREFIX)' \
        --with-expat='$(HOST_PREFIX)' \
        --with-sqlite3='$(HOST_PREFIX)' \
        --with-curl='$(HOST_BINDIR)/curl-config' \
        --with-geos='$(HOST_BINDIR)/geos-config' \
        --with-pg='$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pg_config' \
        --with-gta='$(HOST_PREFIX)' \
        --without-odbc \
        --without-static-proj4 \
        --without-xerces \
        --without-grass \
        --without-libgrass \
        --without-spatialite \
        --without-cfitsio \
        --without-pcraster \
        --without-netcdf \
        --without-pcidsk \
        --without-ogdi \
        --without-fme \
        --without-hdf4 \
        --without-hdf5 \
        --without-ecw \
        --without-kakadu \
        --without-mrsid \
        --without-jp2mrsid \
        --without-msg \
        --without-oci \
        --without-mysql \
        --without-ingres \
        --without-dods-root \
        --without-dwgdirect \
        --without-idb \
        --without-sde \
        --without-epsilon \
        --without-perl \
        --without-php \
        --without-ruby \
        --without-python \
        LIBS="-ljpeg -lsecur32 `'$(MXE_PKG_CONFIG)' --libs openssl libtiff-4`"
    $(MAKE) -C '$(1)'       -j 1 lib-target
    $(MAKE) -C '$(1)'       -j 1 install-lib
    $(MAKE) -C '$(1)/port'  -j 1 install
    $(MAKE) -C '$(1)/gcore' -j 1 install
    $(MAKE) -C '$(1)/frmts' -j 1 install
    $(MAKE) -C '$(1)/alg'   -j 1 install
    $(MAKE) -C '$(1)/ogr'   -j 1 install OGR_ENABLED=
    $(MAKE) -C '$(1)/apps'  -j 1 install BIN_LIST=
    $(LN_SF) '$(HOST_BINDIR)/gdal-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)gdal-config'
endef
