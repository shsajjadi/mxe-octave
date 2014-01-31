# This file is part of MXE.
# See index.html for further information.

PKG             := gsl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.15
$(PKG)_CHECKSUM := d914f84b39a5274b0a589d9b83a66f44cd17ca8e
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.savannah.gnu.org/gitweb/?p=$(PKG).git;a=tags' | \
    grep '<a class="list subject"' | \
    $(SED) -n 's,.*<a[^>]*>[^0-9>]*\([0-9][^<]*\)<.*,\1,p' | \
    head -1
endef

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_EXTRA_CONFIGURE_OPTIONS := \
        ac_cv_func_memcpy=yes \
        ac_cv_c_inline=no
endif

define $(PKG)_BUILD
    if [ $(MXE_SYSTEM) = msvc ]; then \
        cd '$(1)' && autoreconf -i -f -v; \
    fi
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --enable-maintainer-mode \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
	$($(PKG)_EXTRA_CONFIGURE_OPTIONS) \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
