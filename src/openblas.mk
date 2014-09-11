# This file is part of MXE.
# See index.html for further information.

PKG             := openblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.11
$(PKG)_CHECKSUM := ee504e5115a93cb62042eec01f2f929ca3fa255e
$(PKG)_SUBDIR   := OpenBLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://github.com/xianyi/OpenBLAS/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

$(PKG)_MAKE_OPTS := PREFIX=$(HOST_PREFIX) DYNAMIC_ARCH=1 NO_LAPACK=1

ifneq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_MAKE_OPTS += NO_CBLAS=1 USE_THREAD=0 CC=$(MXE_CC) FC=$(MXE_F77) HOSTCC=gcc HOSTFC=gfortran CROSS=1 CROSS_SUFFIX=$(MXE_TOOL_PREFIX)
endif

ifeq ($(ENABLE_64),yes)
  $(PKG)_MAKE_OPTS += BINARY=64 INTERFACE64=1
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTS)  
    $(MAKE) -C '$(1)' -j 1 $($(PKG)_MAKE_OPTS) install
endef
