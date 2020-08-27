# This file is part of MXE.
# See index.html for further information.

PKG             := suitesparse
$(PKG)_VERSION  := 5.7.2
$(PKG)_CHECKSUM := ccc50177425d0d9bfe878786b8f2729c247efa90
$(PKG)_SUBDIR   := SuiteSparse-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := blas lapack
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += libgomp
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_DESTDIR :=
else
  $(PKG)_DESTDIR := $(3)
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/DrTimothyAldenDavis/SuiteSparse/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef


$(PKG)_CPPFLAGS := -DNTIMER

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CPPFLAGS += -DLONGBLAS='long long'
  else
    $(PKG)_CPPFLAGS += -DLONGBLAS='long'
  endif
endif

ifeq ($(USE_CCACHE),yes)
    $(PKG)_COMPILER_OPTS := CC='$(CCACHE) $(MXE_CC)' \
        CXX='$(CCACHE) $(MXE_CXX)' \
        CPLUSPLUS='$(CCACHE) $(MXE_CXX)' \
        F77='$(CCACHE) $(MXE_F77)'
    $(PKG)_CMAKE_CCACHE_OPTS := -DCMAKE_CXX_COMPILER_LAUNCHER='$(CCACHE)' \
        -DCMAKE_C_COMPILER_LAUNCHER='$(CCACHE)' \
        -DCMAKE_Fortran_COMPILER_LAUNCHER='$(CCACHE)'
else
    $(PKG)_COMPILER_OPTS := CC='$(MXE_CC)' \
        CXX='$(MXE_CXX)' \
        CPLUSPLUS='$(MXE_CXX)' \
        F77='$(MXE_F77)'
endif

$(PKG)_MAKE_OPTS = \
    CPPFLAGS="$($(PKG)_CPPFLAGS)" \
    $($(PKG)_COMPILER_OPTS) \
    FFLAGS='$(MXE_FFLAGS)' \
    CFLAGS='$(MXE_CFLAGS)' \
    CXXFLAGS='$(MXE_CXXFLAGS)' \
    AR='$(MXE_AR)' \
    RANLIB='$(MXE_RANLIB)' \
    BLAS="-lblas -lgfortran" \
    LAPACK='-llapack' \
    CHOLMOD_CONFIG='-DNPARTITION' \
    CMAKE_OPTIONS='-DCMAKE_TOOLCHAIN_FILE="$(CMAKE_TOOLCHAIN_FILE)" $($(PKG)_CMAKE_CCACHE_OPTS)'

ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_MAKE_OPTS += \
        UNAME=Windows
    $(PKG)_SO_DIR := $($(PKG)_DESTDIR)$(HOST_BINDIR)
else
    $(PKG)_SO_DIR := $($(PKG)_DESTDIR)$(HOST_LIBDIR)
endif

$(PKG)_cputype = $(shell uname -m | sed "s/\\ /_/g")
$(PKG)_systype = $(shell uname -s)
$(PKG)_METIS_BUILDDIR = build/$($(PKG)_systype)-$($(PKG)_cputype)
$(PKG)_METIS_CONFIG_FLAGS = -DCMAKE_VERBOSE_MAKEFILE=1 \
    -DGKLIB_PATH=$(1)/metis-5.1.0/GKlib \
    -DCMAKE_INSTALL_PREFIX=$(1) \
    -DSHARED=1 \
    $($(PKG)_CMAKE_CCACHE_OPTS)

define $(PKG)_BUILD
    # build metis
    mkdir $(1)/metis-5.1.0/$($(PKG)_METIS_BUILDDIR)
    cd $(1)/metis-5.1.0/$($(PKG)_METIS_BUILDDIR) && \
        cmake $(1)/metis-5.1.0 \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
            $($(PKG)_METIS_CONFIG_FLAGS)
    $(MAKE) -C '$(1)/metis-5.1.0/$($(PKG)_METIS_BUILDDIR)' metis -j '$(JOBS)'

    # install metis
    mkdir -p $($(PKG)_DESTDIR)$(HOST_LIBDIR)
    mkdir -p $($(PKG)_SO_DIR)
    mkdir -p $($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/
    cp $(1)/metis-5.1.0/$($(PKG)_METIS_BUILDDIR)/libmetis/libmetis.* $($(PKG)_SO_DIR)
    cp $(1)/metis-5.1.0/include/metis.h $($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/
    chmod 755 $($(PKG)_SO_DIR)/libmetis.*
    chmod 644 $($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/metis.h

    # build all
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        $($(PKG)_MAKE_OPTS) \
        MY_METIS_LIB=$($(PKG)_SO_DIR) \
        library

    # install libraries and headers
    $(MAKE) -C '$(1)' -j 1 install \
        $($(PKG)_MAKE_OPTS) \
        INSTALL_INCLUDE='$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/' \
        INSTALL_LIB='$($(PKG)_DESTDIR)$(HOST_LIBDIR)' \
        INSTALL_SO='$($(PKG)_SO_DIR)'

    # some dependers (e.g. SUNDIALS IDA) won't find libraries with version suffix
    if [ $(MXE_WINDOWS_BUILD) = no ]; then \
      cd '$($(PKG)_DESTDIR)$(HOST_LIBDIR)' && ln -sf libsuitesparseconfig.so.$($(PKG)_VERSION) libsuitesparseconfig.so; \
      cd '$($(PKG)_DESTDIR)$(HOST_LIBDIR)' && ln -sf libamd.so.2 libamd.so; \
      cd '$($(PKG)_DESTDIR)$(HOST_LIBDIR)' && ln -sf libbtf.so.1 libbtf.so; \
      cd '$($(PKG)_DESTDIR)$(HOST_LIBDIR)' && ln -sf libcolamd.so.2 libcolamd.so; \
      cd '$($(PKG)_DESTDIR)$(HOST_LIBDIR)' && ln -sf libklu.so.1 libklu.so; \
    fi
endef

