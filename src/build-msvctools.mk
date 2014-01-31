# This file is part of MXE.
# See index.html for further information.

PKG             := build-msvctools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 
$(PKG)_CHECKSUM := 4e655032cda30e1928fcc3f00962f4238b502169
$(PKG)_FILE     := gcc-$(build-gcc_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$(build-gcc_VERSION)/$($(PKG)_FILE)
$(PKG)_SUBDIR   := build-msvctools
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 1
endef

$(PKG)_CMAKE_DESTDIR := $(BUILD_TOOLS_PREFIX)/share/cmake-$(call SHORT_PKG_VERSION,build-cmake)

define $(PKG)_BUILD
    make -C '$(1)' -j 1 \
	DESTDIR='$(3)$(HOST_PREFIX)' \
	CMAKE_DESTDIR='$($(PKG)_CMAKE_DESTDIR)' \
	GCCVERSION='$(build-gcc_VERSION)' \
	INSTALL='$(INSTALL)' \
	LIBRARY_PREFIX='$(LIBRARY_PREFIX)' \
	LIBRARY_SUFFIX='$(LIBRARY_SUFFIX)' \
	PATCH='$(PATCH)' \
	SED='$(SED)' \
	WGET='$(WGET)' \
	install
endef
