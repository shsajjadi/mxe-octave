# This file is part of MXE.
# See index.html for further information.

PKG             := libxshmfence
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2
$(PKG)_CHECKSUM := 5745d9977d8d0374f37548a96384bf27190aa5ab
$(PKG)_SUBDIR   := libxshmfence-$($(PKG)_VERSION)
$(PKG)_FILE     := libxshmfence-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.x.org/releases/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     := xproto

ifeq ($(MXE_WINDOWS_BUILD),yes)
  define $(PKG)_BUILD
  endef
else
  define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
  endef
endif
