# This file is part of MXE.
# See index.html for further information.

PKG             := cmake
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7.1
$(PKG)_CHECKSUM := d00c720847c0a2aff817c36377569efbb677fb08
$(PKG)_SUBDIR   := cmake-$($(PKG)_VERSION)
$(PKG)_FILE     := cmake-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cmake.org/files/v3.7/$($(PKG)_FILE)
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
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        $($(PKG)_CMAKE_OPTS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'  \
        ../$($(PKG)_SUBDIR)
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef