# This file is part of MXE.
# See index.html for further information.

PKG             := openblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.10
$(PKG)_CHECKSUM := cbe3fdd0e6ee235debc611d76976dac62f3ddc1c
$(PKG)_SUBDIR   := OpenBLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/xianyi/OpenBLAS/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := blas

$(PKG)_MAKE_OPTS := PREFIX=$(HOST_PREFIX) DYNAMIC_ARCH=1 NO_LAPACK=1

ifeq ($(USE_CCACHE),yes)
  $(PKG)_MXE_CC := $(shell basename $(MXE_CC))
  $(PKG)_MXE_F77 := $(shell basename $(MXE_F77))
else
  $(PKG)_MXE_CC := $(MXE_CC)
  $(PKG)_MXE_F77 := $(MXE_F77)
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  ## This may also be needed on some systems: NO_AVX2=1
  $(PKG)_MAKE_OPTS += NO_CBLAS=1 USE_THREAD=1 CC=$($(PKG)_MXE_CC) FC=$($(PKG)_MXE_F77)
else
  $(PKG)_MAKE_OPTS += NO_CBLAS=1 USE_THREAD=1 CC=$($(PKG)_MXE_CC) FC=$($(PKG)_MXE_F77) HOSTCC=gcc HOSTFC=gfortran CROSS=1 CROSS_SUFFIX=$(MXE_TOOL_PREFIX)
endif

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_MAKE_OPTS += EXTRALIB=-lxerbla
endif

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  $(PKG)_MAKE_OPTS += BINARY=64 INTERFACE64=1
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/xianyi/OpenBLAS/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTS)  
    $(MAKE) -C '$(1)' -j 1 $($(PKG)_MAKE_OPTS) install
endef
