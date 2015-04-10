# This file is part of MXE.
# See index.html for further information.

PKG             := epstool
$(PKG)_VERSION  := 3.08
$(PKG)_CHECKSUM := dc495934f06d3ea8b3209e8b02ea96c66c34f614
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://pkgs.fedoraproject.org/repo/pkgs/epstool/epstool-3.08.tar.gz/465a57a598dbef411f4ecbfbd7d4c8d7/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && make CC="$(MXE_CC)" CLINK=$(MXE_CC) LDFLAGS="$(MXE_LDFLAGS)" CFLAGS="$(MXE_CFLAGS)" prefix="$(TOP_DIR)" EPSTOOL_ROOT="/usr"
    cd '$(1)' && make prefix="$(3)$(TOP_DIR)" EPSTOOL_ROOT="/usr" install
endef
