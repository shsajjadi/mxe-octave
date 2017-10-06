# This file is part of MXE.
# See index.html for further information.

PKG             := native-binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.29.1
$(PKG)_CHECKSUM := 172244a349d07ec205c39c0321cbc354c125e78e
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_SYSDEP_OPTIONS :=
ifeq ($(ENABLE_WINDOWS_64),yes)
    $(PKG)_SYSDEP_OPTIONS += \
      --enable-multilib \
      --enable-targets=x86_64-w64-mingw32,i686-w64-mingw32
endif


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
