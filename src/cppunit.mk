# This file is part of MXE.
# See index.html for further information.

PKG             := cppunit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.1
$(PKG)_CHECKSUM := f1ab8986af7a1ffa6760f4bacf5622924639bf4a
$(PKG)_SUBDIR   := cppunit-$($(PKG)_VERSION)
$(PKG)_FILE     := cppunit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/cppunit/files/cppunit/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-doxygen \
        --disable-dot \
        --disable-html-docs \
        --disable-latex-docs
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
