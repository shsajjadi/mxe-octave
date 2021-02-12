# This file is part of MXE.
# See index.html for further information.

PKG             := libf2c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1
$(PKG)_CHECKSUM := f71066b41695738dec2261de71eaf02a1aaffe8b
$(PKG)_SUBDIR   :=
$(PKG)_FILE     := $(PKG).zip
$(PKG)_URL      := http://www.netlib.org/f2c/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f makefile.u \
        CC=$(MXE_CC) \
        AR=$(MXE_AR) \
        LD=$(MXE_LD) \
        RANLIB=$(MXE_RANLIB) \
        CFLAGS='-O -DUSE_CLOCK'
    $(INSTALL) -m644 '$(1)/libf2c.a' '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/f2c.h'    '$(HOST_INCDIR)'
endef
