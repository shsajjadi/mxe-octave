# This file is part of MXE.
# See index.html for further information.

PKG             := liboauth
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.0
$(PKG)_CHECKSUM := cc936a440084f159cc46dab9018f1353f8bee80a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://liboauth.sourceforge.net/pool/$($(PKG)_FILE)
$(PKG)_DEPS     := curl openssl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://liboauth.sourceforge.net/' | \
    $(SED) -n 's,.*liboauth-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-curl
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-liboauth.exe' \
        `'$(MXE_PKG_CONFIG)' oauth --cflags --libs`
endef
