# This file is part of MXE.
# See index.html for further information.

PKG             := cunit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1-2
$(PKG)_CHECKSUM := 6c2d0627eb64c09c7140726d6bf814cf531a3ce0
$(PKG)_SUBDIR   := CUnit-$($(PKG)_VERSION)
$(PKG)_FILE     := CUnit-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/cunit/CUnit/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/cunit/files/CUnit/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
