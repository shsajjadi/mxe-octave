# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# POCO C++ Libraries
PKG             := poco
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.3p1
$(PKG)_CHECKSUM := 9e1ef31d369c67eef2d3ce1ca8f2b6ac5cc38ec4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_WEBSITE  := http://pocoproject.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/sources/$(PKG)-$(word 1,$(subst p, ,$($(PKG)_VERSION)))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://pocoproject.org/download/' | \
    $(SED) -n 's,.*poco-\([0-9][^>/]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --config=MinGW-CrossEnv \
        --static \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-poco.exe' \
        -lPocoFoundation
endef
