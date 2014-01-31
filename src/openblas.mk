# This file is part of MXE.
# See index.html for further information.

PKG             := openblas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.8
$(PKG)_CHECKSUM := d012ebc2b8dcd3e95f667dff08318a81479a47c3
$(PKG)_SUBDIR   := OpenBLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := http://github.com/xianyi/OpenBLAS/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

$(PKG)_MAKE_OPTS := PREFIX=$(HOST_PREFIX) DYNAMIC_ARCH=1 NO_LAPACK=1

ifneq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_MAKE_OPTS += NO_CBLAS=1 USE_THREAD=0 CC=$(MXE_CC) FC=$(MXE_F77) HOSTCC=gcc HOSTFC=gfortran CROSS=1
endif

ifeq ($(ENABLE_64),yes)
  $(PKG)_MAKE_OPTS += BINARY=64
else
  $(PKG)_MAKE_OPTS += BINARY=32
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTS)  
    $(MAKE) -C '$(1)' -j 1 PREFIX='$(HOST_PREFIX)' $($(PKG)_MAKE_OPTS) install
    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d $(HOST_BINDIR); \
      $(INSTALL) $(HOST_LIBDIR)/libopenblas.dll $(HOST_BINDIR)/; \
    fi
endef
