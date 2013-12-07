# This file is part of MXE.
# See index.html for further information.

PKG             := qscintilla
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3edf9d476d4e6af0706a4d33401667a38e3a697e
$(PKG)_SUBDIR   := QScintilla-gpl-$($(PKG)_VERSION)
$(PKG)_FILE     := QScintilla-gpl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/pyqt/files/QScintilla2/QScintilla-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := qt

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qscintilla.' >&2;
    echo $(qscintilla_VERSION)
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
    cd '$(1)/Qt4Qt5' && '$(HOST_BINDIR)/qmake' -makefile $($(PKG)_QMAKE_SPEC_OPTION)

    if [ $(MXE_SYSTEM) = msvc ]; then \
        mkdir -p '$(3)' && \
        cd '$(1)/Qt4Qt5' && \
        env -u MAKE -u MAKEFLAGS nmake && \
        env -u MAKE -u MAKEFLAGS nmake \
            INSTALL_ROOT=`cd $(3) && pwd -W | sed -e 's,^[a-zA-Z]:,,' -e 's,/,\\\\,g'` install; \
    else \
        $(MAKE) -C '$(1)/Qt4Qt5' -j '$(JOBS)' && \
        $(MAKE) -C '$(1)/Qt4Qt5' -j 1 install INSTALL_ROOT='$(3)'; \
    fi

    if [ $(MXE_SYSTEM) = mingw ]; then \
        $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
        $(INSTALL) -m755 '$(3)$(HOST_LIBDIR)/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll' '$(3)$(HOST_BINDIR)/'; \
        rm -f '$(3)$(HOST_LIBDIR)/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll'; \
    fi

    # Qmake under MSVC uses Win32 paths. When combining this with
    # DESTDIR usage (or equivalent), the real Win32 directory hierarchy
    # is recreated under DESTDIR, not the MSYS hierarchy.
    if [ $(MXE_SYSTEM) = msvc ]; then \
        $(INSTALL) -d '$(3)$(CMAKE_HOST_PREFIX)/bin'; \
        $(INSTALL) -m755 '$(3)$(CMAKE_HOST_PREFIX)/lib/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll' '$(3)$(CMAKE_HOST_PREFIX)/bin/'; \
        rm -f '$(3)$(CMAKE_HOST_PREFIX)/lib/$(LIBRARY_PREFIX)qscintilla2$(LIBRARY_SUFFIX).dll'; \
    fi
endef
