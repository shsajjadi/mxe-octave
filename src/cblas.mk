# This file is part of MXE.
# See index.html for further information.

PKG             := cblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := d6970cf52592ef67674a61c78bbd055a4e9d4680
$(PKG)_SUBDIR   := CBLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_URL      := http://www.netlib.org/blas/blast-forum/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/blas/blast-forum/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    cp '$(1)/Makefile.LINUX' '$(1)/Makefile.MINGW32'
    $(SED) -i 's,CBDIR =.*,CBDIR = $(1),g'         '$(1)/Makefile.MINGW32'
    $(SED) -i 's,FC =.*,FC = $(MXE_CXX)fortran,g' '$(1)/Makefile.MINGW32'
    $(SED) -i 's, make , $(MAKE) ,g'               '$(1)/Makefile'
    rm '$(1)/Makefile.in'
    $(LN_SF) '$(1)/Makefile.MINGW32' '$(1)/Makefile.in'
    mkdir '$(1)/MINGW32'
    $(MAKE) -C '$(1)' -j '$(JOBS)' alllib
    cd '$(1)' && $(MXE_AR) cr libcblas.a src/*.o

    $(INSTALL) -d                           '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libcblas.a'      '$(HOST_LIBDIR)'
    $(INSTALL) -d                           '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/include/cblas.h'     '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/include/cblas_f77.h' '$(HOST_INCDIR)'
endef
