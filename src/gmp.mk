# This file is part of MXE.
# See index.html for further information.

PKG             := gmp
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.1.3
$(PKG)_CHECKSUM := b35928e2927b272711fdfbf71b7cfd5f86a6b165
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gmplib.org/pub/$(PKG)-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.cs.tu-berlin.de/pub/gnu/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_CONFIGURE_OPTIONS := CC_FOR_BUILD='$(MXE_CC)' CCAS='gcc -c' ac_cv_func_memset='yes'
    COMMA := ,
else
    $(PKG)_CONFIGURE_OPTIONS := CC_FOR_BUILD=gcc
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.gmplib.org/' | \
    grep '<a href="' | \
    $(SED) -n 's,.*gmp-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v '^4\.' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(filter msvc,$(MXE_SYSTEM)), \
        $(SED) -i -e '/^#ifdef _MSC_VER/$(COMMA)/^#endif/ {/^ *#define __GMP_EXTERN_INLINE .*/d}' '$(1)/gmp-h.in')
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $($(PKG)_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --enable-cxx \
        --without-readline && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
