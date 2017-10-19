# This file is part of MXE.
# See index.html for further information.

PKG             := pixman
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.34.0
$(PKG)_CHECKSUM := 367698744e74d6d4f363041482965b9ea7fbe4a5
$(PKG)_SUBDIR   := pixman-$($(PKG)_VERSION)
$(PKG)_FILE     := pixman-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://cairographics.org/snapshots/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.x.org/archive/individual/lib/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cairographics.org/snapshots/?C=M;O=D' | \
    $(SED) -n 's,.*"pixman-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
