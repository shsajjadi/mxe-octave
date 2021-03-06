# This file is part of MXE.
# See index.html for further information.

PKG             := zziplib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.13.59
$(PKG)_CHECKSUM := ddbce25cb36c3b4c2b892e2c8a88fa4a0be29a71
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)$(word 2,$(subst ., ,$($(PKG)_VERSION)))/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/zziplib/files/' | \
    $(SED) -n 's,.*zziplib-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # don't build and install docs
    (echo '# DISABLED'; echo 'all:'; echo 'install:') > '$(1)/docs/Makefile.in'
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --disable-mmap \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
