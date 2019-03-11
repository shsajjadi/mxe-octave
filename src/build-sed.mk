# This file is part of MXE.
# See index.html for further information.

PKG             := build-sed
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.7
$(PKG)_CHECKSUM := dbc842f6fdf538f366d97e7c4b4f241eaefd14a5
$(PKG)_SUBDIR   := sed-$($(PKG)_VERSION)
$(PKG)_FILE     := sed-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/sed/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/sed/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="sed-\([0-9\.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
