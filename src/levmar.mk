# This file is part of MXE.
# See index.html for further information.

PKG             := levmar
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.6
$(PKG)_CHECKSUM := 118bd20b55ab828d875f1b752cb5e1238258950b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.ics.forth.gr/~lourakis/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := lapack blas libf2c

define $(PKG)_UPDATE
    $(WGET) --user-agent=MXE -q -O- "http://www.ics.forth.gr/~lourakis/levmar/"  | \
    $(SED) -n 's_.*Latest:.*levmar-\([0-9]\.[0-9]\).*_\1_ip' | \
    head -1;
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' liblevmar.a \
        CC=$(MXE_CC) \
        AR=$(MXE_AR) \
        RANLIB=$(MXE_RANLIB)
    $(INSTALL) -m644 '$(1)/levmar.h'    '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/liblevmar.a' '$(HOST_LIBDIR)'
endef
