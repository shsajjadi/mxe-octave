# This file is part of MXE.
# See index.html for further information.

PKG             := build-binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.25
$(PKG)_CHECKSUM := b46cc90ebaba7ffcf6c6d996d60738881b14e50d
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifneq ($(MXE_NATIVE_BUILD),yes)
  define $(PKG)_POST_BUILD
    $(INSTALL) -d '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)'
    mv $(addprefix $(HOST_PREFIX)/bin/, ar as dlltool ld ld.bfd nm objcopy objdump ranlib strip) '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)'
  endef
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/binutils/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="binutils-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v '^2\.1' | \
    head -1
endef

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_DEPS += build-gcc
else
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS := \
    --target='$(TARGET)' \
    --build='$(BUILD_SYSTEM)' \
    --libdir='$(BUILD_TOOLS_PREFIX)/lib' \
    --disable-multilib \
    --with-sysroot='$(HOST_PREFIX)'
endif

define $(PKG)_BUILD
    # install config.guess for general use
    $(INSTALL) -d '$(BUILD_TOOLS_PREFIX)/bin'
    $(INSTALL) -m755 '$(1)/config.guess' '$(BUILD_TOOLS_PREFIX)/bin/'

    # install target-specific autotools config file
    $(INSTALL) -d '$(HOST_PREFIX)/share'
    echo "ac_cv_build=`$(1)/config.guess`" > '$(HOST_PREFIX)/share/config.site'

    cd '$(1)' && ./configure \
        $($(PKG)_SYSDEP_CONFIGURE_OPTIONS) \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --with-gcc \
        --with-gnu-ld \
        --with-gnu-as \
        --disable-nls \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-werror
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    $($(PKG)_POST_BUILD)
endef
