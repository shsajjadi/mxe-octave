# This file is part of MXE.
# See index.html for further information.

PKG             := openblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.13
$(PKG)_CHECKSUM := 685537a821819ef4dae5901998a57f0eec5bddad
$(PKG)_SUBDIR   := OpenBLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/xianyi/OpenBLAS/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := blas

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/xianyi/OpenBLAS/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -Vr | \
    head -1
endef

ifeq ($(USE_CCACHE),yes)
  $(PKG)_MXE_CC := $(shell basename $(MXE_CC))
  $(PKG)_MXE_F77 := $(shell basename $(MXE_F77))
else
  $(PKG)_MXE_CC := $(MXE_CC)
  $(PKG)_MXE_F77 := $(MXE_F77)
endif

$(PKG)_MAKE_OPTS := \
  PREFIX=$(HOST_PREFIX) \
  DYNAMIC_ARCH=1 DYNAMIC_OLDER=1 \
  NO_LAPACK=1 NO_CBLAS=1 \
  USE_THREAD=1 NUM_THREADS=24 \
  CC=$($(PKG)_MXE_CC) FC=$($(PKG)_MXE_F77)
## This may also be needed on some systems: NO_AVX2=1

ifneq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_MAKE_OPTS += HOSTCC=gcc HOSTFC=gfortran CROSS=1 CROSS_SUFFIX=$(MXE_TOOL_PREFIX)
endif

## Assume that native builds are for a 64bit target
$(PKG)_TARGET := PRESCOTT

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_MAKE_OPTS += EXTRALIB=-lxerbla
  ifneq ($(ENABLE_WINDOWS_64),yes)
    $(PKG)_TARGET := KATMAI
  endif
endif

$(PKG)_MAKE_OPTS += TARGET=$($(PKG)_TARGET)

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  $(PKG)_MAKE_OPTS += BINARY=64 INTERFACE64=1
endif

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTS)  
    $(MAKE) -C '$(1)' -j 1 $($(PKG)_MAKE_OPTS) install
endef
