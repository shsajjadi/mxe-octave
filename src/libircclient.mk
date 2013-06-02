# This file is part of MXE.
# See index.html for further information.

# Note that IPv6 support is partly broken and therefore disabled.
PKG             := libircclient
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 10fb7a2478f6d668dce2d7fb5cd5a35ea8f53ed4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libircclient/files/libircclient/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        --host='$(TARGET)' \
        --disable-debug \
        --enable-threads \
        --disable-ipv6
    $(MAKE) -C '$(1)'/src -j '$(JOBS)' static
    $(INSTALL) -d '$(HOST_PREFIX)/lib'
    $(INSTALL) -m644 '$(1)/src/libircclient.a' '$(HOST_PREFIX)/lib/'
    $(INSTALL) -d '$(HOST_PREFIX)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libircclient.h' '$(HOST_PREFIX)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_errors.h' '$(HOST_PREFIX)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_events.h' '$(HOST_PREFIX)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_rfcnumeric.h' '$(HOST_PREFIX)/include/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_options.h' '$(HOST_PREFIX)/include/libircclient'

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(HOST_PREFIX)/bin/test-libircclient.exe' \
        -lircclient -lws2_32
endef
