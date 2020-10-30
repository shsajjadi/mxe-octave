# This file is part of MXE.
# See index.html for further information.

PKG             := cairo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.16.0
$(PKG)_CHECKSUM := 00e81842ae5e81bb0343108884eb5205be0eac14
$(PKG)_SUBDIR   := cairo-$($(PKG)_VERSION)
$(PKG)_FILE     := cairo-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := zlib libpng $($(PKG)_FONTCONFIG) freetype pixman glib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cairographics.org/releases/?C=M;O=D' | \
    $(SED) -n 's,.*"cairo-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

$(PKG)_EXTRA_CONFIGURE_OPTIONS :=
# FIXME: Not sure why i was disabled...
#$(PKG)_EXTRA_CONFIGURE_OPTIONS += --disable-atomic
# Add special flag for static Win32 builds
ifneq ($(filter mingw msvc,$(MXE_SYSTEM)),)
    ifeq ($(BUILD_STATIC),yes)
        $(PKG)_EXTRA_CONFIGURE_OPTIONS += CFLAGS="-O2 -g -DCAIRO_WIN32_STATIC_BUILD"
    else
        $(PKG)_EXTRA_CONFIGURE_OPTIONS += CFLAGS="-O2 -g -fstack-protector"
    endif
    $(PKG)_EXTRA_CONFIGURE_OPTIONS += LIBS="-lmsimg32 -lgdi32"
endif

# Configure script to detect float word endianness fails on MSVC.
ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_EXTRA_CONFIGURE_OPTIONS += ax_cv_c_float_words_bigendian=no
endif

define $(PKG)_BUILD
    $(SED) -i 's,^\(Libs:.*\),\1 @CAIRO_NONPKGCONFIG_LIBS@,' '$(1)/src/cairo.pc.in'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-gtk-doc \
        --disable-test-surfaces \
        --disable-gcov \
        --disable-xlib \
        --disable-xlib-xrender \
        --disable-xcb \
        --disable-quartz \
        --disable-quartz-font \
        --disable-quartz-image \
        --disable-os2 \
        --disable-beos \
        --disable-directfb \
        --enable-win32 \
        --enable-win32-font \
        --enable-png \
        --enable-ft \
        --enable-ps \
        --enable-pdf \
        --enable-svg \
	--disable-directfb \
        --disable-pthread \
        $($(PKG)_EXTRA_CONFIGURE_OPTIONS) \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH='$(PKG_CONFIG_PATH)' \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install noinst_PROGRAMS=  DESTDIR='$(3)'
    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf "$(3)$(HOST_PREFIX)/share/gtk-doc"; \
    fi
endef
