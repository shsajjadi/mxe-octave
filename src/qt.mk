# This file is part of MXE.
# See index.html for further information.

PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bc352a283610e0cd2fe0dbedbc45613844090fcb
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://releases.qt-project.org/qt4/source/$($(PKG)_FILE)

ifeq ($(MXE_SYSTEM),mingw)
  ifeq ($(MXE_NATIVE_BUILD),yes)
    $(PKG)_DEPS   := freetds openssl zlib libpng jpeg libmng tiff dbus

    $(PKG)_CONFIGURE_ENV := \
      OPENSSL_LIBS="`'$(MXE_PKG_CONFIG)' --libs-only-l openssl`" \
      QTDIR='$(HOST_PREFIX)' 

  else
    $(PKG)_DEPS   := libodbc++ postgresql freetds openssl zlib libpng jpeg libmng tiff sqlite dbus

    $(PKG)_CONFIGURE_ENV := \
      OPENSSL_LIBS="`'$(MXE_PKG_CONFIG)' --libs-only-l openssl`" \
      PSQL_LIBS="-lpq -lsecur32 `'$(MXE_PKG_CONFIG)' --libs-only-l openssl` -lws2_32" \
      SYBASE_LIBS="-lsybdb `'$(MXE_PKG_CONFIG)' --libs-only-l gnutls` -liconv -lws2_32"

  endif

else
  $(PKG)_DEPS   := postgresql freetds openssl zlib libpng jpeg libmng tiff sqlite dbus

  $(PKG)_CONFIGURE_ENV := \
    CPPFLAGS='$(HOST_INCDIR)/dbus-1.0' \
    LDFLAGS='-Wl,-rpath-link,$(HOST_LIBDIR) -L$(HOST_LIBDIR)'
endif

$(PKG)_CONFIGURE_INCLUDE_OPTION := -I '$(HOST_INCDIR)'
$(PKG)_CONFIGURE_LIBPATH_OPTION := -L '$(HOST_LIBDIR)'

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_CONFIGURE_CMD := configure.exe
  $(PKG)_CONFIGURE_DATABASE_OPTION := 
  $(PKG)_CONFIGURE_PLATFORM_OPTION := -platform win32-g++
  $(PKG)_CONFIGURE_EXTRA_OPTION := 
else
  $(PKG)_CONFIGURE_CMD := configure
  $(PKG)_CONFIGURE_EXTRA_OPTION := \
      -prefix-install \
      -make libs \
      -openssl-linked \
      -no-glib \
      -no-gstreamer \
      -no-reduce-exports \
      -no-ssse3 \
      -no-rpath \
      -system-sqlite \
      -device-option PKG_CONFIG='$(MXE_PKG_CONFIG)' \
      -force-pkg-config  \
      -dbus-linked \
      -v

  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CONFIGURE_CROSS_COMPILE_OPTION := \
      -device-option CROSS_COMPILE=$(MXE_TOOL_PREFIX)
    $(PKG)_CONFIGURE_PLATFORM_OPTION := -xplatform win32-g++-4.6
    $(PKG)_CONFIGURE_DATABASE_OPTION := \
      -qt-sql-sqlite -qt-sql-odbc -qt-sql-psql -qt-sql-tds -D Q_USE_SYBASE 
  endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://qt.gitorious.org/qt/qt/commits' | \
    grep '<li><a href="/qt/qt/commit/' | \
    $(SED) -n 's,.*<a[^>]*>v\([0-9][^<-]*\)<.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    ## syncqt needs QTDIR set to find the sources
    cd '$(1)' && QTDIR='$(1)' ./bin/syncqt
    cd '$(1)' && \
        $($(PKG)_CONFIGURE_ENV) \
        ./$($(PKG)_CONFIGURE_CMD) \
        $($(PKG)_CONFIGURE_INCLUDE_OPTION) \
        $($(PKG)_CONFIGURE_LIBPATH_OPTION) \
        -opensource \
        -confirm-license \
        -fast \
        $($(PKG)_CONFIGURE_PLATFORM_OPTION) \
        $($(PKG)_CONFIGURE_CROSS_COMPILE_OPTION) \
        $($(PKG)_CONFIGURE_EXTRA_OPTION) \
        -release \
        -exceptions \
        -shared \
        -prefix '$(HOST_PREFIX)' \
        -script \
        -no-iconv \
        -opengl desktop \
        -no-webkit \
        -no-phonon \
        -no-phonon-backend \
        -accessibility \
        -nomake demos \
        -nomake docs \
        -nomake examples \
        $($(PKG)_CONFIGURE_DATABASE_OPTION) \
        -system-zlib \
        -system-libpng \
        -system-libjpeg \
        -system-libtiff \
        -system-libmng \
        -no-sse2 

    # need to 'install' mkspecs for the native mingw to build during its build
    if [ "$(MXE_NATIVE_MINGW_BUILD)" = yes ]; then \
      cp -r '$(1)/mkspecs' '$(HOST_PREFIX)/'; \
    fi

    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install

    # native build doesnt seem to succeed with installing pkgconfig files to prefix    
    # in addition, .pc files have the wrong paths, mangled lib names
    if [ "$(MXE_NATIVE_MINGW_BUILD)" = yes ]; then \
       find $(1)/lib/pkgconfig/*.pc -exec $(SED) -i \
         -e 's,\(.*\)_location=.*,\1_location=$(HOST_BINDIR)/\1,g' \
         -e 's,\(Libs:.* -l\).*[\\/]\([A-Za-z0-9]*\),\1\2,g' \
         '{}' ';' ; \
       cp -f '$(1)/lib/pkgconfig/'*.pc '$(HOST_LIBDIR)/pkgconfig/';  \
    fi

    $(LN_SF) '$(HOST_BINDIR)/moc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)moc'
    $(LN_SF) '$(HOST_BINDIR)/rcc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)rcc'
    $(LN_SF) '$(HOST_BINDIR)/uic' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)uic'
    $(LN_SF) '$(HOST_BINDIR)/qmake' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)qmake'

    # cd '$(1)/tools/assistant' && '$(1)/bin/qmake' assistant.pro
    # $(MAKE) -C '$(1)/tools/assistant' -j '$(JOBS)' install

    # cd '$(1)/tools/designer' && '$(1)/bin/qmake' designer.pro
    # $(MAKE) -C '$(1)/tools/designer' -j '$(JOBS)' install

    # # at least some of the qdbus tools are useful on target
    # cd '$(1)/tools/qdbus' && '$(1)/bin/qmake' qdbus.pro
    # $(MAKE) -C '$(1)/tools/qdbus' -j '$(JOBS)' install

    # lrelease (from linguist) needed by octave for GUI build
    $(MAKE) -C '$(1)/tools/linguist/lrelease' -j '$(JOBS)' install
    $(LN_SF) '$(HOST_BINDIR)/lrelease' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)lrelease'

    # mkdir            '$(1)/test-qt'
    # cd               '$(1)/test-qt' && '$(MXE_QMAKE)' '$(PWD)/$(2).pro'
    # $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    # $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(HOST_BINDIR)'
endef
