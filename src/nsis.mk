# This file is part of MXE.
# See index.html for further information.

PKG             := nsis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.03
$(PKG)_CHECKSUM := 101a9dd2dc06e8239d30741e0d723b633e091a2f
$(PKG)_SUBDIR   := nsis-$($(PKG)_VERSION)-src
$(PKG)_FILE     := nsis-$($(PKG)_VERSION)-src.tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/nsis/NSIS 3/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://nsis.sourceforge.io/Download' | \
    $(SED) -n 's,.*nsis-\([0-9.]\+\)-src.tar.*,\1,p' | \
    tail -1
endef

ifeq ($(ENABLE_WINDOWS_64),yes)
    $(PKG)_PREBUILD = \
        $(SED) -i 's/pei-i386/pei-x86-64/' '$(1)/SCons/Config/linker_script' && \
        $(SED) -i 's/m_target_type=TARGET_X86ANSI/m_target_type=TARGET_AMD64/' '$(1)/Source/build.cpp' 

    $(PKG)_TARGET_SCON_OPTIONS := TARGET_ARCH=amd64
endif

define $(PKG)_BUILD
    $($(PKG)_PREBUILD)
    cd '$(1)' && scons VERBOSE=1 \
        PATH='$(PATH)' \
        MINGW_CROSS_PREFIX='$(MXE_TOOL_PREFIX)' \
        PREFIX='$(BUILD_TOOLS_PREFIX)' \
        $($(PKG)_TARGET_SCON_OPTIONS) \
        SKIPUTILS='MakeLangId,Makensisw,NSIS Menu,zip2exe' \
        NSIS_MAX_STRLEN=8192 \
        install
    $(INSTALL) -m755 '$(BUILD_TOOLS_PREFIX)/bin/makensis' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)makensis'
endef
