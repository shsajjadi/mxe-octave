# This file is part of MXE.
# See index.html for further information.

PKG             := build-gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.2.0
$(PKG)_CHECKSUM := 08a88199ed94fdf4940d118ba3c07028245cd5b7
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS := build-cmake gcc-gmp gcc-isl gcc-mpc gcc-mpfr gcc-cloog
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
    --enable-version-specific-runtime-libs \
    --with-gcc \
    --with-gnu-ld \
    --with-gnu-as \
    --disable-nls \
    --without-x \
    --disable-win32-registry \
    --enable-threads=posix
  ifneq ($(TARGET),x86_64-w64-mingw32)
    $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
    --libdir='$(BUILD_TOOLS_PREFIX)/lib' \
    --with-native-system-header-dir='/include' \
      --disable-sjlj-exceptions
  else
    define $(PKG)_PRE_BUILD
      echo "Shortcuts"
      # create shortcuts
      if ! [ -L $(HOST_PREFIX)/lib64 ]; then \
        ln -s $(HOST_PREFIX)/lib $(HOST_PREFIX)/lib64; \
      fi
      if ! [ -d $(HOST_PREFIX)/lib32 ]; then \
        mkdir -p $(HOST_PREFIX)/lib32; \
      fi
      if ! [ -L $(BUILD_TOOLS_PREFIX)/mingw ]; then \
        ln -s $(HOST_PREFIX) $(BUILD_TOOLS_PREFIX)/mingw; \
      fi
    endef
  endif
  define $(PKG)_INSTALL_SYSTEM_HEADERS
    $($(PKG)_PRE_BUILD)
    # install mingw-w64 headers
    $(call PREPARE_PKG_SOURCE,mingw-w64,$(1))
    mkdir '$(1).headers'
    cd '$(1).headers' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-headers/configure' \
        --host='$(TARGET)' \
        --prefix='$(HOST_PREFIX)' \
        --enable-sdk=all \
        --enable-idl \
        --enable-secure-api \
        $(mingw-w64-headers_CONFIGURE_OPTS)
    $(MAKE) -C '$(1).headers' install
  endef
  define $(PKG)_BUILD_SYSTEM_RUNTIME
    # build standalone gcc
    $(MAKE) -C '$(1).build' -j '$(JOBS)' all-gcc
    $(MAKE) -C '$(1).build' -j 1 install-gcc

    # build mingw-w64-crt
    mkdir '$(1).crt-build'
    cd '$(1).crt-build' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-crt/configure' \
	--host='$(TARGET)' \
	--prefix='$(HOST_PREFIX)' \
	--with-sysroot='$(HOST_PREFIX)'
    $(MAKE) -C '$(1).crt-build' -j '$(JOBS)' || $(MAKE) -C '$(1).crt-build' -j '$(JOBS)'
    $(MAKE) -C '$(1).crt-build' -j 1 install

    # build posix threads
    mkdir '$(1).pthreads'
    cd '$(1).pthreads' && '$(1)/$(mingw-w64_SUBDIR)/mingw-w64-libraries/winpthreads/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC)
    $(MAKE) -C '$(1).pthreads' -j '$(JOBS)' || $(MAKE) -C '$(1).pthreads' -j '$(JOBS)'
    $(MAKE) -C '$(1).pthreads' -j 1 install
  endef
endif

ifneq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
    --target='$(TARGET)' \
    --build='$(BUILD_SYSTEM)' \
    --with-as='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-as' \
    --with-ld='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-ld' \
    --with-nm='$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-nm'

  ifeq ($(ENABLE_WINDOWS_64),yes)
    $(PKG)_SYSDEP_CONFIGURE_OPTIONS += --with-sysroot='$(BUILD_TOOLS_PREFIX)' \
      --disable-multilib  --with-host-libstdcxx="-lstdc++" --with-system-zlib \
      --enable-64bit --enable-fully-dynamic-string
  else
    $(PKG)_SYSDEP_CONFIGURE_OPTIONS += --with-sysroot='$(HOST_PREFIX)' \
      --disable-multilib
  endif
else
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
      --disable-multilib
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_CONFIGURE
    # configure gcc
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --enable-languages='c,c++,fortran' \
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
  # Windows only.
  $($(PKG)_INSTALL_SYSTEM_HEADERS)

  # All systems.
  $($(PKG)_CONFIGURE)

  # Windows only.
  $($(PKG)_BUILD_SYSTEM_RUNTIME)

  # Build rest of gcc.
  $(MAKE) -C '$(1).build' -j '$(JOBS)'
  $(MAKE) -C '$(1).build' -j 1 install

  if [ -f $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/lib/libgcc_s.a ]; then \
    mv $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/lib/libgcc_s.a $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/libgcc_s.a; \
  fi

  if [ -f $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/lib32/libgcc_s.a ]; then \
    mv $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/lib32/libgcc_s.a $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/32/libgcc_s.a; \
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
