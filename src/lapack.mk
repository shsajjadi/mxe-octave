# This file is part of MXE.
# See index.html for further information.

PKG             := lapack
$(PKG)_CHECKSUM := 93a6e4e6639aaf00571d53a580ddc415416e868b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

ifeq ($(ENABLE_64),yes)
  $(PKG)_DEFAULT_INTEGER_8_FLAG := -fdefault-integer-8
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_CMAKE_FLAGS := -G 'MSYS Makefile'
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $($(PKG)_CMAKE_FLAGS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(MXE_AR)' \
        -DCMAKE_RANLIB='$(MXE_RANLIB)' \
        -DCMAKE_Fortran_FLAGS='$($(PKG)_DEFAULT_INTEGER_8_FLAG)' \
        .
    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)' VERBOSE=1 install
endef
