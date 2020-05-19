# This file is part of MXE.
# See index.html for further information.

PKG             := fribidi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.9
$(PKG)_CHECKSUM := 6646193abcbdb8434ff0cc5da28c252a59e7dfb4
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://github.com/fribidi/fribidi/releases/download/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := glib

define $(PKG)_UPDATE
    $(WGET) -q -O- https://github.com/fribidi/fribidi/tags | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,__declspec(dllimport),,' '$(1)/lib/fribidi-common.h'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-debug \
        --disable-deprecated \
        --enable-charsets \
        --with-glib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
