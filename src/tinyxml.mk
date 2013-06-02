# This file is part of MXE.
# See index.html for further information.

PKG             := tinyxml
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := cba3f50dd657cb1434674a03b21394df9913d764
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)_$(subst .,_,$($(PKG)_VERSION)).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/tinyxml/files/tinyxml/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && $(TARGET)-g++ -c -O3 -Wall -Wno-unknown-pragmas -Wno-format -D TIXML_USE_STL '$(1)'/*.cpp
    cd '$(1)' && $(TARGET)-ar cr libtinyxml.a *.o
    $(TARGET)-ranlib '$(1)/libtinyxml.a'
    $(INSTALL) -d               '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)'/*.a '$(HOST_LIBDIR)'
    $(INSTALL) -d               '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)'/*.h '$(HOST_INCDIR)'

    '$(TARGET)-g++' \
        -W -Wall -D TIXML_USE_STL -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-tinyxml.exe' \
        -ltinyxml
endef
