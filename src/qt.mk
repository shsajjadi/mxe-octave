# This file is part of MXE.
# See index.html for further information.

PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bc352a283610e0cd2fe0dbedbc45613844090fcb
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://releases.qt-project.org/qt4/source/$($(PKG)_FILE)
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_DEPS   := gcc libodbc++ postgresql freetds openssl zlib libpng jpeg libmng tiff sqlite dbus

  $(PKG)_CONFIGURE_ENV := \
    OPENSSL_LIBS="`'$(TARGET)-pkg-config' --libs-only-l openssl`" \
    PSQL_LIBS="-lpq -lsecur32 `'$(TARGET)-pkg-config' --libs-only-l openssl` -lws2_32" \
    SYBASE_LIBS="-lsybdb `'$(TARGET)-pkg-config' --libs-only-l gnutls` -liconv -lws2_32"
else
  $(PKG)_DEPS   := gcc postgresql freetds openssl zlib libpng jpeg libmng tiff sqlite dbus

  $(PKG)_CONFIGURE_ENV := \
    CPPFLAGS='$(HOST_INCDIR)/dbus-1.0' \
    LDFLAGS='-Wl,-rpath-link,$(HOST_LIBDIR) -L$(HOST_LIBDIR)'
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_INCLUDE_OPTION := -I '$(HOST_INCDIR)'
  $(PKG)_CONFIGURE_DATABASE_OPTION := -qt-sql-psql
else
  ifeq ($(MXE_SYSTEM),mingw)
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
    cd '$(1)' && QTDIR='$(1)' ./bin/syncqt
    cd '$(1)' && \
        $($(PKG)_CONFIGURE_ENV) \
        ./configure \
        $($(PKG)_CONFIGURE_INCLUDE_OPTION) \
        -opensource \
        -confirm-license \
        -fast \
        $($(PKG)_CONFIGURE_PLATFORM_OPTION) \
        -device-option CROSS_COMPILE=$(TARGET)- \
        -device-option PKG_CONFIG='$(TARGET)-pkg-config' \
        -force-pkg-config \
        -release \
        -exceptions \
        -shared \
        -prefix '$(HOST_PREFIX)' \
        -prefix-install \
        -script \
        -no-iconv \
        -opengl desktop \
        -no-webkit \
        -no-glib \
        -no-gstreamer \
        -no-phonon \
        -no-phonon-backend \
        -accessibility \
        -no-reduce-exports \
        -no-rpath \
        -make libs \
        -nomake demos \
        -nomake docs \
        -nomake examples \
        $($(PKG)_CONFIGURE_DATABASE_OPTION) \
        -system-zlib \
        -system-libpng \
        -system-libjpeg \
        -system-libtiff \
        -system-libmng \
        -system-sqlite \
        -openssl-linked \
        -dbus-linked \
        -no-sse2 -no-ssse3 \
        -v

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(LN_SF) '$(HOST_BINDIR)/moc' '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-moc'
    $(LN_SF) '$(HOST_BINDIR)/rcc' '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-roc'
    $(LN_SF) '$(HOST_BINDIR)/uic' '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-uic'
    $(LN_SF) '$(HOST_BINDIR)/qmake' '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-qmake'

    # cd '$(1)/tools/assistant' && '$(1)/bin/qmake' assistant.pro
    # $(MAKE) -C '$(1)/tools/assistant' -j '$(JOBS)' install

    # cd '$(1)/tools/designer' && '$(1)/bin/qmake' designer.pro
    # $(MAKE) -C '$(1)/tools/designer' -j '$(JOBS)' install

    # # at least some of the qdbus tools are useful on target
    # cd '$(1)/tools/qdbus' && '$(1)/bin/qmake' qdbus.pro
    # $(MAKE) -C '$(1)/tools/qdbus' -j '$(JOBS)' install

    # lrelease (from linguist) needed by octave for GUI build
    $(MAKE) -C '$(1)/tools/linguist/lrelease' -j '$(JOBS)' install
    $(LN_SF) '$(HOST_BINDIR)/lrelease' '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-lrelease'

    # mkdir            '$(1)/test-qt'
    # cd               '$(1)/test-qt' && '$(TARGET)-qmake' '$(PWD)/$(2).pro'
    # $(MAKE)       -C '$(1)/test-qt' -j '$(JOBS)'
    # $(INSTALL) -m755 '$(1)/test-qt/release/test-qt.exe' '$(HOST_BINDIR)'
endef
