# This file is part of MXE.
# See index.html for further information.

PKG             := qhull
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2015.2
$(PKG)_CHECKSUM := 0dd03e0232124c81c696fac60db71ca7327eb16e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qhull-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/qhull/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

$(PKG)_CMAKE_OPTS :=
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CMAKE_OPTS := -G "MSYS Makefiles" 
  endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/qhull/qhull/tags' | \
    $(SED) -n 's|.*releases/tag/\([0-9][^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1)/../.build'
    cd '$(1)/../.build' && cmake \
        $($(PKG)_CMAKE_OPTS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'  \
        ../$($(PKG)_SUBDIR)
    make -C $(1)/../.build -j $(JOBS) 
    make -C $(1)/../.build -j 1 install DESTDIR=$(3)
endef
