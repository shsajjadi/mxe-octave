PKG             := icu4c
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 69.1
$(PKG)_CHECKSUM := 620a71c84428758376baa0fb81a581c3daa866ce
$(PKG)_SUBDIR   := icu
$(PKG)_FILE     := $(PKG)-$(subst .,_,$($(PKG)_VERSION))-src.tgz
$(PKG)_URL      := https://github.com/unicode-org/icu/releases/download/release-$(subst .,-,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/unicode-org/icu/tags' | \
    $(SED) -n 's|.*releases/tag/release-\([0-9\-]*\).*|\1|p' | \
    $(SED) 's|-|\.|g' | \
    $(SORT) -V | \
    tail -1
endef

ifeq ($(MXE_NATIVE_BUILD),no)
define $(PKG)_BUILD
    # build some native tools
    mkdir '$(1).native' && cd '$(1).native' && '$(1)/source/configure'
    $(MAKE) -C '$(1).native' -j '$(JOBS)'

    # build cross
    mkdir '$(1).cross' && cd '$(1).cross' && '$(1)/source/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-cross-build='$(1).native' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH=$($(PKG)_PKG_CONFIG_PATH) \
        CPPFLAGS='-DU_USING_ICU_NAMESPACE=0'

    $(MAKE) -C '$(1).cross' -j '$(JOBS)' $(MXE_DISABLE_DOCS) $(MXE_DISABLE_PROGS)
    $(MAKE) -C '$(1).cross' -j 1 install $(MXE_DISABLE_DOCS) $(MXE_DISABLE_PROGS) DESTDIR='$(3)'
    $(INSTALL) -d '$(3)$(HOST_BINDIR)'
    #mv -fv $(3)$(HOST_LIBDIR)/icu*.dll '$(3)$(HOST_BINDIR)/'
    $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin/'
    $(LN_SF) '$(HOST_BINDIR)/icu-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)icu-config'
endef
else
define $(PKG)_BUILD
    mkdir '$(1).native' && cd '$(1).native' && '$(1)/source/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH="$(HOST_LIBDIR)/pkgconfig" \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1).native' -j '$(JOBS)' $(MXE_DISABLE_DOCS) $(MXE_DISABLE_PROGS)
    $(MAKE) -C '$(1).native' -j 1 install $(MXE_DISABLE_DOCS) $(MXE_DISABLE_PROGS)
endef
endif

