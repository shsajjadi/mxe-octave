# This file is part of MXE.
# See index.html for further information.

PKG             := pdcurses
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := e36684442a6171cc3a5165c8c49c70f67db7288c
$(PKG)_SUBDIR   := PDCurses-$($(PKG)_VERSION)
$(PKG)_FILE     := PDCurses-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/pdcurses/pdcurses/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/pdcurses/files/pdcurses/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,copy,cp,' '$(1)/win32/mingwin32.mak'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libs -f '$(1)/win32/mingwin32.mak' \
        CC='$(TARGET)-gcc' \
        LIBEXE='$(TARGET)-ar' \
        DLL=N \
        PDCURSES_SRCDIR=. \
        WIDE=Y \
        UTF8=Y
    mv '$(1)/pdcurses.a' '$(1)/libcurses.a'
    $(TARGET)-ranlib '$(1)/libcurses.a' '$(1)/panel.a'
    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(1)/libcurses.a' --install '$(INSTALL)' --libdir '$(MXE_LIBDIR)' --bindir '$(MXE_BINDIR)'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(1)/panel.a' --install '$(INSTALL)' --libdir '$(MXE_LIBDIR)' --bindir '$(MXE_BINDIR)'; \
    fi
    if [ "$(BUILD_STATIC)" = yes ]; then \
      $(INSTALL) -m644 '$(1)/libcurses.a' '$(MXE_LIBDIR)/libcurses.a'
      $(INSTALL) -m644 '$(1)/panel.a'    '$(MXE_LIBDIR)/libpanel.a'
    fi
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include/'
    $(INSTALL) -m644 '$(1)/curses.h' '$(1)/panel.h' '$(1)/term.h' '$(MXE_INCDIR)'
endef
