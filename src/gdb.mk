# This file is part of MXE.
# See index.html for further information.

PKG             := gdb
$(PKG)_VERSION  := 8.1
$(PKG)_CHECKSUM := 641861f7d3f22b6a23bc3e801f0ff29a78375490
$(PKG)_SUBDIR   := gdb-$($(PKG)_VERSION)
$(PKG)_FILE     := gdb-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := expat libiconv readline zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gdb/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gdb-\([0-9][^"]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

## Don't use --disable-static when configuring gdb as that will
## disable building the required libbfd.a library.

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --with-system-readline \
        CONFIG_SHELL=$(SHELL)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install MAKEINFO=true
endef
