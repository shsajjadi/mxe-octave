# This file is part of MXE.
# See index.html for further information.

PKG             := libffi
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bff6a6c886f90ad5e30dee0b46676e8e0297d81d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://sourceware.org/pub/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/atgreen/libffi/tags' | \
    grep '<a href="/atgreen/libffi/tarball/' | \
    $(SED) -n 's,.*href="/atgreen/libffi/tarball/v\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/$(TARGET)' -j '$(JOBS)'
    $(MAKE) -C '$(1)/$(TARGET)' -j 1 install DESTDIR='$(3)'

    if [ $(MXE_SYSTEM) != msvc ]; then \
        PKG_CONFIG_PATH='$(3)$(HOST_PREFIX)/lib/pkgconfig' \
        '$(MXE_CC)' \
            -W -Wall -Werror -std=c99 -pedantic \
            '$(2).c' -o '$(3)$(HOST_BINDIR)/test-libffi.exe' \
            `'$(MXE_PKG_CONFIG)' libffi --cflags --libs`; \
    fi
endef
