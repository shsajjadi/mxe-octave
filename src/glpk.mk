# This file is part of MXE.
# See index.html for further information.

PKG             := glpk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.54
$(PKG)_CHECKSUM := 69d9c5d83271d34de1a58d2de2f7ababab975492
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := glpk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/glpk/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/glpk/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="glpk-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal && libtoolize && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)'
endef
