# This file is part of MXE.
# See index.html for further information.

PKG             := qhull
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 108d59efa60b2ebaf94b121414c8f8b7b76a7409
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qhull-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.savannah.gnu.org/releases/qhull/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qhull.' >&2;
    echo $(qhull_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal && libtoolize && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
endef
