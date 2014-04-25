# This file is part of MXE.
# See index.html for further information.

PKG             := native-gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.9.0
$(PKG)_CHECKSUM := fbde8eb49f2b9e6961a870887cf7337d31cd4917
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS := native-binutils cloog gmp isl mpc mpfr
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_DEPS += mingw-w64
endif
ifneq ($(BUILD_SHARED),yes)
$(PKG)_STATIC_FLAG := --static
endif

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS := \
    --enable-version-specific-runtime-libs \
    --disable-nls \
    --without-x \
    --disable-win32-registry \
    --with-native-system-header-dir='$(HOST_PREFIX)/include' \
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

define $(PKG)_BUILD
    # configure gcc
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --enable-languages='c,c++,fortran' \
        --disable-multilib \
        $($(PKG)_SYSDEP_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-libgomp \
        --disable-libmudflap \
        --with-cloog='$(HOST_PREFIX)' \
        --with-gmp='$(HOST_PREFIX)' \
        --with-isl='$(HOST_PREFIX)' \
        --with-mpc='$(HOST_PREFIX)' \
        --with-mpfr='$(HOST_PREFIX)' \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")

    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install

    if [ -f $(HOST_PREFIX)/lib/gcc/$(TARGET)/lib/libgcc_s.a ]; then \
      mv $(HOST_PREFIX)/lib/gcc/$(TARGET)/lib/libgcc_s.a $(HOST_PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/libgcc_s.a; \
    fi
endef
