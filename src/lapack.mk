# This file is part of MXE.
# See index.html for further information.

PKG             := lapack
$(PKG)_CHECKSUM := 93a6e4e6639aaf00571d53a580ddc415416e868b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(ENABLE_OPENBLAS),yes)
  $(PKG)_DEPS     += openblas

  ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_BLAS_CONFIG_OPTS := -DBLAS_LIBRARIES=$(HOST_BINDIR)/libopenblas.dll
  else
    $(PKG)_BLAS_CONFIG_OPTS := -DBLAS_LIBRARIES=openblas
  endif
endif

ifeq ($(ENABLE_64),yes)
  $(PKG)_DEFAULT_INTEGER_8_FLAG := -fdefault-integer-8
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    cd '$(1)' && \
        cp INSTALL/make.inc.gfortran make.inc && \
        sed -i -e 's/\(FORTRAN[ ]*\)=.*/\1= $(MXE_F77)/' \
               -e 's/\(LOADER[ ]*\)=.*/\1= $(MXE_F77)/' \
               -e 's/\(CC[ ]*\)=.*/\1= $(MXE_CC)/' \
               -e 's/\(CFLAGS[ ]*\)=.*/\1= -O2/' make.inc

    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1 lapacklib

    if [ $(BUILD_SHARED) = yes ]; then \
        $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/liblapack.a' --install '$(INSTALL)' --libdir '$(3)$(HOST_LIBDIR)' --bindir '$(3)$(HOST_BINDIR)' -lblas; \
    fi

    $(INSTALL) -d '$(3)$(HOST_LIBDIR)/pkgconfig' 
    $(SED) -e 's/@LAPACK_VERSION@/$($(PKG)_VERSION)/' \
           -e 's,@prefix@,$(HOST_PREFIX),' \
	   -e 's,@libdir@,$${prefix}/lib,' '$(1)/lapack.pc.in' > '$(1)/lapack.pc'
    $(INSTALL) '$(1)/lapack.pc' '$(3)$(HOST_LIBDIR)/pkgconfig/'

endef
else
define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -G 'MSYS Makefiles' \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_Fortran_FLAGS='$($(PKG)_DEFAULT_INTEGER_8_FLAG)' \
        $($(PKG)_BLAS_CONFIG_OPTS) \
        .
    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)' VERBOSE=1 install DESTDIR='$(3)'

    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) '$(1)/lib/liblapack.dll.a' '$(3)$(HOST_LIBDIR)/'; \
      $(INSTALL) '$(1)/lib/liblapack.lib' '$(3)$(HOST_LIBDIR)/'; \
      $(INSTALL) '$(1)/bin/liblapack.dll' '$(3)$(HOST_BINDIR)/'; \
    fi
    if [ $(BUILD_STATIC) = yes ]; then \
      $(INSTALL) '$(1)/lib/liblapack.a' '$(3)$(HOST_LIBDIR)/'; \
    fi

    $(INSTALL) -d '$(3)$(HOST_LIBDIR)/pkgconfig' 
    $(INSTALL) '$(1)/lapack.pc' '$(3)$(HOST_LIBDIR)/pkgconfig/'

endef
endif
else
define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(MXE_AR)' \
        -DCMAKE_RANLIB='$(MXE_RANLIB)' \
        -DCMAKE_Fortran_FLAGS='$($(PKG)_DEFAULT_INTEGER_8_FLAG)' \
        $($(PKG)_BLAS_CONFIG_OPTS) \
        .
    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)' VERBOSE=1 install DESTDIR='$(3)'
endef
endif
