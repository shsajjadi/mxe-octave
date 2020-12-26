# This file is part of MXE.
# See index.html for further information.

PKG             := readline
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0
$(PKG)_CHECKSUM := d58041c2143595dc001d2777ae9a200be30198b0
$(PKG)_SUBDIR   := readline-$($(PKG)_VERSION)
$(PKG)_FILE     := readline-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/gnu/readline/$($(PKG)_FILE)

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_TERMCAP_LIB := termcap
  $(PKG)_CONFIGURE_OPTIONS := --without-curses
else
  $(PKG)_TERMCAP_LIB := ncurses
  ifeq ($(MXE_NATIVE_BUILD),yes)
    $(PKG)_CONFIGURE_OPTIONS := --with-curses bash_cv_termcap_lib="-lncurses"
    $(PKG)_MAKE_OPTIONS := SHLIB_LIBS="-lncurses"
  endif
endif

$(PKG)_DEPS := $($(PKG)_TERMCAP_LIB)

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://tiswww.case.edu/php/chet/readline/rltop.html' | \
    grep 'readline-' | \
    $(SED) -n 's,.*readline-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    if test x$(MXE_SYSTEM) = xmsvc; then \
        for f in '$(1)/support/shlib-install' '$(1)/support/shobj-conf'; do \
            $(SED) -i -e 's/@@LIBRARY_PREFIX@@/$(LIBRARY_PREFIX)/g' \
                      -e 's/@@LIBRARY_SUFFIX@@/$(LIBRARY_SUFFIX)/g' $$f; \
        done; \
    fi
    cd '$(1)' &&  bash_cv_wcwidth_broken=no \
        ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        $($(PKG)_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --enable-multibyte \
        --without-purify
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_OPTIONS) install DESTDIR='$(3)'
endef
