# This file is part of MXE.
# See index.html for further information.

PKG             := pstoedit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.75
$(PKG)_CHECKSUM := b0fa3356efdca67bbc0c7c9145827c31384a6cc6
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/pstoedit/files/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)/download
$(PKG)_DEPS     := plotutils

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/$(PKG)/files/$(PKG)/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -I m4 
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --prefix='$(HOST_PREFIX)' \
	--disable-docs \
	&& $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)' $(MXE_DISABLE_DOCS)
endef
