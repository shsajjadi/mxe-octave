# This file is part of MXE.
# See index.html for further information.

PKG             := build-scons
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.6
$(PKG)_CHECKSUM := 97af955770cd79518717b96681d0fc4cb3d965a1
$(PKG)_SUBDIR   := scons-$($(PKG)_VERSION)
$(PKG)_FILE     := scons-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://prdownloads.sourceforge.net/scons/$($(PKG)_FILE)
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_DEPS     := 
else
    $(PKG)_DEPS     := build-python
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- https://sourceforge.net/projects/scons/files/scons/ | \
    $(SED) -n 's|.*<tr title=\"\([0-9][^"]*\)".*|\1|p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && python setup.py install --prefix='$(BUILD_TOOLS_PREFIX)'
endef
