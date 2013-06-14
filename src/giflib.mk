# This file is part of MXE.
# See index.html for further information.

PKG             := giflib
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 841da41f2e8c212555453f7af7b5aa60d7ea4be7
$(PKG)_SUBDIR   := giflib-$($(PKG)_VERSION)
$(PKG)_FILE     := giflib-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/giflib/giflib-5.x/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://giflib.git.sourceforge.net/git/gitweb.cgi?p=giflib/giflib;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>\([0-9][^<]*\)<.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    grep -v rc | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        CPPFLAGS='-D_OPEN_BINARY'
    echo 'all:' > '$(1)/doc/Makefile'
    $(MAKE) -C '$(1)/lib' -j '$(JOBS)' install
endef
