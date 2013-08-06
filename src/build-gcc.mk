# This file is part of MXE.
# See index.html for further information.

PKG             := build-gcc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 4e655032cda30e1928fcc3f00962f4238b502169
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_DEPS := build-cmake
else
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_DEPS := mingwrt w32api build-binutils
  endif
endif

ifneq ($(BUILD_SHARED),yes)
  $(PKG)_STATIC_FLAG := --static
endif

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS := \
    --libdir='$(BUILD_TOOLS_PREFIX)/lib' \
    --enable-version-specific-runtime-libs \
    --with-gcc \
    --with-gnu-ld \
    --with-gnu-as \
    --disable-nls \
    --without-x \
    --disable-sjlj-exceptions \
    --disable-win32-registry \
    --enable-threads=win32
endif


define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    grep -v '^4\.[543]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./contrib/download_prerequisites
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        --build='$(BUILD_SYSTEM)' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --enable-languages='c,c++,fortran' \
        $(ENABLE_SHARED_OR_STATIC) \
        $($(PKG)_SYSDEP_CONFIGURE_OPTIONS) \
        --disable-libgomp \
        --disable-libmudflap \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
    mkdir -p $(TOP_DIR)/cross-tools/$(HOST_BINDIR)
    $(MAKE) -C '$(1).build' -j 1 DESTDIR=$(TOP_DIR)/cross-tools install

    # create pkg-config script
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH="$$PKG_CONFIG_PATH_$(subst -,_,$(TARGET))" PKG_CONFIG_LIBDIR='\''$(HOST_LIBDIR)/pkgconfig'\'' exec pkg-config $($(PKG)_STATIC_FLAG) "$$@"') \
             > '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'
    chmod 0755 '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'
endef

