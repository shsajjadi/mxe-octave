# This file is part of MXE.
# See index.html for further information.

PKG             := native-binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.32
$(PKG)_CHECKSUM := cd45a512af1c8a508976c1beb4f5825b3bb89f4d
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_SYSDEP_OPTIONS :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^2\.1' | \
    head -1
endef

define $(PKG)_BUILD
    # install config.guess for general use
    $(INSTALL) -d '$(TOP_DIR)/dist/usr/bin'
    $(INSTALL) -m755 '$(1)/config.guess' '$(TOP_DIR)/dist/usr/bin/'

    # install target-specific autotools config file
    $(INSTALL) -d '$(TOP_DIR)/dist/usr/share'
    echo "ac_cv_build=`$(1)/config.guess`" > '$(TOP_DIR)/dist/usr/share/config.site'

    cd '$(1)' && ./configure \
        --target='$(TARGET)' \
        $($(PKG)_SYSDEP_OPTIONS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-werror
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
