# This file is part of MXE.
# See index.html for further information.

PKG             := libbiosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.1
$(PKG)_CHECKSUM := 31812a48bb1df28404eba7b5d3b150f30f587826
$(PKG)_SUBDIR   := biosig4c++-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig4c++-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)
$(PKG)_DEPS     := suitesparse zlib libiberty libiconv lapack tinyxml dcmtk

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://biosig.sourceforge.io/download.html' | \
        $(GREP) biosig4c | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        $(SORT) -V | \
        tail -1
endef

define $(PKG)_BUILD_PRE

    cd '$(1)' && ./configure \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
	--prefix=$(HOST_PREFIX) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS)

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/Makefile

    #$(SED) -i 's| -fstack-protector | |g' '$(1)'/Makefile
    #$(SED) -i 's| -D_FORTIFY_SOURCE=2 | |g' '$(1)'/Makefile
    #$(SED) -i 's| -lssp | |g' '$(1)'/Makefile

    TARGET='$(TARGET)' $(MAKE) -C '$(1)' clean
    TARGET='$(TARGET)' $(MAKE) -C '$(1)' -j '$(JOBS)' \
		libbiosig.a libgdf.a libphysicalunits.a \
    		libbiosig.def libgdf.def libphysicalunits.def

endef

define $(PKG)_BUILD_POST

    $(INSTALL) -m644 '$(1)/biosig.h'             '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/biosig2.h'            '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/gdftime.h'            '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/biosig-dev.h'         '$(HOST_INCDIR)/'

    $(INSTALL) -m644 '$(1)/libbiosig.a'          '$(HOST_LIBDIR)/'
    #$(INSTALL) -m644 '$(1)/libbiosig.def' 	 '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll.a' 	 '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/libbiosig.dll' 	 '$(HOST_BINDIR)/'

    $(INSTALL) -m644 '$(1)/libgdf.a'             '$(HOST_LIBDIR)/'
    #$(INSTALL) -m644 '$(1)/libgdf.def' 	 '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/libgdf.dll.a' 	 '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/libgdf.dll'	 	 '$(HOST_BINDIR)/'


    $(INSTALL) -m644 '$(1)/physicalunits.h'      '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.a'   '$(HOST_LIBDIR)/'
    #$(INSTALL) -m644 '$(1)/libphysicalunits.def' '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll.a' '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/libphysicalunits.dll' '$(HOST_BINDIR)/'

    if [ "$(MXE_WINDOWS_BUILD)" == "yes" ]; then \
        $(SED) -i '/^Libs:/ s/$$/ -liconv -lws2_32/' $(1)/libbiosig.pc; \
    fi
    $(INSTALL) -m644 '$(1)/libbiosig.pc'         '$(HOST_LIBDIR)/pkgconfig/'

endef


define $(PKG)_BUILD
    $($(PKG)_BUILD_PRE)
    TARGET=$(TARGET) CROSS=$(TARGET) $(MAKE) -C '$(1)' libbiosig
    $($(PKG)_BUILD_POST)
endef

