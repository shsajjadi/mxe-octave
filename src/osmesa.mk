# This file is part of MXE Octave.
# See index.html for further information.

PKG             := osmesa
$(PKG)_VERSION  := 10.2.2
$(PKG)_CHECKSUM := 2cc7c5b80fd2ddbf540acf47dbaec68e8cab16a4
$(PKG)_SUBDIR   := Mesa-$($(PKG)_VERSION)
$(PKG)_FILE     := MesaLib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.freedesktop.org/pub/mesa/current/$($(PKG)_FILE)
$(PKG)_DEPS     := 

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
    cd '$(1)' && scons platform=windows toolchain=crossmingw machine=$($(PKG)_MACHINE) verbose=1 osmesa

    ## Do the scons config files have useful install targets?
    $(INSTALL) -d '$(3)$(HOST_INCDIR)/GL';
    for f in '$(1)/include/GL/*.h' ; do \
      $(INSTALL) -m 644 $$f '$(3)$(HOST_INCDIR)/GL'; \
    done
    $(INSTALL) -d '$(3)$(HOST_BINDIR)';
    $(INSTALL) -m 755 '$(1)/build/windows-$($(PKG)_MACHINE)-debug/mesa/drivers/osmesa/osmesa.dll' '$(3)$(HOST_BINDIR)/osmesa.dll';
    $(INSTALL) -d '$(3)$(HOST_LIBDIR)';
    $(INSTALL) -m 644 '$(1)/build/windows-$($(PKG)_MACHINE)-debug/mesa/drivers/osmesa/libosmesa.a' '$(3)$(HOST_LIBDIR)/libOSMesa.a';
  endef
else
  define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)' && autoreconf -fi  -I m4
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --enable-osmesa --disable-dri --disable-egl --disable-xvmc \
        --disable-glx --disable-shared-glapi --disable-gallium-llvm \
        --with-gallium-drivers="" --with-dri-drivers="" \
        --with-egl-platforms="" --enable-texture-float \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
  endef
endif
