# This file is part of MXE Octave.
# See index.html for further information.

PKG             := mesa
$(PKG)_VERSION  := 19.0.8
$(PKG)_CHECKSUM := 5fd340a6304f7501014e1bd7291e4cfa7a6efcdb
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.freedesktop.org/pub/mesa/$($(PKG)_FILE)
$(PKG)_DEPS     := build-mako expat zlib llvm s2tc

$(PKG)_PKG_CONFIG_PATH := $(PKG_CONFIG_PATH)
ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_DEPS += build-scons
  ifeq ($(USE_SYSTEM_OPENGL),no)
    $(PKG)_SCONS_OPENGL_OPTIONS := libgl-gdi
  endif
else
  ifeq ($(USE_SYSTEM_OPENGL),yes)
    $(PKG)_CONFIGURE_OPENGL_OPTIONS := \
      --disable-opengl --disable-egl --disable-gles1 --disable-gles2 \
      --disable-dri --disable-glx \
      --with-gallium-drivers="" --with-dri-drivers="" \
      --with-platforms=""
  else
    $(PKG)_CONFIGURE_OPENGL_OPTIONS := \
      --enable-glx="gallium-xlib" --with-gallium-drivers="swrast" \
      --disable-dri --disable-gbm --disable-egl
    ifeq ($(USE_SYSTEM_X11_LIBS),no)
      $(PKG)_DEPS += dri2proto glproto libdrm libxshmfence x11 xdamage xext xfixes
    else
      $(PKG)_PKG_CONFIG_PATH := $(PKG_CONFIG_PATH):$(BUILD_PKG_CONFIG_PATH)
    endif
  endif
  $(PKG)_CONFIGURE_ENV += \
      PKG_CONFIG="$(MXE_PKG_CONFIG)" \
      PKG_CONFIG_LIBDIR=$($(PKG)_PKG_CONFIG_PATH)
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  ifeq ($(ENABLE_WINDOWS_64),yes)
    $(PKG)_MACHINE := x86_64
  else
    $(PKG)_MACHINE := x86
  endif
  define $(PKG)_BUILD
    cd '$(1)' && LLVM=$(HOST_PREFIX) python2 $(shell which scons) platform=windows toolchain=crossmingw machine=$($(PKG)_MACHINE) verbose=1 build=release $($(PKG)_SCONS_OPENGL_OPTIONS)

    ## Do the scons config files have useful install targets?
    $(INSTALL) -d '$(3)$(HOST_INCDIR)/GL';
    for f in '$(1)/include/GL/*.h' ; do \
      $(INSTALL) -m 644 $$f '$(3)$(HOST_INCDIR)/GL'; \
    done
    $(INSTALL) -d '$(3)$(HOST_INCDIR)/KHR';
    for f in '$(1)/include/KHR/*.h' ; do \
      $(INSTALL) -m 644 $$f '$(3)$(HOST_INCDIR)/KHR'; \
    done

    if [ -f '$(1)/build/windows-$($(PKG)_MACHINE)/gallium/targets/libgl-gdi/opengl32.dll' ]; then \
      $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
      $(INSTALL) -m 755 '$(1)/build/windows-$($(PKG)_MACHINE)/gallium/targets/libgl-gdi/opengl32.dll' '$(3)$(HOST_BINDIR)/opengl32.dll'; \
    fi
  endef
else
  define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf -fi  -I m4
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_CONFIGURE_OPENGL_OPTIONS) \
        --enable-autotools \
        --disable-osmesa \
        --disable-gbm \
        --disable-xvmc \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
  endef
endif
