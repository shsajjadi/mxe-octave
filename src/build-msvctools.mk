# This file is part of MXE.
# See index.html for further information.

PKG             := build-msvctools
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a464ba0f26eef24c29bcd1e7489421117fb9ee35
$(PKG)_FILE     := gcc-$(build-gcc_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gcc/gcc-$(build-gcc_VERSION)/$($(PKG)_FILE)
$(PKG)_SUBDIR   := build-msvctools
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    make -C '$(1)' -j '$(JOBS)' \
	DESTDIR='$(HOST_PREFIX)' \
	GCCVERSION='$(build-gcc_VERSION)' \
	INSTALL='$(INSTALL)' \
	LIBRARY_PREFIX='$(LIBRARY_PREFIX)' \
	LIBRARY_SUFFIX='$(LIBRARY_SUFFIX)' \
	PATCH='$(PATCH)' \
	SED='$(SED)' \
	WGET='$(WGET)' \
	install
endef
