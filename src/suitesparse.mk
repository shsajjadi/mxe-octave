# This file is part of MXE.
# See index.html for further information.

PKG             := suitesparse
$(PKG)_VERSION  := 4.5.6
$(PKG)_CHECKSUM := 06ed5f6f61bfe09f08ce03971a24381a627446b1
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://faculty.cse.tamu.edu/davis/SuiteSparse/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/SuiteSparse/$($(PKG)_FILE)
$(PKG)_DEPS     := openblas lapack libgomp

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_DESTDIR :=
else
  $(PKG)_DESTDIR := $(3)
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://faculty.cse.tamu.edu/davis/suitesparse.html' | \
    $(SED) -n 's,.*SuiteSparse-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef


$(PKG)_CPPFLAGS := -DNTIMER

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CPPFLAGS += -DLONGBLAS='long long'
  else
    $(PKG)_CPPFLAGS += -DLONGBLAS='long'
  endif
endif

$(PKG)_MAKE_OPTS = \
    UNAME=Windows \
    CPPFLAGS="$($(PKG)_CPPFLAGS)" \
    CC='$(MXE_CC)' \
    CXX='$(MXE_CXX)' \
    CPLUSPLUS='$(MXE_CXX)' \
    F77='$(MXE_F77)' \
    FFLAGS='$(MXE_FFLAGS)' \
    CFLAGS='$(MXE_CFLAGS)' \
    CXXFLAGS='$(MXE_CXXFLAGS)' \
    AR='$(MXE_AR)' \
    RANLIB='$(MXE_RANLIB)' \
    BLAS="`'$(TARGET)-pkg-config' --libs openblas`" \
    LAPACK='-llapack' \
    CHOLMOD_CONFIG='-DNPARTITION'

$(PKG)_cputype = $(shell uname -m | sed "s/\\ /_/g")
$(PKG)_systype = $(shell uname -s)
$(PKG)_METIS_BUILDDIR = build/$($(PKG)_systype)-$($(PKG)_cputype)
$(PKG)_METIS_CONFIG_FLAGS = -DCMAKE_VERBOSE_MAKEFILE=1 \
    -DGKLIB_PATH=$(1)/metis-5.1.0/GKlib \
    -DCMAKE_INSTALL_PREFIX=$(1) \
    -DSHARED=1

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
    mkdir -p $($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/
    cp $(1)/metis-5.1.0/$($(PKG)_METIS_BUILDDIR)/libmetis/libmetis.* $($(PKG)_DESTDIR)$(HOST_BINDIR)
    cp $(1)/metis-5.1.0/include/metis.h $($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/
    chmod 755 $($(PKG)_DESTDIR)$(HOST_BINDIR)/libmetis.*
    chmod 644 $($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/metis.h

    # build all
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        $($(PKG)_MAKE_OPTS) \
        MY_METIS_LIB=$($(PKG)_DESTDIR)$(HOST_BINDIR) \
        library

    # install libraries and headers
    $(MAKE) -C '$(1)' -j 1 install \
        $($(PKG)_MAKE_OPTS) \
        INSTALL_INCLUDE='$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/' \
        INSTALL_LIB='$($(PKG)_DESTDIR)$(HOST_LIBDIR)' \
        INSTALL_SO='$($(PKG)_DESTDIR)$(HOST_BINDIR)'
endef

