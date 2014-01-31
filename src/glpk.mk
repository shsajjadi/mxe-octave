# This file is part of MXE.
# See index.html for further information.

PKG             := glpk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.52.1
$(PKG)_CHECKSUM := 63fd6788f95adb52789767b19e38cfb58dda331e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := glpk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/glpk/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package glpk.' >&2;
    echo $(glpk_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal && libtoolize && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
endef
