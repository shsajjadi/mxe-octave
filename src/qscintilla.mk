# This file is part of MXE.
# See index.html for further information.

PKG             := qscintilla
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 296c03343f5d84f0c06a16eb3fb706e0eb735ea6
$(PKG)_SUBDIR   := QScintilla-gpl-$($(PKG)_VERSION)/Qt4Qt5
$(PKG)_FILE     := QScintilla-gpl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/pyqt/files/QScintilla2/QScintilla-2.7/$($(PKG)_FILE)
$(PKG)_DEPS     := qt

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qscintilla.' >&2;
    echo $(qscintilla_VERSION)
endef

ifneq ($(MXE_NATIVE_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_QMAKE_SPEC_OPTION := -spec '$(HOST_PREFIX)/mkspecs/win32-g++'
  endif
endif

define $(PKG)_BUILD
    cd '$(1)' && '$(HOST_BINDIR)/qmake' -makefile $($(PKG)_QMAKE_SPEC_OPTION)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    if [ $(MXE_SYSTEM) = mingw ]; then \
      $(INSTALL) -m755 '$(HOST_LIBDIR)/qscintilla2.dll' '$(HOST_BINDIR)/qscintilla2.dll'; \
    fi
endef
