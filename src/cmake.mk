# This file is part of MXE.
# See index.html for further information.

PKG             := cmake
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.20.1
$(PKG)_CHECKSUM := b09b025c81f584653eabb5a459b2378abf42f3bd
$(PKG)_SUBDIR   := cmake-$($(PKG)_VERSION)
$(PKG)_FILE     := cmake-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cmake.org/files/v$(call SHORT_PKG_VERSION,$(PKG))/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_CMAKE_OPTS :=
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CMAKE_OPTS := -G "MSYS Makefiles" 
  endif
else
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CMAKE_OPTS += -DKWSYS_LFS_WORKS=TRUE
  endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.cmake.org/cmake/resources/software.html' | \
    $(SED) -n 's,.*cmake-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        $($(PKG)_CMAKE_OPTS) \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        ../$($(PKG)_SUBDIR)
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
