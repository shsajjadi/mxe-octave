# This file is part of MXE.
# See index.html for further information.

PKG             := qscintilla
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.4
$(PKG)_CHECKSUM := 7e15c261a7c1842f3a75e4878a880ab667224494
$(PKG)_SUBDIR   := QScintilla-gpl-$($(PKG)_VERSION)
$(PKG)_FILE     := QScintilla-gpl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/pyqt/files/QScintilla2/QScintilla-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := qt

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
      $(PKG)_INSTALL_ROOT :=
else
      $(PKG)_INSTALL_ROOT := $(3)
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.riverbankcomputing.com/software/qscintilla/download' | \
        grep QScintilla-gpl | \
        head -n 1 | \
        $(SED) -n 's,.*QScintilla-gpl-\([0-9][^>]*\)\.zip.*,\1,p'
endef

ifneq ($(MXE_NATIVE_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_QMAKE_SPEC_OPTION := -spec '$(HOST_PREFIX)/mkspecs/win32-g++'
  endif
  ifeq ($(MXE_SYSTEM),msvc)
    # FIXME: compute "2010" suffix dynamically
    $(PKG)_QMAKE_SPEC_OPTION := -spec '$(HOST_LIBDIR)/qt4/mkspecs/win32-msvc2010'
  endif
endif

define $(PKG)_BUILD
    cd '$(1)/Qt4Qt5' && '$(MXE_QMAKE)' -makefile $($(PKG)_QMAKE_SPEC_OPTION) QMAKE_UIC=$(MXE_UIC) QMAKE_MOC=$(MXE_MOC)

    if [ $(MXE_SYSTEM) = msvc ]; then \
        mkdir -p '$(3)' && \
        cd '$(1)/Qt4Qt5' && \
        env -u MAKE -u MAKEFLAGS nmake && \
        env -u MAKE -u MAKEFLAGS nmake \
            INSTALL_ROOT=`cd $(3) && pwd -W | sed -e 's,^[a-zA-Z]:,,' -e 's,/,\\\\,g'` install; \
    else \
        $(MAKE) -C '$(1)/Qt4Qt5' -j '$(JOBS)' && \
        $(MAKE) -C '$(1)/Qt4Qt5' -j 1 install INSTALL_ROOT='$($(PKG)_INSTALL_ROOT)'; \
    fi

    if [ $(MXE_SYSTEM) = mingw ]; then \
        $(INSTALL) -d '$($(PKG)_INSTALL_ROOT)$(HOST_BINDIR)'; \
        $(INSTALL) -m755 '$($(PKG)_INSTALL_ROOT)$(HOST_LIBDIR)/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll' '$($(PKG)_INSTALL_ROOT)$(HOST_BINDIR)/'; \
        rm -f '$($(PKG)_INSTALL_ROOT)$(HOST_LIBDIR)/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll'; \
    fi

    # Qmake under MSVC uses Win32 paths. When combining this with
    # DESTDIR usage (or equivalent), the real Win32 directory hierarchy
    # is recreated under DESTDIR, not the MSYS hierarchy.
    if [ $(MXE_SYSTEM) = msvc ]; then \
        $(INSTALL) -d '$($(PKG)_INSTALL_ROOT)$(CMAKE_HOST_PREFIX)/bin'; \
        $(INSTALL) -m755 '$($(PKG)_INSTALL_ROOT)$(CMAKE_HOST_PREFIX)/lib/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll' '$($(PKG)_INSTALL_ROOT)$(CMAKE_HOST_PREFIX)/bin/'; \
        rm -f '$($(PKG)_INSTALL_ROOT)$(CMAKE_HOST_PREFIX)/lib/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll'; \
    fi
endef
