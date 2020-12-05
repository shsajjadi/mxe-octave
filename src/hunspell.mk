# This file is part of MXE.
# See index.html for further information.

PKG             := hunspell
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 902c76d2b55a22610e2227abc4fd26cbe606a51c
$(PKG)_SUBDIR   := hunspell-$($(PKG)_VERSION)
$(PKG)_FILE     := hunspell-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/hunspell/hunspell/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := libiconv gettext readline pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/hunspell/hunspell/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    # Note: the configure file doesn't pick up pdcurses, so "ui" is disabled
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --with-warnings \
        --without-ui \
        --with-readline \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=


    # Test
    '$(MXE_CXX)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-hunspell.exe' \
        `'$(MXE_PKG_CONFIG)' hunspell --cflags --libs`
endef
