# This file is part of MXE Octave.
# See index.html for further information.

PKG             := mesa
$(PKG)_VERSION  := 20.1.10
$(PKG)_CHECKSUM := 151d5edff5caeead98f428698cf02ddb0cf66d4b
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.freedesktop.org/pub/mesa/$($(PKG)_FILE)
$(PKG)_DEPS     := build-mako build-meson build-ninja expat zlib llvm s2tc

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

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_MESON_TOOLCHAIN_FILE := --cross-file '$(MESON_TOOLCHAIN_FILE)'
else
  ifeq ($(USE_SYSTEM_X11_LIBS),no)
    $(PKG)_DEPS += dri2proto glproto libdrm libxshmfence x11 xdamage xext xfixes
  else
    $(PKG)_PKG_CONFIG_PATH := $(PKG_CONFIG_PATH):$(BUILD_PKG_CONFIG_PATH)
  endif
  $(PKG)_MESON_TOOLCHAIN_FILE := --native-file '$(MESON_TOOLCHAIN_FILE)'
  $(PKG)_MESON_ENV += \
      PKG_CONFIG="$(MXE_PKG_CONFIG)" \
      PKG_CONFIG_LIBDIR=$($(PKG)_PKG_CONFIG_PATH)

  $(PKG)_X11_FLAGS := -Dplatforms='x11' \
      -Dglx=gallium-xlib \
      -Ddri-drivers=''
endif

define $(PKG)_BUILD
  cd '$(1)' && $($(PKG)_MESON_ENV) \
      meson $(1)/.build \
      $($(PKG)_MESON_TOOLCHAIN_FILE) \
      -Dprefix='$(HOST_PREFIX)' \
      $($(PKG)_X11_FLAGS) \
      -Dgallium-drivers=swrast \
      -Dvulkan-drivers='' \
      -Degl=false \
      -Dgbm=false \
      -Dshared-llvm=true

  cd '$(1)/.build' && DESTDIR=$(3) ninja -j $(JOBS) install

  #  install headers
  for i in EGL GLES GLES2 GLES3 KHR; do \
      $(INSTALL) -d "$(HOST_INCDIR)/$$i"; \
      $(INSTALL) -m 644 "$(1)/include/$$i/"* "$(HOST_INCDIR)/$$i/"; \
  done
  
  # opengl32.dll.a shadows libopengl32.a from mingw. They export slightly
  # different symbols which causes problems for some packages. So don't install
  # it for cross-builds.
  if [ x$(MXE_NATIVE_BUILD) == xno ]; then \
    rm -f $(3)$(HOST_LIBDIR)/opengl32.dll.a; \
  fi
endef
