# This file is part of MXE.
# See index.html for further information.

PKG             := build-gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.2
$(PKG)_CHECKSUM := 810fb70bd721e1d9f446b6503afe0a9088b62986
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS := build-cmake build-binutils gcc-cloog gcc-gmp gcc-isl gcc-mpc gcc-mpfr
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
    --enable-threads=win32
  ifneq ($(ENABLE_64),yes)
    $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
      --disable-sjlj-exceptions
  endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    grep -v '^4\.[543]\.' | \
    head -1
endef

ifneq ($(MXE_NATIVE_BUILD),yes)
  define $(PKG)_POST_BUILD
    $(INSTALL) -d '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)'
    mv $(addprefix $(HOST_PREFIX)/bin/, c++ g++ gcc gfortran) '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)'
  endef
endif

define $(PKG)_CONFIGURE
    # configure gcc
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        --build='$(BUILD_SYSTEM)' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --enable-languages='c,c++,fortran' \
        --disable-multilib \
        $($(PKG)_SYSDEP_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-libgomp \
        --disable-libmudflap \
        --with-cloog='$(BUILD_TOOLS_PREFIX)' \
        --with-gmp='$(BUILD_TOOLS_PREFIX)' \
        --with-isl='$(BUILD_TOOLS_PREFIX)' \
        --with-mpc='$(BUILD_TOOLS_PREFIX)' \
        --with-mpfr='$(BUILD_TOOLS_PREFIX)' \
        --with-as='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-as' \
        --with-ld='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-ld' \
        --with-nm='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-nm'
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
endef

define $(PKG)_BUILD
  # build standalone gcc
  $($(PKG)_CONFIGURE)
  $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
  $(MAKE) -C '$(1).build' -j 1 install-gcc

  # build mingw-w64-crt
  cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,mingw-w64,$(TAR))
  mkdir '$(1).crt-build'
  cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
      --host='$(TARGET)' \
      --prefix='$(HOST_PREFIX)'
  $(MAKE) -C '$(1).crt-build' -j '$(JOBS)' || $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
  $(MAKE) -C '$(1).crt-build' -j 1 install

  # build rest of gcc
  cd '$(1).build'
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
