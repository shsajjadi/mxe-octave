# This file is part of MXE.
# See index.html for further information.

PKG             := build-gettext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.8.1
$(PKG)_CHECKSUM := b5d24ba2958c91fc5cc0058165837c99a0f58784
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --without-libexpat-prefix \
        --without-libxml2-prefix \
	$($(PKG)_CONFIGURE_OPTIONS)
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    if test x$(MXE_SYSTEM) = xmsvc; then \
        cd '$(1).build' && $(CONFIGURE_POST_HOOK); \
    fi
    $(MAKE) -C '$(1).build' -j 1 $(MXE_DISABLE_DOCS) install DESTDIR='$(3)'
endef
