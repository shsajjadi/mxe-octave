# This file is part of MXE. See LICENSE.md for licensing information.

PKG             := opus
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.1
$(PKG)_CHECKSUM := ed226536537861c9f0f1ef7ca79dffc225bc181b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://archive.mozilla.org/pub/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://archive.mozilla.org/pub/opus/?C=M;O=D' | \
    $(SED) -n 's,.*opus-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v 'alpha' | \
    grep -v 'beta' | \
    grep -v 'rc' | \
    $(SORT) -Vr | \
    head -1
endef

$(PKG)_EXTRA_CONFIGURE_OPTIONS :=
ifneq ($(filter mingw msvc,$(MXE_SYSTEM)),)
    $(PKG)_EXTRA_CONFIGURE_OPTIONS += CFLAGS="-O2 -g -fstack-protector"
endif

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $($(PKG)_EXTRA_CONFIGURE_OPTIONS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
	--prefix='$(HOST_PREFIX)' \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS)
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
    #rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/opus_*.3
    #rm -f '$(PREFIX)/$(TARGET)'/share/man/man3/opus.h.3
    #rm -rf '$(PREFIX)/$(TARGET)'/share/doc/opus/html
endef
