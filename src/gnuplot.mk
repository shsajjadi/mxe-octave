# This file is part of MXE.
# See index.html for further information.

PKG             := gnuplot
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2.8
$(PKG)_CHECKSUM := dc018b1e0a31b770d4635958badff13498babc4d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := gnuplot-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/gnuplot/files/gnuplot/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_EXTRAFLAGS :=

ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_DEPS     += wxwidgets cairo pango lua
    $(PKG)_EXTRAFLAGS += CAIROTERMS=1 CAIROLIBS=1 
    $(PKG)_EXTRAFLAGS += WXT=1 WX_CONFIG=$(MXE_TOOL_PREFIX)wx-config
endif

ifeq ($(ENABLE_QT5),yes)
  $(PKG)_DEPS     += qt5
  $(PKG)_EXTRAFLAGS += QT=1 QT_DIR="$(HOST_PREFIX)/qt5" QT_BIN_DIR="$(BUILD_TOOLS_PREFIX)/bin"
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_EXTRAFLAGS += ICONV_CFLAGS='-I$(HOST_INCDIR)' ICONV_LDFLAGS='-L$(HOST_LIBDIR)'
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/gnuplot/files/gnuplot/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

ifeq ($(MXE_SYSTEM),mingw)
define $(PKG)_BUILD
    make -C '$(1)/config/mingw' $($(PKG)_EXTRAFLAGS) CC='$(MXE_CC)' CXX='$(MXE_CXX) -std=gnu++11' RC='$(MXE_WINDRES)' -j '$(JOBS)' TARGET=gnuplot.exe gnuplot.exe
    make -C '$(1)/config/mingw' $($(PKG)_EXTRAFLAGS) CC='$(MXE_CC)' CXX='$(MXE_CXX) -std=gnu++11' RC='$(MXE_WINDRES)' -j '$(JOBS)' TARGET=wgnuplot.exe wgnuplot.exe

    $(INSTALL) -d '$(3)$(HOST_BINDIR)'
    $(INSTALL) -m755 '$(1)/config/mingw/gnuplot.exe' '$(3)$(HOST_BINDIR)'
    $(INSTALL) -m755 '$(1)/config/mingw/wgnuplot.exe' '$(3)$(HOST_BINDIR)'
    $(INSTALL) -m644 '$(1)/src/win/wgnuplot.mnu' '$(3)$(HOST_BINDIR)'

    if [ "$(ENABLE_QT5)" == "yes" ]; then \
      make -C '$(1)/config/mingw' $($(PKG)_EXTRAFLAGS) CC='$(MXE_CC)' CXX='$(MXE_CXX) -std=gnu++11' RC='$(MXE_WINDRES)' -j '$(JOBS)' TARGET=gnuplot_qt.exe gnuplot_qt.exe; \
      $(INSTALL) -m755 '$(1)/config/mingw/gnuplot_qt.exe' '$(3)$(HOST_BINDIR)'; \
    fi

    # config files
    $(INSTALL) -d '$(3)$(HOST_PREFIX)/share'
    $(INSTALL) -m644 '$(1)/share/gnuplotrc' '$(3)$(HOST_PREFIX)/share/'

    for f in $(1)/share/*.gp; do \
      $(INSTALL) -m644 "$$f" '$(3)$(HOST_PREFIX)/share/'; \
    done

    # terminal support
    $(INSTALL) -d '$(3)$(HOST_PREFIX)/share/PostScript'
    for f in $(1)/term/PostScript/*.ps; do \
      $(INSTALL) -m644 "$$f" '$(3)$(HOST_PREFIX)/share/PostScript/'; \
    done
    for f in $(1)/term/PostScript/*.txt; do \
      $(INSTALL) -m644 "$$f" '$(3)$(HOST_PREFIX)/share/PostScript/'; \
    done
    # tikz terminal
    $(INSTALL) -d '$(3)$(HOST_PREFIX)/share/lua'
    $(INSTALL) -m644 "$(1)/term/lua/gnuplot-tikz.lua" '$(3)$(HOST_PREFIX)/share/lua/';
    $(INSTALL) -d '$(3)$(HOST_PREFIX)/share/texmf/tex/latex/gnuplot/'
    $(INSTALL) -m644 "$(1)/share/LaTeX/gnuplot-lua-tikz.sty" '$(3)$(HOST_PREFIX)/share/texmf/tex/latex/gnuplot/';
    $(INSTALL) -d '$(3)$(HOST_PREFIX)/share/texmf/tex/plain/gnuplot/'
    $(INSTALL) -m644 "$(1)/share/LaTeX/gnuplot-lua-tikz.tex" '$(3)$(HOST_PREFIX)/share/texmf/tex/plain/gnuplot/';
    $(INSTALL) -d '$(3)$(HOST_PREFIX)/share/texmf/tex/context/gnuplot/'
    $(INSTALL) -m644 "$(1)/share/LaTeX/t-gnuplot-lua-tikz.tex" '$(3)$(HOST_PREFIX)/share/texmf/tex/context/gnuplot/';
    $(INSTALL) -d '$(3)$(HOST_PREFIX)/share/texmf/tex/generic/gnuplot/'
    $(INSTALL) -m644 "$(1)/share/LaTeX/gnuplot-lua-tikz-common.tex" '$(3)$(HOST_PREFIX)/share/texmf/tex/generic/gnuplot/';

    ## MG: not sure what to do with these and how to integrate with DESTDIR
    $(INSTALL) -d '$(TOP_DIR)/gnuplot/bin'
    $(INSTALL) -m755 '$(1)/config/mingw/gnuplot.exe' '$(TOP_DIR)/gnuplot/bin/'
    $(INSTALL) -m755 '$(1)/config/mingw/wgnuplot.exe' '$(TOP_DIR)/gnuplot/bin/'
    $(INSTALL) -m644 '$(1)/src/win/wgnuplot.mnu' '$(TOP_DIR)/gnuplot/bin/'
endef
else
ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    $(INSTALL) -d '$(3)$(HOST_PREFIX)'
    cd '$(1)/config/msvc' && \
        env -u MAKE -u MAKEFLAGS nmake DESTDIR=$(shell (cd '$(HOST_PREFIX)' && pwd -W) | sed -e 's#/#\\\\#g') && \
        env -u MAKE -u MAKEFLAGS nmake DESTDIR=$(shell (cd '$(3)$(HOST_PREFIX)' && pwd -W) | sed -e 's#/#\\\\#g') install
endef
else
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
      $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) LIBS=-liconv \
      --without-lua --prefix='$(HOST_PREFIX)'
    make -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
endef
endif
endif
