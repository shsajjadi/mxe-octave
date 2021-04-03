# This file is part of MXE.
# See index.html for further information.

PKG             := lapack
$(PKG)_VERSION  := 3.9.1
$(PKG)_CHECKSUM := ccb1e9cb6e7fa7db8a680292457d7d990f25d286
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/Reference-LAPACK/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := blas

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_BLAS_CONFIG_OPTS := -DBLAS_LIBRARIES="$(HOST_BINDIR)/libblas.dll $(HOST_BINDIR)/libxerbla.dll"
else
    ifeq ($(MXE_WINDOWS_BUILD),yes)
        $(PKG)_BLAS_CONFIG_OPTS := \
            -DBLAS_LIBRARIES="-L$(HOST_PREFIX)/lib -lblas -lxerbla" \
            -DBLAS_LINKER_FLAGS="-L$(HOST_PREFIX)/lib -lblas -lxerbla"
        $(PKG)_BLAS_LIBS := -lblas -lxerbla
    else
        $(PKG)_BLAS_CONFIG_OPTS := \
            -DBLAS_LIBRARIES="-L$(HOST_PREFIX)/lib -lblas" \
            -DBLAS_LINKER_FLAGS="-L$(HOST_PREFIX)/lib -lblas"
        $(PKG)_BLAS_LIBS := -lblas
    endif
endif

ifeq ($(ENABLE_FORTRAN_INT64),yes)
    $(PKG)_DEFAULT_INTEGER_8_FLAG := -fdefault-integer-8
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    define $(PKG)_BUILD
        cd '$(1)' && \
            cp INSTALL/make.inc.gfortran make.inc && \
            sed -i -e 's/\(FORTRAN[ ]*\)=.*/\1= $(MXE_F77)/' \
                   -e 's/\(LOADER[ ]*\)=.*/\1= $(MXE_F77)/' \
                   -e 's/\(CC[ ]*\)=.*/\1= $(MXE_CC)/' \
                   -e 's/\(CFLAGS[ ]*\)=.*/\1= -O2/' make.inc

        $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1 lapacklib

        if [ $(BUILD_SHARED) = yes ]; then \
            $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/liblapack.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)' $($(PKG)_BLAS_LIBS); \
        fi

        $(INSTALL) -d '$(HOST_LIBDIR)/pkgconfig' 
        $(SED) -e 's/@LAPACK_VERSION@/$($(PKG)_VERSION)/' \
               -e 's,@prefix@,$(HOST_PREFIX),' \
               -e 's,@libdir@,$${prefix}/lib,' '$(1)/lapack.pc.in' > '$(1)/lapack.pc'
        $(INSTALL) '$(1)/lapack.pc' '$(HOST_LIBDIR)/pkgconfig/'

    endef
else
    define $(PKG)_BUILD
        mkdir '$(1)/build'
        cd '$(1)/build' && cmake \
            $(CMAKE_CCACHE_FLAGS) \
            $(CMAKE_BUILD_SHARED_OR_STATIC) \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
            -DCMAKE_AR='$(MXE_AR)' \
            -DCMAKE_RANLIB='$(MXE_RANLIB)' \
            -DCMAKE_Fortran_FLAGS='$($(PKG)_DEFAULT_INTEGER_8_FLAG)' \
            -DBUILD_DEPRECATED=ON \
            -DBUILD_SHARED_LIBS=$(if $(findstring yes,$(BUILD_SHARED)),ON,OFF) \
            $($(PKG)_BLAS_CONFIG_OPTS) \
            $(1)
        $(MAKE) -C '$(1)/build/SRC' -j '$(JOBS)' VERBOSE=1 install DESTDIR='$(3)'
    endef
endif
