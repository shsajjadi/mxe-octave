# This file is part of MXE.
# See index.html for further information.

PKG             := lcms
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9944902864283af49e4e21a1ca456db4e04ea7c2
$(PKG)_SUBDIR   := $(PKG)$(word 1,$(subst ., ,$($(PKG)_VERSION)))-$(subst a,,$($(PKG)_VERSION))
$(PKG)_FILE     := $(PKG)$(word 1,$(subst ., ,$($(PKG)_VERSION)))-$(subst a,,$($(PKG)_VERSION)).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$(subst a,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc jpeg tiff zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/lcms/files/lcms/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --with-jpeg \
        --with-tiff \
        --with-zlib
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
endef
