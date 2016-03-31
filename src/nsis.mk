# This file is part of MXE.
# See index.html for further information.

PKG             := nsis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.50
$(PKG)_CHECKSUM := 3748b81b83fb3d717da0db4178c228ac6e2a0543
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
ifeq ($(ENABLE_WINDOWS_64),yes)
define $(PKG)_BUILD
    cd '$(1)' && patch -p1 < $(TOP_DIR)/src/win64-nsis.patch

    cd '$(1)' && scons VERBOSE=1 \
        MINGW_CROSS_PREFIX='$(MXE_TOOL_PREFIX)' \
        PREFIX='$(HOST_PREFIX)' PREFIX_BIN=$(BUILD_TOOLS_PREFIX)/bin \
        APPEND_LIBPATH='$(HOST_PREFIX)/lib32' \
        SKIPUTILS='NSIS Menu' \
        install
    $(INSTALL) -m755 '$(BUILD_TOOLS_PREFIX)/bin/makensis' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)makensis'
endef
else
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
endif
