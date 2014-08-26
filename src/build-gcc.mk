# This file is part of MXE.
# See index.html for further information.

PKG             := build-gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.9.1
$(PKG)_CHECKSUM := 3f303f403053f0ce79530dae832811ecef91197e
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS := build-cmake gcc-cloog gcc-gmp gcc-isl gcc-mpc gcc-mpfr
ifneq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_DEPS += build-binutils
endif
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_DEPS += mingw-w64
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
    --disable-win32-registry \
    --with-native-system-header-dir='/include' \
    --enable-threads=win32
  ifneq ($(ENABLE_64),yes)
    $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
      --disable-sjlj-exceptions
  endif
  define $(PKG)_BUILD_SYSTEM_RUNTIME
    # build standalone gcc
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # build mingw-w64-crt
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,mingw-w64,$(TAR))
    mkdir '$(1).crt-build'
    cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
	--host='$(TARGET)' \
	--prefix='$(HOST_PREFIX)' \
	--with-sysroot='$(HOST_PREFIX)' \
	$(ENABLE_SHARED_OR_STATIC)
    $(MAKE) -C '$(1).crt-build' -j '$(JOBS)' || $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).crt-build' -j 1 install
  endef
endif

ifneq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
    --target='$(TARGET)' \
    --build='$(BUILD_SYSTEM)' \
    --with-sysroot='$(HOST_PREFIX)' \
    --with-as='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-as' \
    --with-ld='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-ld' \
    --with-nm='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-nm'
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    grep -v '^4\.[543]\.' | \
    head -1
endef

define $(PKG)_CONFIGURE
    # configure gcc
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --enable-languages='c,c++,fortran' \
        --disable-multilib \
        --disable-libsanitizer \
        $($(PKG)_SYSDEP_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-libgomp \
        --with-cloog='$(BUILD_TOOLS_PREFIX)' \
        --with-gmp='$(BUILD_TOOLS_PREFIX)' \
        --with-isl='$(BUILD_TOOLS_PREFIX)' \
        --with-mpc='$(BUILD_TOOLS_PREFIX)' \
        --with-mpfr='$(BUILD_TOOLS_PREFIX)' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
endef

define $(PKG)_BUILD
  $($(PKG)_CONFIGURE)

  $($(PKG)_BUILD_SYSTEM_RUNTIME)

  # build rest of gcc
  $(MAKE) -C '$(1).build' -j '$(JOBS)'
  $(MAKE) -C '$(1).build' -j 1 install

  if [ -f $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/lib/libgcc_s.a ]; then \
    mv $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/lib/libgcc_s.a $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/libgcc_s.a; \
  fi

  # create pkg-config script
  if [ '$(MXE_NATIVE_BUILD)' = 'no' ]; then \
    (echo '#!/bin/sh'; \
     echo 'PKG_CONFIG_PATH="$$PKG_CONFIG_PATH_$(subst -,_,$(TARGET))" PKG_CONFIG_LIBDIR='\''$(HOST_LIBDIR)/pkgconfig'\'' exec pkg-config $($(PKG)_STATIC_FLAG) "$$@"') \
             > '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'; \
    chmod 0755 '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'; \
  fi

  $($(PKG)_POST_BUILD)
endef
