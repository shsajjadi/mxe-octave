# This file is part of MXE.
# See index.html for further information.

PKG             := libpng
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.6.37
$(PKG)_CHECKSUM := 3ab93fabbf4c27e1c4724371df408d9a1bd3f656
$(PKG)_SUBDIR   := libpng-$($(PKG)_VERSION)
$(PKG)_FILE     := libpng-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)$(subst .,,$(call SHORT_PKG_VERSION,$(PKG)))/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.simplesystems.org/pub/$(PKG)/png/src/$(PKG)$(subst .,,$(call SHORT_PKG_VERSION,$(PKG)))/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

# Configure script detection of memset and pow doesn't work on MSVC.
ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_CONFIGURE_OPTIONS := ac_cv_func_memset=yes ac_cv_func_pow=yes
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/p/libpng/code/ref/master/tags/' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<]*\)<.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    grep -v rc | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
	$($(PKG)_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'

    if [ ! "x$(MXE_NATIVE_BUILD)" = "xyes" ]; then \
      $(LN_SF) '$(HOST_BINDIR)/libpng-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)libpng-config'; \
    fi
endef
