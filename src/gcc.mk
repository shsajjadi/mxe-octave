# This file is part of MXE.
# See index.html for further information.

PKG             := gcc
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a464ba0f26eef24c29bcd1e7489421117fb9ee35
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
ifeq ($(USE_SYSTEM_GCC),yes)
  $(PKG)_DEPS :=
else
  ifeq ($(MXE_NATIVE_BUILD),yes)
    $(PKG)_DEPS := binutils
  else
    ifeq ($(MXE_SYSTEM),mingw)
      $(PKG)_DEPS := mingwrt w32api binutils
    endif
  endif
endif

ifneq ($(BUILD_SHARED),yes)
  $(PKG)_STATIC_FLAG := --static
endif

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS := \
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

ifeq ($(USE_SYSTEM_GCC),yes)
define $(PKG)_BUILD
    # create the CMake toolchain file
    [ -d '$(dir $(CMAKE_TOOLCHAIN_FILE))' ] || mkdir -p '$(dir $(CMAKE_TOOLCHAIN_FILE))'
    (if [ $(MXE_SYSTEM) = mingw ]; then \
       echo 'set(CMAKE_SYSTEM_NAME Windows)'; \
       echo 'set(MSYS 1)'; \
     fi; \
     if [ $(BUILD_SHARED) = yes ]; then \
       echo 'set(BUILD_SHARED_LIBS ON)'; \
     else \
       echo 'set(BUILD_SHARED_LIBS OFF)'; \
     fi; \
     if [ $(BUILD_STATIC) = yes ]; then \
       echo 'set(BUILD_STATIC_LIBS ON)'; \
     else \
       echo 'set(BUILD_STATIC_LIBS OFF)'; \
     fi; \
     echo 'set(CMAKE_BUILD_TYPE Release)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH $(HOST_PREFIX))'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)'; \
     echo 'set(CMAKE_C_COMPILER $(MXE_CC))'; \
     echo 'set(CMAKE_CXX_COMPILER $(MXE_CXX))'; \
     echo 'set(CMAKE_Fortran_COMPILER $(MXE_F77))'; \
     echo 'set(CMAKE_RC_COMPILER $(MXE_WINDRES))'; \
     echo 'set(PKG_CONFIG_EXECUTABLE $(MXE_PKG_CONFIG))'; \
     echo 'set(QT_QMAKE_EXECUTABLE $(MXE_QMAKE))'; \
     echo 'set(CMAKE_INSTALL_PREFIX $(HOST_PREFIX) CACHE PATH "Installation Prefix")'; \
     echo 'set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")') \
     > '$(CMAKE_TOOLCHAIN_FILE)'
endef
else
define $(PKG)_BUILD
    cd '$(1)' && ./contrib/download_prerequisites
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        --build='$(BUILD_SYSTEM)' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --libdir='$(BUILD_TOOLS_PREFIX)/lib' \
        --enable-languages='c,c++,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(ENABLE_SHARED_OR_STATIC) \
        --without-x \
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
             > '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-pkg-config'
    chmod 0755 '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-pkg-config'

    # create the CMake toolchain file
    [ -d '$(dir $(CMAKE_TOOLCHAIN_FILE))' ] || mkdir -p '$(dir $(CMAKE_TOOLCHAIN_FILE))'
    (echo 'set(CMAKE_SYSTEM_NAME Windows)'; \
     echo 'set(MSYS 1)'; \
     if [ $(BUILD_SHARED) = yes ]; then \
       echo 'set(BUILD_SHARED_LIBS ON)'; \
     else \
       echo 'set(BUILD_SHARED_LIBS OFF)'; \
     fi; \
     if [ $(BUILD_STATIC) = yes ]; then \
       echo 'set(BUILD_STATIC_LIBS ON)'; \
     else \
       echo 'set(BUILD_STATIC_LIBS OFF)'; \
     fi; \
     echo 'set(CMAKE_BUILD_TYPE Release)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH $(HOST_PREFIX))'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)'; \
     echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)'; \
     echo 'set(CMAKE_C_COMPILER $(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-gcc)'; \
     echo 'set(CMAKE_CXX_COMPILER $(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-g++)'; \
     echo 'set(CMAKE_Fortran_COMPILER $(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-gfortran)'; \
     echo 'set(CMAKE_RC_COMPILER $(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-windres)'; \
     echo 'set(PKG_CONFIG_EXECUTABLE $(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-pkg-config)'; \
     echo 'set(QT_QMAKE_EXECUTABLE $(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-qmake)'; \
     echo 'set(CMAKE_INSTALL_PREFIX $(HOST_PREFIX) CACHE PATH "Installation Prefix")'; \
     echo 'set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")') \
     > '$(CMAKE_TOOLCHAIN_FILE)'
endef
endif
