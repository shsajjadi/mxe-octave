# This file is part of MXE.
# See index.html for further information.

PKG             := readline
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a9761cd9c3da485eb354175fcc2fe35856bc43ac
$(PKG)_SUBDIR   := readline-$($(PKG)_VERSION)
$(PKG)_FILE     := readline-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/readline/$($(PKG)_FILE)

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_TERMCAP_LIB := termcap
else
  $(PKG)_TERMCAP_LIB := ncurses
endif

$(PKG)_DEPS := $($(PKG)_TERMCAP_LIB)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://tiswww.case.edu/php/chet/readline/rltop.html' | \
    grep 'readline-' | \
    $(SED) -n 's,.*readline-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,^ *case SIGQUIT:.*,,' '$(1)/signals.c'
    $(SED) -i 's,^ *case SIGTSTP:.*,,' '$(1)/signals.c'
    if test x$(MXE_SYSTEM) = xmsvc; then \
        for f in '$(1)/support/shlib-install' '$(1)/support/shobj-conf'; do \
            $(SED) -i -e 's/@@LIBRARY_PREFIX@@/$(LIBRARY_PREFIX)/g' \
                      -e 's/@@LIBRARY_SUFFIX@@/$(LIBRARY_SUFFIX)/g' $$f; \
        done; \
    fi
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-multibyte \
        --without-purify
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
