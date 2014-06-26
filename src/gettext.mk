# This file is part of MXE.
# See index.html for further information.

PKG             := gettext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.1
$(PKG)_CHECKSUM := 94cd6e81976aeb8ba35cf73967c60b72dd04af8d
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.gnu.org/software/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/gettext-runtime' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads=win32 \
        --without-libexpat-prefix \
        --without-libxml2-prefix \
        CONFIG_SHELL=$(SHELL) && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)/gettext-runtime' -j '$(JOBS)' install DESTDIR='$(3)'

    $(if $(filter msvc,$(MXE_SYSTEM)),
        cd '$(1)/gettext-tools' && ./configure \
            $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
            $(ENABLE_SHARED_OR_STATIC) \
            --prefix='$(HOST_PREFIX)' \
            --enable-threads=win32 \
            --without-libexpat-prefix \
            --without-libxml2-prefix \
	    ac_cv_func_memset=yes \
            CONFIG_SHELL=$(SHELL) && $(CONFIGURE_POST_HOOK)
        $(MAKE) -C '$(1)/gettext-tools' -j '$(JOBS)' install DESTDIR='$(3)'
    )
endef
