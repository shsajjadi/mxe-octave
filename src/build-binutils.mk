# This file is part of MXE.
# See index.html for further information.

PKG             := build-binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.23.1
$(PKG)_CHECKSUM := 587fca86f6c85949576f4536a90a3c76ffc1a3e1
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_DEPS     :=
else
  $(PKG)_DEPS     := build-gcc
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^2\.1' | \
    head -1
endef

define $(PKG)_BUILD
    # install config.guess for general use
    $(INSTALL) -d '$(BUILD_TOOLS_PREFIX)/bin'
    $(INSTALL) -m755 '$(1)/config.guess' '$(BUILD_TOOLS_PREFIX)/bin/'

    # install target-specific autotools config file
    $(INSTALL) -d '$(HOST_PREFIX)/share'
    echo "ac_cv_build=`$(1)/config.guess`" > '$(HOST_PREFIX)/share/config.site'

    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        --build='$(BUILD_SYSTEM)' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-werror
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(MAKE) -C '$(1)' -j 1 DESTDIR=$(TOP_DIR)/cross-tools install
endef
