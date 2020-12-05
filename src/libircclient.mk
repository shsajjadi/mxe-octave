# This file is part of MXE.
# See index.html for further information.

# Note that IPv6 support is partly broken and therefore disabled.
PKG             := libircclient
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6
$(PKG)_CHECKSUM := 10fb7a2478f6d668dce2d7fb5cd5a35ea8f53ed4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libircclient/files/libircclient/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --disable-debug \
        --enable-threads \
        --disable-ipv6
    $(MAKE) -C '$(1)'/src -j '$(JOBS)' static
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/src/libircclient.a' '$(HOST_LIBDIR)'
    $(INSTALL) -d '$(HOST_INCDIR)/libircclient'
    $(INSTALL) -m644 '$(1)/include/libircclient.h' '$(HOST_INCDIR)/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_errors.h' '$(HOST_INCDIR)/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_events.h' '$(HOST_INCDIR)/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_rfcnumeric.h' '$(HOST_INCDIR)/libircclient'
    $(INSTALL) -m644 '$(1)/include/libirc_options.h' '$(HOST_INCDIR)/libircclient'

    '$(MXE_CXX)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-libircclient.exe' \
        -lircclient -lws2_32
endef
