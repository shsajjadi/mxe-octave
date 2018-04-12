# This file is part of MXE Octave.
# See index.html for further information.

PKG             := mesa
$(PKG)_VERSION  := 17.2.1
$(PKG)_CHECKSUM := 7429e74a0ef12ea9d60b41b2b852898b3da0b238
$(PKG)_SUBDIR   := mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := mesa-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.freedesktop.org/pub/mesa/$($(PKG)_FILE)
$(PKG)_DEPS     := build-mako expat zlib
ifeq ($(MXE_WINDOWS_BUILD),yes)
  ifeq ($(USE_SYSTEM_OPENGL),no)
    $(PKG)_SCONS_OPENGL_OPTIONS := libgl-gdi
    $(PKG)_DEPS += s2tc
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
      --enable-opengl --enable-egl --enable-gles1 --enable-gles2 \
      --with-gallium-drivers="swrast" --with-dri-drivers="" \
      --with-platforms="x11"
    ifeq ($(USE_SYSTEM_X11_LIBS),no)
      $(PKG)_DEPS += dri2proto glproto libdrm libxshmfence x11 xdamage xext xfixes
    endif
    $(PKG)_DEPS += llvm s2tc
  endif
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
    cd '$(1)' && scons platform=windows toolchain=crossmingw machine=$($(PKG)_MACHINE) verbose=1 build=release osmesa $($(PKG)_SCONS_OPENGL_OPTIONS)

    ## Do the scons config files have useful install targets?
    $(INSTALL) -d '$(3)$(HOST_INCDIR)/GL';
    for f in '$(1)/include/GL/*.h' ; do \
      $(INSTALL) -m 644 $$f '$(3)$(HOST_INCDIR)/GL'; \
    done

    $(INSTALL) -d '$(3)$(HOST_LIBDIR)';
    $(INSTALL) -m 644 '$(1)/build/windows-$($(PKG)_MACHINE)/gallium/targets/osmesa/libosmesa.a' '$(3)$(HOST_LIBDIR)/libOSMesa.a';

    $(INSTALL) -d '$(3)$(HOST_BINDIR)';
    $(INSTALL) -m 755 '$(1)/build/windows-$($(PKG)_MACHINE)/gallium/targets/osmesa/osmesa.dll' '$(3)$(HOST_BINDIR)/osmesa.dll';

    if [ -f '$(1)/build/windows-$($(PKG)_MACHINE)/gallium/targets/libgl-gdi/opengl32.dll' ]; then \
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
        --enable-osmesa \
        --disable-gbm \
        --disable-xvmc \
        --enable-texture-float \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
  endef
endif
