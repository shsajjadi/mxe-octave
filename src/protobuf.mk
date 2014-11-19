# This file is part of MXE.
# See index.html for further information.

PKG             := protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.1
$(PKG)_CHECKSUM := df5867e37a4b51fb69f53a8baf5b994938691d6d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://protobuf.googlecode.com/files/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://code.google.com/p/protobuf/downloads/list?sort=-uploaded' | \
    $(SED) -n 's,.*protobuf-\([0-9][^<]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
# First step: Build for host system in order to create "protoc" binary.
    cd '$(1)' && ./configure \
        $(ENABLE_SHARED_OR_STATIC)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cp '$(1)/src/protoc' '$(1)/src/protoc_host'
    $(MAKE) -C '$(1)' -j 1 distclean
# Second step: Build for target system.
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --with-zlib \
        --with-protoc=src/protoc_host
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    '$(MXE_CXX)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-protobuf.exe' \
        `'$(MXE_PKG_CONFIG)' protobuf --cflags --libs`
endef
