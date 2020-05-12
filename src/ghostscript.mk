# This file is part of MXE.
# See index.html for further information.

PKG             := ghostscript
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.50
$(PKG)_NODOTVER := $(subst .,,$($(PKG)_VERSION))
$(PKG)_CHECKSUM := 3be5f36300e3031e68a28cd898b3eebc9151660b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/ArtifexSoftware/ghostpdl-downloads/releases/download/gs$($(PKG)_NODOTVER)/$($(PKG)_FILE)
$(PKG)_DEPS     := dbus fontconfig freetype libiconv libidn libpaper libpng tiff zlib

ifeq ($(MXE_WINDOWS_BUILD),no)
  ifeq ($(USE_SYSTEM_X11_LIBS),no)
    $(PKG)_DEPS += x11 xext
  endif
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_DEPS += lcms
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
    $(PKG)_CONFIGURE_FLAGS=$(CONFIGURE_LDFLAGS) $(CONFIGURE_CPPFLAGS)
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://api.github.com/repos/ArtifexSoftware/ghostpdl-downloads/releases' | \
    $(SED) -n 's,.*"ghostscript-\([0-9\.]*\)\.tar.xz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cp -f `automake --print-libdir`/{config.guess,config.sub,install-sh} '$(1)'
    cd '$(1)' && rm -rf freetype jpeg libpng openjpeg tiff
    cd '$(1)' && autoreconf -f -i
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $(1)/configure \
        CPPFLAGS='$(CPPFLAGS) -DHAVE_SYS_TIMES_H=0' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
	$($(PKG)_CONFIGURE_FLAGS) \
        --prefix='$(HOST_PREFIX)' \
        --without-local-zlib \
        --with-system-libtiff

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' $(if $(BUILD_STATIC),libgs,so)
    $(MAKE) -C '$(1)/.build' prefix='$(HOST_PREFIX)' install

    if [ "x$(ENABLE_DEP_DOCS)" == "xno" ]; then \
      rm -f $(HOST_PREFIX)/share/doc/ghostscript/$($(PKG)_VERSION)/*.htm; \
    fi
endef

