# This file is part of MXE.
# See index.html for further information.

PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := bc352a283610e0cd2fe0dbedbc45613844090fcb
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.qt-project.org/archives/qt/4.8/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := openssl zlib libpng jpeg libmng tiff dbus

$(PKG)_CONFIGURE_CMD :=
$(PKG)_CONFIGURE_CROSS_COMPILE_OPTION :=
$(PKG)_CONFIGURE_DATABASE_OPTION :=
$(PKG)_CONFIGURE_ENV := PKG_CONFIG_PATH='$(HOST_PREFIX)/lib/pkgconfig'
$(PKG)_CONFIGURE_EXTRA_OPTION :=
$(PKG)_CONFIGURE_INCLUDE_OPTION :=
$(PKG)_CONFIGURE_LIBPATH_OPTION :=
$(PKG)_CONFIGURE_PLATFORM_OPTION :=
$(PKG)_PREFIX := '$(HOST_PREFIX)'
$(PKG)_MKSPECS := '$($(PKG)_PREFIX)'

ifneq ($(filter mingw msvc,$(MXE_SYSTEM)),)
  ifeq ($(MXE_NATIVE_BUILD),yes)
    ifeq ($(MXE_SYSTEM),msvc)
      # NMAKE is perturbed by the values of MAKE and MAKEFLAGS defined by GNU
      # make. These need to be unset even when running configure script, as
      # this will run NMAKE to compile QMAKE.
      $(PKG)_CONFIGURE_ENV += MAKE= MAKEFLAGS=
    endif
  else
    $(PKG)_CONFIGURE_ENV := \
      OPENSSL_LIBS="`'$(MXE_PKG_CONFIG)' --libs-only-l openssl`" \
      PSQL_LIBS="-lpq -lsecur32 `'$(MXE_PKG_CONFIG)' --libs-only-l openssl` -lws2_32" \
      SYBASE_LIBS="-lsybdb `'$(MXE_PKG_CONFIG)' --libs-only-l gnutls` -liconv -lws2_32"
  endif
  # compile-in generic ODBC driver under Windows
  $(PKG)_CONFIGURE_DATABASE_OPTION += -plugin-sql-odbc
else
  $(PKG)_CONFIGURE_ENV += \
    LDFLAGS='-Wl,-rpath-link,$(HOST_LIBDIR) -L$(HOST_LIBDIR)'
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_INCDIR)'
  $(PKG)_CONFIGURE_LIBPATH_OPTION += -L '$(HOST_LIBDIR)'
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_CONFIGURE_CMD := configure.exe
  ifeq ($(MXE_SYSTEM),msvc)
    # FIXME: the "2010" suffix should be computed dynamically
    $(PKG)_CONFIGURE_PLATFORM_OPTION := -platform win32-msvc2010
    # mimic typical Linux installation
    $(PKG)_CONFIGURE_EXTRA_OPTION += \
      -docdir '$(HOST_LIBDIR)/qt4/doc' \
      -plugindir '$(HOST_LIBDIR)/qt4/plugins' \
      -importdir '$(HOST_LIBDIR)/qt4/imports' \
      -datadir '$(HOST_LIBDIR)/qt4' \
      -translationdir '$(HOST_LIBDIR)/qt4/translations' \
      -examplesdir '$(HOST_LIBDIR)/qt4/examples' \
      -demosdir '$(HOST_LIBDIR)/qt4/demos'
    $(PKG)_MKSPECS := '$(HOST_LIBDIR)/qt4'
  else
    $(PKG)_CONFIGURE_PLATFORM_OPTION := -platform win32-g++
  endif
  # OPENSSL_LIBS needs to be specified here, specifying it as environment
  # variables *before* "configure.exe" doesn't work. Also compile-in D-BUS
  # support, for what it's worth...
  $(PKG)_CONFIGURE_EXTRA_OPTION += \
      OPENSSL_LIBS="`PKG_CONFIG_PATH='$(HOST_PREFIX)/lib/pkgconfig' '$(MXE_PKG_CONFIG)' --libs-only-l openssl`"
else
  $(PKG)_CONFIGURE_CMD := configure
  $(PKG)_CONFIGURE_EXTRA_OPTION := \
      -prefix-install \
      -make libs \
      -no-glib \
      -no-gstreamer \
      -no-reduce-exports \
      -no-ssse3 \
      -no-rpath \
      -device-option PKG_CONFIG='$(MXE_PKG_CONFIG)' \
      -force-pkg-config  \
      -v

  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CONFIGURE_CROSS_COMPILE_OPTION := \
      -device-option CROSS_COMPILE=$(MXE_TOOL_PREFIX)
    $(PKG)_CONFIGURE_PLATFORM_OPTION := -xplatform win32-g++-4.6
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
    cd '$(1)' && QTDIR='$(1)' \
        $($(PKG)_CONFIGURE_ENV) \
        ./$($(PKG)_CONFIGURE_CMD) \
        $($(PKG)_CONFIGURE_INCLUDE_OPTION) \
        $($(PKG)_CONFIGURE_LIBPATH_OPTION) \
        -opensource \
        -confirm-license \
        -dbus-linked \
        -fast \
        $($(PKG)_CONFIGURE_PLATFORM_OPTION) \
        $($(PKG)_CONFIGURE_CROSS_COMPILE_OPTION) \
        $($(PKG)_CONFIGURE_EXTRA_OPTION) \
        -release \
        -exceptions \
        -shared \
        -prefix $($(PKG)_PREFIX) \
        -script \
        -no-iconv \
        -opengl desktop \
        -openssl-linked \
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

    if test x$(MXE_SYSTEM) = xmsvc; then \
        for f in $(1)/mkspecs/win32-msvc*/qmake.conf; do \
            sed -i -e 's/@@LIBRARY_PREFIX@@/$(LIBRARY_PREFIX)/g' \
                   -e 's/@@LIBRARY_SUFFIX@@/$(LIBRARY_SUFFIX)/g' $$f; \
        done; \
    fi

    # need to 'install' mkspecs for the native mingw to build during its build
    if [ "$(MXE_NATIVE_MINGW_BUILD)" = yes ]; then \
      mkdir -p '$($(PKG)_MKSPECS)'; \
      cp -r '$(1)/mkspecs' '$($(PKG)_MKSPECS)'; \
    fi

    # compilation under MSVC requires the use of NMAKE, which does not
    # support the -j option flag and is perturbed by GNU make values for
    # MAKE and MAKEFLAGS; also remove unnecessary DLL installed in lib/
    if test x$(MXE_SYSTEM) = xmsvc; then \
      cd '$(1)' && \
      env -u MAKE -u MAKEFLAGS PKG_CONFIG_PATH='$(HOST_PREFIX)/lib/pkgconfig' nmake && \
      env -u MAKE -u MAKEFLAGS PKG_CONFIG_PATH='$(HOST_PREFIX)/lib/pkgconfig' nmake install && \
      rm -f $(HOST_PREFIX)/lib/$(LIBRARY_PREFIX)Qt*.dll; \
    else \
      make -C '$(1)' -j '$(JOBS)' && \
      make -C '$(1)' -j 1 install; \
    fi

    # native build doesnt seem to succeed with installing pkgconfig files to prefix    
    # in addition, .pc files have the wrong paths, mangled lib names
    if [ "$(MXE_NATIVE_MINGW_BUILD)" = yes -a "$(MXE_SYSTEM)" != msvc ]; then \
       find $(1)/lib/pkgconfig/*.pc -exec $(SED) -i \
         -e 's,\(.*\)_location=.*,\1_location=$${prefix}/bin/\1,g' \
         -e 's,\(Libs:.* -l\).*[\\/]\([A-Za-z0-9]*\),\1\2,g' \
         '{}' ';' ; \
       cp -f '$(1)/lib/pkgconfig/'*.pc '$(HOST_LIBDIR)/pkgconfig/';  \
    fi

    $(if $(filter-out msvc, $(MXE_SYSTEM)),
      $(if $(filter-out yes, $(MXE_NATIVE_BUILD)),
        $(INSTALL) -m755 '$($(PKG)_PREFIX)/bin/moc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)moc'
        $(INSTALL) -m755 '$($(PKG)_PREFIX)/bin/rcc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)rcc'
        $(INSTALL) -m755 '$($(PKG)_PREFIX)/bin/uic' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)uic'
        $(INSTALL) -m755 '$($(PKG)_PREFIX)/bin/qmake' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)qmake'
      )

      # lrelease (from linguist) needed by octave for GUI build
      $(MAKE) -C '$(1)/tools/linguist/lrelease' -j '$(JOBS)' install
      $(if $(filter-out yes, $(MXE_NATIVE_BUILD)),
        $(INSTALL) -m755 '$($(PKG)_PREFIX)/bin/lrelease' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)lrelease'))
endef
