# This file is part of MXE.
# See index.html for further information.

PKG             := protobuf
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.1
$(PKG)_CHECKSUM := e0138dd2d8fd2433508838bb4aab4db926a0d6fe
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/google/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/google/protobuf/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
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
