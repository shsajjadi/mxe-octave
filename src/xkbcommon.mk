# This file is part of MXE.
# See index.html for further information.

PKG             := xkbcommon
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.4
$(PKG)_CHECKSUM := 0f533ffdc7fe888eedf10648895b64b01e94d06e
$(PKG)_SUBDIR   := libxkbcommon-$(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/libxkbcommon/archive/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/$(PKG)/libxkbcommon/tags' | \
    $(SED) -n 's|.*releases/tag/$(PKG)-\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./autogen.sh && \
      $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
