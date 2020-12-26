# This file is part of MXE.
# See index.html for further information.

PKG             := json-c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10
$(PKG)_CHECKSUM := f90f643c8455da21d57b3e8866868a944a93c596
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/downloads/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/json-c/json-c/downloads' | \
    $(SED) -n 's,.*href="/downloads/json-c/json-c/json-c-\([0-9.]*\).tar.gz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC)
        CFLAGS=-Wno-error
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-json-c.exe' \
        `'$(MXE_PKG_CONFIG)' json --cflags --libs`
endef
