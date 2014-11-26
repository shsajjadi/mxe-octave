# This file is part of MXE.
# See index.html for further information.

PKG             := nsis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.46
$(PKG)_CHECKSUM := 2cc9bff130031a0b1d76b01ec0a9136cdf5992ce
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/nsis/NSIS 2/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/p/nsis/code/HEAD/tree/NSIS/tags/' | \
    grep '<a href="' | \
    $(SED) -n 's,.*<a href="v\([0-9]\)\([^"]*\)".*,\1.\2,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && scons VERBOSE=1 \
        MINGW_CROSS_PREFIX='$(MXE_TOOL_PREFIX)' \
        PREFIX='$(HOST_PREFIX)' PREFIX_BIN=$(BUILD_TOOLS_PREFIX)/bin \
        `[ -d /usr/local/include ] && echo APPEND_CPPPATH=/usr/local/include` \
        `[ -d /usr/local/lib ]     && echo APPEND_LIBPATH=/usr/local/lib` \
        SKIPUTILS='NSIS Menu' \
        install
    $(INSTALL) -m755 '$(BUILD_TOOLS_PREFIX)/bin/makensis' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)makensis'
endef
