# This file is part of MXE.
# See index.html for further information.

PKG             := suitesparse
$(PKG)_CHECKSUM := 46b24a28eef4b040ea5a02d2c43e82e28b7d6195
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cise.ufl.edu/research/sparse/SuiteSparse/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/SuiteSparse/$($(PKG)_FILE)

ifeq ($(ENABLE_OPENBLAS),yes)
  $(PKG)_DEPS     := openblas lapack
  $(PKG)_BLAS_LIB := openblas
else
  $(PKG)_DEPS     := blas lapack
  $(PKG)_BLAS_LIB := blas
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
  SPQR/Lib/libspqr.a \
  BTF/Lib/libbtf.a \
  LDL/Lib/libldl.a \
  KLU/Lib/libklu.a \
  RBio/Lib/librbio.a \
  CHOLMOD/Lib/libcholmod.a \
  UMFPACK/Lib/libumfpack.a

define $(PKG)_BUILD
    # exclude demos
    find '$(1)' -name 'Makefile' \
        -exec $(SED) -i 's,( cd Demo,#( cd Demo,' {} \;

    # build all
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        CC='$(MXE_CC)' \
        CXX='$(MXE_CXX)' \
        CPLUSPLUS='$(MXE_CXX)' \
        F77='$(MXE_F77)' \
        FFLAGS='$(MXE_FFLAGS)' \
        CFLAGS='$(MXE_CFLAGS)' \
        CXXFLAGS='$(MXE_CXXFLAGS)' \
        AR='$(MXE_AR)' \
        RANLIB='$(MXE_RANLIB)' \
        BLAS='-l$($(PKG)_BLAS_LIB) -lgfortran -lgfortranbegin' \
        CHOLMOD_CONFIG='-DNPARTITION'

    # install library files
    $(INSTALL) -d '$(HOST_LIBDIR)'

    for f in $(addprefix $(1)/, $($(PKG)_STATICLIBS_1)); do \
      if [ $(BUILD_SHARED) = yes ]; then \
        lib=`basename $$f .a`; \
        dir=`dirname $$f`; \
        echo "building and installing shared libraries for $$lib"; \
        deplibs=""; \
        case $$lib in \
          libcholmod) \
            deplibs="-lamd -lcolamd -lsuitesparseconfig -llapack -l$($(PKG)_BLAS_LIB)"; \
          ;; \
          libklu) \
            deplibs="-lbtf -lamd -lcolamd -lsuitesparseconfig"; \
          ;; \
          librbio) \
            deplibs="-lsuitesparseconfig"; \
          ;; \
	  libspqr) \
            deplibs="-lcholmod -lsuitesparseconfig -llapack -l$($(PKG)_BLAS_LIB)"; \
          ;; \
          libumfpack) \
            deplibs="-lcholmod -lamd -lsuitesparseconfig -l$($(PKG)_BLAS_LIB)"; \
          ;; \
        esac; \
        if [ -n "$deplibs" ]; then \
          echo "  deplibs = $$deplibs"; \
        fi; \
        $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CXX)' $$f --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)' $$deplibs; \
      fi; \
    done

    # install include files
    $(INSTALL) -d                                '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/SuiteSparse_config/'*.h '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/AMD/Include/'*.h      '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/BTF/Include/'*.h      '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CAMD/Include/'*.h     '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CCOLAMD/Include/'*.h  '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CHOLMOD/Include/'*.h  '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/COLAMD/Include/'*.h   '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CSparse/Include/'*.h  '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/CXSparse/Include/'*.h '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/KLU/Include/'*.h      '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/LDL/Include/'*.h      '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/SPQR/Include/'*       '$(HOST_INCDIR)/suitesparse/'
    $(INSTALL) -m644 '$(1)/UMFPACK/Include/'*.h  '$(HOST_INCDIR)/suitesparse/'
endef
