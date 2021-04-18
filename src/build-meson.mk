# This file is part of MXE.
# See index.html for further information.

PKG             := build-meson
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.55.3
$(PKG)_CHECKSUM := a20e5112130d8fc8763323f5c2cc1011b44e27b1
$(PKG)_SUBDIR   := meson-$($(PKG)_VERSION)
$(PKG)_FILE     := meson-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/mesonbuild/meson/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := build-python3 build-ninja

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

# FIXME: Should this be defined in the top-level Makefile?
ifeq ($(MXE_NATIVE_BUILD),no)
  MESON_TOOLCHAIN_FILE := $(HOST_PREFIX)/share/meson/cross/mxe-conf.ini
else
  MESON_TOOLCHAIN_FILE := $(HOST_PREFIX)/share/meson/native/mxe-conf.ini
endif

ifeq ($(USE_CCACHE),yes)
    $(PKG)_MXE_CC_BASENAME := $(shell basename $(MXE_CC))
    $(PKG)_MXE_CXX_BASENAME := $(shell basename $(MXE_CXX))
    $(PKG)_MXE_F77_BASENAME := $(shell basename $(MXE_F77))
endif

define $(PKG)_BUILD
    cd '$(1)' && $(PYTHON3) setup.py install --prefix='$(BUILD_TOOLS_PREFIX)'
    
    # create file with compilation settings
    rm -f $(MESON_TOOLCHAIN_FILE) && mkdir -p '$(dir $(MESON_TOOLCHAIN_FILE))'
    (echo "[binaries]"; \
    if [ x$(USE_SYSTEM_GCC) == xno ]; then \
      if [ x$(USE_CCACHE) == xyes ]; then \
        echo "c = '$($(PKG)_MXE_CC_BASENAME)'"; \
        echo "cpp = '$($(PKG)_MXE_CXX_BASENAME)'"; \
        echo "fortran = '$($(PKG)_MXE_F77_BASENAME)'"; \
      else \
        echo "c = '$(shell echo $(MXE_CC) | $(SED) "s/'//g")'"; \
        echo "cpp = '$(shell echo $(MXE_CXX) | $(SED) "s/'//g")'"; \
        echo "fortran = '$(shell echo $(MXE_F77) | $(SED) "s/'//g")'"; \
      fi; \
      echo "ar = '$(shell echo $(MXE_AR) | $(SED) "s/'//g")'"; \
      echo "strip = '$(shell echo $(MXE_STRIP) | $(SED) "s/'//g")'"; \
    fi; \
    echo "pkgconfig = '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'"; \
    echo "llvm-config = '$(HOST_BINDIR)/$(MXE_TOOL_PREFIX)llvm-config'";\
    if [ x$(MXE_NATIVE_BUILD) = xno ]; then \
      echo ""; \
      echo "[host_machine]"; \
      echo "system = 'windows'"; \
      if [ x$(ENABLE_WINDOWS_64) = xyes ]; then \
        echo "cpu_family = 'x86_64'"; \
      else \
        echo "cpu_family = 'x86'"; \
      fi; \
      echo "cpu = 'i686'"; \
      echo "endian = 'little'"; \
    fi) >> $(MESON_TOOLCHAIN_FILE)
endef
