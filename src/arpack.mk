# This file is part of MXE.
# See index.html for further information.

PKG             := arpack
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c1ac96663916a4e11618e9557636ba1bd1a7b556
$(PKG)_SUBDIR   := $(PKG)-ng-$($(PKG)_VERSION)
$(PKG)_FILE     := arpack-ng-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/$($(PKG)_FILE)
ifeq ($(ENABLE_OPENBLAS),yes)
  $(PKG)_DEPS     := openblas lapack
else
  $(PKG)_DEPS     := blas lapack
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_ENV := LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)
endif

ifeq ($(USE_PIC_FLAG),yes)
  $(PKG)_CONFIGURE_PIC_OPTION := --with-pic
endif

ifeq ($(ENABLE_64),yes)
  $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := FFLAGS="-g -O2 -fdefault-integer-8"
endif

ifeq ($(ENABLE_OPENBLAS),yes)
  $(PKG)_BLAS_OPTION := --with-blas=openblas
  $(PKG)_BLAS_LIB := openblas
else
  $(PKG)_BLAS_LIB := blas
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package arpack.' >&2;
    echo $(arpack_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        F77=$(MXE_F77) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --enable-static --disable-shared \
	$($(PKG)_CONFIGURE_PIC_OPTION) \
        $($(PKG)_BLAS_OPTION) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS) && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'

    if [ $(BUILD_STATIC) = yes ]; then \
      $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install; \
    fi

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/.build/.libs/libarpack.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)' -llapack -l$($(PKG)_BLAS_LIB); \
    fi
endef
