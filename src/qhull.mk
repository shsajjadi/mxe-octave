# This file is part of MXE.
# See index.html for further information.

PKG             := qhull
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2009.1
$(PKG)_CHECKSUM := 108d59efa60b2ebaf94b121414c8f8b7b76a7409
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qhull-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.savannah.gnu.org/releases/qhull/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(ENABLE_QHULL_NO_STRICT_ALIASING_FLAG),yes)
  $(PKG)_CONFIGURE_CFLAGS := CFLAGS="-O2 -g -fno-strict-aliasing"
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qhull.' >&2;
    echo $(qhull_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal && libtoolize && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $($(PKG)_CONFIGURE_CFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)' $(MXE_DISABLE_DOCS)
endef
