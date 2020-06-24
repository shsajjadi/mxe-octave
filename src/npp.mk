# This file is part of MXE.
# See index.html for further information.

PKG             := npp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.8.7
$(PKG)_CHECKSUM := 54380d19f76216e1a6fd717acf724147b1012235
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := $(PKG).$($(PKG)_VERSION).bin.zip
$(PKG)_URL      := https://github.com/notepad-plus-plus/notepad-plus-plus/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://notepad-plus-plus.org/downloads/' | \
    $(GREP) 'Current' | \
    $(SED) -n 's|.*/v\([^/]*\).*|\1|p' | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir -p '$(NOTEPAD_BASE_DIR)'
    cd '$(1)' && tar cf - . | ( cd '$(NOTEPAD_BASE_DIR)'; tar xpf - )
endef
