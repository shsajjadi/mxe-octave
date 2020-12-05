# This file is part of MXE.
# See index.html for further information.

PKG             := libevent
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.0.20
$(PKG)_CHECKSUM := 20bb4a1a296ac93c08dfc32ae19ab874cab67a0c
$(PKG)_SUBDIR   := libevent-$($(PKG)_VERSION)-stable
$(PKG)_FILE     := libevent-$($(PKG)_VERSION)-stable.tar.gz
$(PKG)_URL      := https://github.com/downloads/$(PKG)/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/libevent/libevent/tags' | \
    $(SED) -n 's|.*releases/tag/release-\([^-]*\)-stable.*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= defexec_DATA=
endef
