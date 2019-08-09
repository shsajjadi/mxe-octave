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
    $(WGET) -q -O- 'http://www.ghostgum.com.au/software/epstool.htm' | \
    $(SED) -n 's|.*download/epstool-\([0-9].*\)\.tar\.gz\".*|\1|p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && make CC="$(MXE_CC)" CLINK=$(MXE_CC) LDFLAGS="$(MXE_LDFLAGS)" CFLAGS="$(MXE_CFLAGS)" prefix="$(HOST_PREFIX)" EPSTOOL_ROOT="/"
    cd '$(1)' && make prefix="$(3)$(HOST_PREFIX)" EPSTOOL_ROOT="/" install
endef
