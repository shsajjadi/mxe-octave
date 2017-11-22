# This file is part of MXE.
# See index.html for further information.

PKG             := muparser
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.2
$(PKG)_CHECKSUM := 830383b1bcfa706be5a6ac8b7ba43f32f16a1497
$(PKG)_SUBDIR   := $(PKG)_v$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)_v$(subst .,_,$($(PKG)_VERSION)).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/Version $($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/beltoforion/muparser/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-samples \
        --disable-debug
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
