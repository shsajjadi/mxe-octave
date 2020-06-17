# This file is part of MXE.
# See index.html for further information.

PKG             := libbiosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.3
$(PKG)_CHECKSUM := 5e2639689a35190560cc8338f561febd54956344
$(PKG)_SUBDIR   := biosig-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)
$(PKG)_DEPS     := suitesparse zlib libiberty libiconv lapack tinyxml dcmtk

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://biosig.sourceforge.io/download.html' | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        head -1
endef


define $(PKG)_BUILD
    cd '$(1)/biosig4c++' && ../configure \
        ac_cv_func_malloc_0_nonnull=yes \
        ac_cv_func_realloc_0_nonnull=yes \
        --prefix=$(HOST_PREFIX) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS)

    # make sure NDEBUG is defined
    $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/biosig4c++/Makefile

    #$(SED) -i 's| -fstack-protector | |g' '$(1)'/biosig4c++/Makefile
    #$(SED) -i 's| -D_FORTIFY_SOURCE=2 | |g' '$(1)'/biosig4c++/Makefile
    #$(SED) -i 's| -lssp | |g' '$(1)'/biosig4c++/Makefile

  
    TARGET=$(TARGET) CROSS=$(TARGET) $(MAKE) -C '$(1)/biosig4c++' libbiosig


    # install files
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig.h'             '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig2.h'            '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/gdftime.h'            '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/biosig-dev.h'         '$(HOST_INCDIR)/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.a'          '$(HOST_LIBDIR)/'
    #$(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.def'        '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.dll.a'      '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.dll'        '$(HOST_BINDIR)/'

    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.a'             '$(HOST_LIBDIR)/'
    #$(INSTALL) -m644 '$(1)/biosig4c++/libgdf.def'           '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.dll.a'         '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libgdf.dll'           '$(HOST_BINDIR)/'


    $(INSTALL) -m644 '$(1)/biosig4c++/physicalunits.h'      '$(HOST_INCDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.a'   '$(HOST_LIBDIR)/'
    #$(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.def' '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.dll.a' '$(HOST_LIBDIR)/'
    $(INSTALL) -m644 '$(1)/biosig4c++/libphysicalunits.dll' '$(HOST_BINDIR)/'

    if [ "$(MXE_WINDOWS_BUILD)" == "yes" ]; then \
        $(SED) -i '/^Libs:/ s/$$/ -liconv -lws2_32/' $(1)/biosig4c++/libbiosig.pc; \
    fi
    $(INSTALL) -m644 '$(1)/biosig4c++/libbiosig.pc'         '$(HOST_LIBDIR)/pkgconfig/'

endef

