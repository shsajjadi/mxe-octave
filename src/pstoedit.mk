# This file is part of MXE.
# See index.html for further information.

PKG             := pstoedit
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 426f3746ecb441caa0db401d5880e1ac04a399d5
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/pstoedit/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package pstoedit.' >&2;
    echo $(pstoedit_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --prefix='$(HOST_PREFIX)' \
	&& $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)'
endef
