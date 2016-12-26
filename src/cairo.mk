# This file is part of MXE.
# See index.html for further information.

PKG             := cairo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.14.8
$(PKG)_CHECKSUM := c6f7b99986f93c9df78653c3e6a3b5043f65145e
$(PKG)_SUBDIR   := cairo-$($(PKG)_VERSION)
$(PKG)_FILE     := cairo-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://cairographics.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib libpng fontconfig freetype pixman glib

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
        $(PKG)_EXTRA_CONFIGURE_OPTIONS += CFLAGS="$(CFLAGS) -DCAIRO_WIN32_STATIC_BUILD"
    endif
endif

# Configure script to detect float word endianness fails on MSVC.
ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_EXTRA_CONFIGURE_OPTIONS += ax_cv_c_float_words_bigendian=no
endif

define $(PKG)_BUILD
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
endef
