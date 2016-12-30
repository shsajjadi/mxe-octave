# This file is part of MXE.
# See index.html for further information.

PKG             := suitesparse
$(PKG)_VERSION  := 4.2.1
$(PKG)_CHECKSUM := 2fec3bf93314bd14cbb7470c0a2c294988096ed6
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cise.ufl.edu/research/sparse/SuiteSparse/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/SuiteSparse/$($(PKG)_FILE)
$(PKG)_DEPS     := blas lapack

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_DESTDIR :=
else
  $(PKG)_DESTDIR := $(3)
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.cise.ufl.edu/research/sparse/SuiteSparse/' | \
    $(SED) -n 's,.*SuiteSparse-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

$(PKG)_STATICLIBS_1 := \
  SuiteSparse_config/libsuitesparseconfig.a \
  SuiteSparse_config/xerbla/libcerbla.a \
  AMD/Lib/libamd.a \
  CAMD/Lib/libcamd.a \
  COLAMD/Lib/libcolamd.a \
  CCOLAMD/Lib/libccolamd.a \
  CSparse/Lib/libcsparse.a \
  CXSparse/Lib/libcxsparse.a \
  CHOLMOD/Lib/libcholmod.a \
  SPQR/Lib/libspqr.a \
  BTF/Lib/libbtf.a \
  LDL/Lib/libldl.a \
  KLU/Lib/libklu.a \
  RBio/Lib/librbio.a \
  UMFPACK/Lib/libumfpack.a

$(PKG)_CPPFLAGS := -DNTIMER

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CPPFLAGS += -DLONGBLAS='long long'
  else
    $(PKG)_CPPFLAGS += -DLONGBLAS='long'
  endif
endif

define $(PKG)_BUILD
    # exclude demos
    find '$(1)' -name 'Makefile' \
        -exec $(SED) -i 's,( cd Demo,#( cd Demo,' {} \;

    if test $(MXE_SYSTEM) = msvc; then \
        (cd '$(1)'; \
	 (cd CXSparse_newfiles && tar cfz ../CXSparse_newfiles.tar.gz .); \
	 ./CSparse_to_CXSparse CSparse CXSparse CXSparse_newfiles.tar.gz) \
    fi

    # build all
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
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
        BLAS='-lblas -lgfortran -lgfortranbegin' \
        CHOLMOD_CONFIG='-DNPARTITION'

    # install library files
    $(INSTALL) -d '$($(PKG)_DESTDIR)$(HOST_LIBDIR)'

    for f in $(addprefix $(1)/, $($(PKG)_STATICLIBS_1)); do \
      if [ $(BUILD_SHARED) = yes ]; then \
        lib=`basename $$f .a`; \
        dir=`dirname $$f`; \
        echo "building and installing shared libraries for $$lib"; \
        deplibs=""; \
        case $$lib in \
          libcholmod) \
            deplibs="-lamd -lcamd -lcolamd -lccolamd -lsuitesparseconfig -llapack -lblas"; \
          ;; \
          libklu) \
            deplibs="-lbtf -lamd -lcolamd -lsuitesparseconfig"; \
          ;; \
          librbio) \
            deplibs="-lsuitesparseconfig"; \
          ;; \
	  libspqr) \
            deplibs="-lcholmod -lsuitesparseconfig -llapack -lblas"; \
          ;; \
          libumfpack) \
            deplibs="-lcholmod -lamd -lsuitesparseconfig -lblas"; \
          ;; \
        esac; \
        if [ -n "$deplibs" ]; then \
          echo "  deplibs = $$deplibs"; \
        fi; \
        $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CXX)' $$f --install '$(INSTALL)' --libdir '$($(PKG)_DESTDIR)$(HOST_LIBDIR)' --bindir '$($(PKG)_DESTDIR)$(HOST_BINDIR)' $$deplibs; \
      fi; \
    done

    # install include files
    $(INSTALL) -d                                '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/SuiteSparse_config/'*.h '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/AMD/Include/'*.h      '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/BTF/Include/'*.h      '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CAMD/Include/'*.h     '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CCOLAMD/Include/'*.h  '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CHOLMOD/Include/'*.h  '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/COLAMD/Include/'*.h   '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CSparse/Include/'*.h  '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CXSparse/Include/'*.h '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/KLU/Include/'*.h      '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/LDL/Include/'*.h      '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/SPQR/Include/'*       '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/UMFPACK/Include/'*.h  '$($(PKG)_DESTDIR)$(HOST_INCDIR)/suitesparse/'
endef
