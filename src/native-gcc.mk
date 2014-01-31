# This file is part of MXE.
# See index.html for further information.

PKG             := native-gcc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.1
$(PKG)_CHECKSUM := 4e655032cda30e1928fcc3f00962f4238b502169
$(PKG)_SUBDIR   := gcc-$($(PKG)_VERSION)
$(PKG)_FILE     := gcc-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := mingwrt w32api build-binutils gcc-gmp gcc-mpc gcc-mpfr
ifneq ($(BUILD_SHARED),yes)
$(PKG)_STATIC_FLAG := --static
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gcc/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gcc-\([0-9][^"]*\)/".*,\1,p' | \
    grep -v '^4\.[543]\.' | \
    head -1
endef

define $(PKG)_BUILD
    # unpack support libraries
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-gmp,$(TAR))
    mv '$(1)/$(gcc-gmp_SUBDIR)' '$(1)/gmp'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpc,$(TAR))
    mv '$(1)/$(gcc-mpc_SUBDIR)' '$(1)/mpc'
    cd '$(1)' && $(call UNPACK_PKG_ARCHIVE,gcc-mpfr,$(TAR))
    mv '$(1)/$(gcc-mpfr_SUBDIR)' '$(1)/mpfr'

    # build GCC and support libraries
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --target='$(TARGET)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='/usr' \
        --libdir='/usr/lib' \
        --enable-languages='c,c++,fortran' \
        --enable-version-specific-runtime-libs \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-sjlj-exceptions \
        --without-x \
        --disable-win32-registry \
        --enable-threads=win32 \
        --disable-libgomp \
        --disable-libmudflap \
        --with-mpfr-include='$(1)/mpfr/src' \
        --with-mpfr-lib='$(1).build/mpfr/src/.libs' \
        --with-native-system-header-dir=$(HOST_INCDIR) \
        $(shell [ `uname -s` == Darwin ] && echo "LDFLAGS='-Wl,-no_pie'")
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 DESTDIR='$(TOP_DIR)/native-tools' install

    # # create pkg-config script
    # (echo '#!/bin/sh'; \
    #  echo 'PKG_CONFIG_PATH="$$PKG_CONFIG_PATH_$(subst -,_,$(TARGET))" PKG_CONFIG_LIBDIR='\''$(HOST_LIBDIR)/pkgconfig'\'' exec pkg-config $($(PKG)_STATIC_FLAG) "$$@"') \
    #          > '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'
    # chmod 0755 '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'

    # # create the CMake toolchain file
    # [ -d '$(dir $(CMAKE_TOOLCHAIN_FILE))' ] || mkdir -p '$(dir $(CMAKE_TOOLCHAIN_FILE))'
    # (echo 'set(CMAKE_SYSTEM_NAME Windows)'; \
    #  echo 'set(MSYS 1)'; \
    #  if [ $(BUILD_SHARED) = yes ]; then \
    #    echo 'set(BUILD_SHARED_LIBS ON)'; \
    #  else \
    #    echo 'set(BUILD_SHARED_LIBS OFF)'; \
    #  fi; \
    #  if [ $(BUILD_STATIC) = yes ]; then \
    #    echo 'set(BUILD_STATIC_LIBS ON)'; \
    #  else \
    #    echo 'set(BUILD_STATIC_LIBS OFF)'; \
    #  fi; \
    #  echo 'set(CMAKE_BUILD_TYPE Release)'; \
    #  echo 'set(CMAKE_FIND_ROOT_PATH $(HOST_PREFIX))'; \
    #  echo 'set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)'; \
    #  echo 'set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)'; \
    #  echo 'set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)'; \
    #  echo 'set(CMAKE_C_COMPILER $(MXE_CC))'; \
    #  echo 'set(CMAKE_CXX_COMPILER $(MXE_CXX))'; \
    #  echo 'set(CMAKE_Fortran_COMPILER $(MXE_F77))'; \
    #  echo 'set(CMAKE_RC_COMPILER $(MXE_WINDRES))'; \
    #  echo 'set(PKG_CONFIG_EXECUTABLE $(MXE_PKG_CONFIG))'; \
    #  echo 'set(QT_QMAKE_EXECUTABLE $(MXE_QMAKE))'; \
    #  echo 'set(CMAKE_INSTALL_PREFIX $(HOST_PREFIX) CACHE PATH "Installation Prefix")'; \
    #  echo 'set(CMAKE_BUILD_TYPE Release CACHE STRING "Debug|Release|RelWithDebInfo|MinSizeRel")') \
    #  > '$(CMAKE_TOOLCHAIN_FILE)'
endef
