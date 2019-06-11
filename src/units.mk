# This file is part of MXE.
# See index.html for further information.

PKG             := units
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.19
$(PKG)_CHECKSUM := 8c241b04046cafa4a4503dc3567d8d869b46329c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/$(PKG)/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="$(PKG)-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) 

    # override units and localalemap from what configure detected for cross mingw
    if [ "$(MXE_SYSTEM)$(MXE_NATIVE_BUILD)" == "mingwno" ]; then \
        $(SED) -i -e 's,UNITSFILE=\\\".*definitions.units\\\",UNITSFILE=\\\"definitions.units\\\",g' \
	    -e 's,LOCALEMAP=\\\".*locale_map.txt\\\",LOCALEMAP=\\\"locale_map.txt\\\",g' \
	    '$(1)/Makefile'; \
    fi

    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
