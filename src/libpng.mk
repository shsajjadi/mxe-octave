# This file is part of MXE.
# See index.html for further information.

PKG             := libpng
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a6c0fc33b2031e4a9154da03c7d4e7807bc039e7
$(PKG)_SUBDIR   := libpng-$($(PKG)_VERSION)
$(PKG)_FILE     := libpng-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)$(subst .,,$(call SHORT_PKG_VERSION,$(PKG)))/older-releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.simplesystems.org/pub/$(PKG)/png/src/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

# Configure script detection of memset and pow doesn't work on MSVC.
ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_CONFIGURE_OPTIONS := ac_cv_func_memset=yes ac_cv_func_pow=yes
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://libpng.git.sourceforge.net/git/gitweb.cgi?p=libpng/libpng;a=tags' | \
    grep '<a class="list name"' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<]*\)<.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    grep -v rc | \
    grep -v '^1\.[0-4]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
	$($(PKG)_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    rm -f $(HOST_LIBDIR)/libpng.la
    rm -f $(HOST_LIBDIR)/libpng15.la
endef
