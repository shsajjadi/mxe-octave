# This file is part of MXE.
# See index.html for further information.

PKG             := suitesparse
$(PKG)_CHECKSUM := 46b24a28eef4b040ea5a02d2c43e82e28b7d6195
$(PKG)_SUBDIR   := SuiteSparse
$(PKG)_FILE     := SuiteSparse-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cise.ufl.edu/research/sparse/SuiteSparse/$($(PKG)_FILE)
$(PKG)_URL_2    := https://distfiles.macports.org/SuiteSparse/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc blas lapack

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
        CC='$(TARGET)-gcc' \
        CXX='$(TARGET)-g++' \
        CPLUSPLUS='$(TARGET)-g++' \
        F77='$(TARGET)-gfortran' \
        AR='$(TARGET)-ar' \
        RANLIB='$(TARGET)-ranlib' \
        BLAS='-lblas -lgfortran -lgfortranbegin' \
        CHOLMOD_CONFIG='-DNPARTITION'

    # install library files
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/lib'

    for f in $(addprefix $(1)/, $($(PKG)_STATICLIBS_1)); do \
      if [ $(BUILD_SHARED) = yes ]; then \
        lib=`basename $$f .a`; \
        dir=`dirname $$f`; \
        echo "building and installing shared libraries for $$lib"; \
        deplibs=""; \
        case $$lib in \
          libcholmod) \
            deplibs="-lamd -lcolamd -lsuitesparseconfig -llapack -lblas"; \
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
        $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-g++' $$f $$deplibs; \
        $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
        $(INSTALL) -m755 $$dir/$$lib.dll.a $(PREFIX)/$(TARGET)/lib/$$lib.dll.a; \
        $(INSTALL) -m755 $$dir/$$lib.dll $(PREFIX)/$(TARGET)/bin/$$lib.dll; \
      fi; \
      $(INSTALL) -m644 $$f $(PREFIX)/$(TARGET)/lib/$$lib.a; \
    done

    # install include files
    $(INSTALL) -d                                '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/SuiteSparse_config/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/AMD/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/BTF/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CAMD/Include/'*.h     '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CCOLAMD/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CHOLMOD/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/COLAMD/Include/'*.h   '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CSparse/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/CXSparse/Include/'*.h '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/KLU/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/LDL/Include/'*.h      '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/SPQR/Include/'*       '$(PREFIX)/$(TARGET)/include/suitesparse/'
    $(INSTALL) -m644 '$(1)/UMFPACK/Include/'*.h  '$(PREFIX)/$(TARGET)/include/suitesparse/'
endef
