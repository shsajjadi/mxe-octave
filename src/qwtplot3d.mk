# This file is part of MXE.
# See index.html for further information.

PKG             := qwtplot3d
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.2.7
$(PKG)_CHECKSUM := 4463fafb8420a91825e165da7a296aaabd70abea
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := qt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/$(PKG)/files/$(PKG)/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(MXE_QMAKE)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/lib/libqwtplot3d.a' '$(HOST_LIBDIR)'
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_INCDIR)/qwtplot3d'
    $(INSTALL) -m644 '$(1)/include'/*.h  '$(HOST_INCDIR)/qwtplot3d'
endef
