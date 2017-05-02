# This file is part of MXE.
# See index.html for further information.

PKG             := gettext
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.19.5.1
$(PKG)_CHECKSUM := bec084bc9e2ecfb9a30ce17a68b71865449f6c12
$(PKG)_SUBDIR   := gettext-$($(PKG)_VERSION)
$(PKG)_FILE     := gettext-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gettext/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gettext/' | \
    grep 'gettext-' | \
    $(SED) -n 's,.*gettext-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -Vr | \
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
    $(MAKE) -C '$(1)/gettext-runtime' -j '$(JOBS)' 
    $(MAKE) -C '$(1)/gettext-runtime' -j 1 $(MXE_DISABLE_DOCS) install DESTDIR='$(3)'

    cd '$(1)/gettext-tools' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads=win32 \
        --without-libexpat-prefix \
        --without-libxml2-prefix \
        $(if $(filter msvc,$(MXE_SYSTEM)),ac_cv_func_memset=yes) \
        CONFIG_SHELL=$(SHELL) && $(CONFIGURE_POST_HOOK)
     $(MAKE) -C '$(1)/gettext-tools' -j '$(JOBS)' 
     $(MAKE) -C '$(1)/gettext-tools' -j 1 install DESTDIR='$(3)' $(MXE_DISABLE_DOCS) bin_PROGRAMS=
     if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
       rm -rf $(3)$(HOST_PREFIX)/share/doc/$(PKG); \
     fi
endef
