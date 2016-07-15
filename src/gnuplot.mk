# This file is part of MXE.
# See index.html for further information.

PKG             := gnuplot
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.4
$(PKG)_CHECKSUM := 3a616a1beca8e86662afcc9d368aad6847ed4e0f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := gnuplot-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/gnuplot/files/gnuplot/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_EXTRAFLAGS := ICONV_CFLAGS='-I$(HOST_INCDIR)' ICONV_LDFLAGS='-L$(HOST_LIBDIR)'
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package gnuplot.' >&2;
    echo $(gnuplot_VERSION)
endef

ifeq ($(MXE_SYSTEM),mingw)
define $(PKG)_BUILD
    make -C '$(1)/config/mingw' $($(PKG)_EXTRAFLAGS) CC='$(MXE_CC)' CXX='$(MXE_CXX)' RC='$(MXE_WINDRES)' -j '$(JOBS)' TARGET=gnuplot.exe gnuplot.exe
    make -C '$(1)/config/mingw' $($(PKG)_EXTRAFLAGS) CC='$(MXE_CC)' CXX='$(MXE_CXX)' RC='$(MXE_WINDRES)' -j '$(JOBS)' TARGET=wgnuplot.exe wgnuplot.exe

    $(INSTALL) -d '$(3)$(HOST_BINDIR)'
    $(INSTALL) -m755 '$(1)/config/mingw/gnuplot.exe' '$(3)$(HOST_BINDIR)'
    $(INSTALL) -m755 '$(1)/config/mingw/wgnuplot.exe' '$(3)$(HOST_BINDIR)'
    $(INSTALL) -m644 '$(1)/src/win/wgnuplot.mnu' '$(3)$(HOST_BINDIR)'

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
