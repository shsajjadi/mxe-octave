# This file is part of MXE.
# See index.html for further information.

PKG             := qt5
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_DEPS     := $(patsubst $(TOP_DIR)/src/%.mk,%,\
                        $(shell grep -l 'qtbase_VERSION' \
                                $(TOP_DIR)/src/qt*.mk \
                                --exclude '$(TOP_DIR)/src/qt5.mk'))
$(PKG)_FILE      =
$(PKG)_URL       =
$(PKG)_CHECKSUM := #No checksum

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

