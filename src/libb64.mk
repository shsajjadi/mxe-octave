# This file is part of MXE.
# See index.html for further information.

PKG             := libb64
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := 04b3e21b8c951d27f02fe91249ca3474554af0b9
$(PKG)_SUBDIR   := libb64-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://sourceforge.net/projects/$(PKG)/files/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libb64/files/' | \
    $(SED) -n 's_.*libb64-\([0-9]\.[0-9]\.[0-9]\).*zip_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD

    CC=$(MXE_CC) CXX=$(MXE_CXX) PKG_CONFIG=$(MXE_PKG_CONFIG) AR=$(MXE_AR) CFLAGS='-fPIE' $(MAKE) -C '$(1)/src'

    $(INSTALL) -d '$(3)$(HOST_LIBDIR)'
    $(INSTALL) -d '$(3)$(HOST_INCDIR)/b64'
    $(INSTALL) -m644 '$(1)/include/b64/'*.h '$(3)$(HOST_INCDIR)/b64/'
    $(INSTALL) -m644 '$(1)/src/libb64.a' '$(3)$(HOST_LIBDIR)/'

endef
