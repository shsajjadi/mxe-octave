# This file is part of MXE.
# See index.html for further information.

PKG             := build-binutils
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.25.1
$(PKG)_CHECKSUM := 1d597ae063e3947a5f61e23ceda8aebf78405fcd
$(PKG)_SUBDIR   := binutils-$($(PKG)_VERSION)
$(PKG)_FILE     := binutils-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/binutils/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifneq ($(MXE_NATIVE_BUILD),yes)
ifneq ($(ENABLE_WINDOWS_64),yes)
  define $(PKG)_POST_BUILD
    $(INSTALL) -d '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)'
    mv $(addprefix $(HOST_PREFIX)/bin/, ar as dlltool ld ld.bfd nm objcopy objdump ranlib strip) '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)'
  endef
else
  define $(PKG)_POST_BUILD
    rm $(addprefix $(HOST_PREFIX)/bin/, ar as dlltool ld ld.bfd nm objcopy objdump ranlib strip)
  endef
endif
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

  ifeq ($(ENABLE_WINDOWS_64),yes)
    $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
      --enable-multilib \
      --with-sysroot='$(BUILD_TOOLS_PREFIX)' \
      --enable-targets=x86_64-w64-mingw32,i686-w64-mingw32
  else
    $(PKG)_SYSDEP_CONFIGURE_OPTIONS += \
      --libdir='$(BUILD_TOOLS_PREFIX)/lib' \
      --disable-multilib \
      --with-sysroot='$(HOST_PREFIX)'
  endif
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
