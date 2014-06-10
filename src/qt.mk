# This file is part of MXE.
# See index.html for further information.

PKG             := qt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.8.6
$(PKG)_CHECKSUM := ddf9c20ca8309a116e0466c42984238009525da6
$(PKG)_SUBDIR   := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-everywhere-opensource-src-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.qt-project.org/archives/qt/4.8/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := postgresql freetds openssl zlib libpng jpeg libmng tiff sqlite dbus fontconfig

$(PKG)_CONFIGURE_CMD :=
$(PKG)_CONFIGURE_CROSS_COMPILE_OPTION :=
$(PKG)_CONFIGURE_DATABASE_OPTION :=
$(PKG)_CONFIGURE_ENV := PKG_CONFIG_PATH='$(HOST_PREFIX)/lib/pkgconfig'
$(PKG)_CONFIGURE_EXTRA_OPTION :=
$(PKG)_CONFIGURE_INCLUDE_OPTION := -I '$(HOST_INCDIR)/freetype2'
$(PKG)_CONFIGURE_LIBPATH_OPTION :=
$(PKG)_CONFIGURE_PLATFORM_OPTION :=
$(PKG)_PREFIX := $(HOST_PREFIX)
$(PKG)_MKSPECS := $($(PKG)_PREFIX)
$(PKG)_INSTALL_ROOT := $(3)

ifneq ($(filter mingw msvc,$(MXE_SYSTEM)),)
  ifeq ($(MXE_NATIVE_BUILD),yes)
    ifeq ($(MXE_SYSTEM),msvc)
      # NMAKE is perturbed by the values of MAKE and MAKEFLAGS defined by GNU
      # make. These need to be unset even when running configure script, as
      # this will run NMAKE to compile QMAKE.
      $(PKG)_CONFIGURE_ENV += MAKE= MAKEFLAGS=
    else
      # native mingw doesnt like using install root mixed with prefix
      # and instead attempts to install to c:\INSTALL_ROOT\prefix
      # so dont use it if compiling native mingw
      $(PKG)_INSTALL_ROOT :=
    endif
  else
    $(PKG)_CONFIGURE_ENV := \
      OPENSSL_LIBS="`'$(MXE_PKG_CONFIG)' --libs-only-l openssl`" \
      PSQL_LIBS="-lpq -lsecur32 `'$(MXE_PKG_CONFIG)' --libs-only-l openssl` -lws2_32" \
      SYBASE_LIBS="-lsybdb `'$(MXE_PKG_CONFIG)' --libs-only-l gnutls` -liconv -lws2_32" 
    $(PKG)_CONFIGURE_DATABASE_OPTION += -system-sqlite
  endif
  # compile-in generic ODBC driver under Windows
  $(PKG)_CONFIGURE_DATABASE_OPTION += -plugin-sql-odbc
else
  $(PKG)_CONFIGURE_ENV += \
    LDFLAGS='-Wl,-rpath-link,$(HOST_LIBDIR) -L$(HOST_LIBDIR)'
  $(PKG)_CONFIGURE_DATABASE_OPTION += -system-sqlite
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_INCDIR)'
  $(PKG)_CONFIGURE_LIBPATH_OPTION += -L '$(HOST_LIBDIR)'
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_INCDIR)/dbus-1.0'
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_LIBDIR)/dbus-1.0/include'
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
      -no-rpath \
      -make translations \
      -translationdir '$($(PKG)_PREFIX)/translations' \
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
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
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
        -system-libmng 

    if test x$(MXE_SYSTEM) = xmsvc; then \
        for f in $(1)/mkspecs/win32-msvc*/qmake.conf; do \
            sed -i -e 's/@@LIBRARY_PREFIX@@/$(LIBRARY_PREFIX)/g' \
                   -e 's/@@LIBRARY_SUFFIX@@/$(LIBRARY_SUFFIX)/g' $$f; \
        done; \
    fi

    # need to 'install' mkspecs for the native mingw to build during its build
    # also need build tools qmake 
    if [ "$(MXE_NATIVE_MINGW_BUILD)" = yes ]; then \
      mkdir -p '$($(PKG)_MKSPECS)'; \
      cp -r '$(1)/mkspecs' '$($(PKG)_MKSPECS)'; \
      $(INSTALL) -m755 '$(1)/bin/qmake.exe' '$($(PKG)_INSTALL_ROOT)$(BUILD_TOOLS_PREFIX)/bin/'; \
    fi

    # compilation under MSVC requires the use of NMAKE, which does not
    # support the -j option flag and is perturbed by GNU make values for
    # MAKE and MAKEFLAGS; also remove unnecessary DLL installed in lib/
    if test x$(MXE_SYSTEM) = xmsvc; then \
      mkdir -p '$(3)' && \
      cd '$(1)' && \
      env -u MAKE -u MAKEFLAGS PKG_CONFIG_PATH='$(HOST_PREFIX)/lib/pkgconfig' nmake && \
      env -u MAKE -u MAKEFLAGS PKG_CONFIG_PATH='$(HOST_PREFIX)/lib/pkgconfig' nmake \
          INSTALL_ROOT=`cd $(3) && pwd -W | sed -e 's,^[a-zA-Z]:,,' -e 's,/,\\\\,g'` install && \
      rm -f $(3)$(CMAKE_HOST_PREFIX)/lib/$(LIBRARY_PREFIX)Qt*.dll; \
    else \
      make -C '$(1)' -j '$(JOBS)'; \
      make -C '$(1)' -j 1 install INSTALL_ROOT=$($(PKG)_INSTALL_ROOT); \
      if [ "$(MXE_SYSTEM)" = mingw ]; then \
        rm -f $($(PKG)_INSTALL_ROOT)$(HOST_LIBDIR)/$(LIBRARY_PREFIX)Qt*$(LIBRARY_SUFFIX).dll; \
      fi \
    fi

    # native build doesn't seem to succeed when installing pkgconfig files to prefix    
    # in addition, .pc files have the wrong paths, mangled lib names
    if [ "$(MXE_NATIVE_MINGW_BUILD)" = yes -a "$(MXE_SYSTEM)" != msvc ]; then \
       find $(1)/lib/pkgconfig/*.pc -exec $(SED) -i \
         -e 's,\(.*\)_location=.*,\1_location=$${prefix}/bin/\1,g' \
         -e 's,\(Libs:.* -l\).*[\\/]\([A-Za-z0-9]*\),\1\2,g' \
         '{}' ';' ; \
       $(INSTALL) -d '$($(PKG)_INSTALL_ROOT)$(HOST_LIBDIR)/pkgconfig'; \
       cp -f '$(1)/lib/pkgconfig/'*.pc '$($(PKG)_INSTALL_ROOT)$(HOST_LIBDIR)/pkgconfig/';  \
    fi

    $(if $(filter-out msvc, $(MXE_SYSTEM)),
      $(if $(filter-out yes, $(MXE_NATIVE_BUILD)),
        $(INSTALL) -d '$($(PKG)_INSTALL_ROOT)$(BUILD_TOOLS_PREFIX)/bin'
        $(INSTALL) -m755 '$($(PKG)_INSTALL_ROOT)$($(PKG)_PREFIX)/bin/moc' '$($(PKG)_INSTALL_ROOT)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)moc'
        $(INSTALL) -m755 '$($(PKG)_INSTALL_ROOT)$($(PKG)_PREFIX)/bin/rcc' '$($(PKG)_INSTALL_ROOT)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)rcc'
        $(INSTALL) -m755 '$($(PKG)_INSTALL_ROOT)$($(PKG)_PREFIX)/bin/uic' '$($(PKG)_INSTALL_ROOT)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)uic'
        $(INSTALL) -m755 '$($(PKG)_INSTALL_ROOT)$($(PKG)_PREFIX)/bin/qmake' '$($(PKG)_INSTALL_ROOT)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)qmake'
      )

      # lrelease (from linguist) needed by octave for GUI build
      $(MAKE) -C '$(1)/tools/linguist/lrelease' -j '$(JOBS)' 
      $(MAKE) -C '$(1)/tools/linguist/lrelease' -j 1 install INSTALL_ROOT='$($(PKG)_INSTALL_ROOT)'
      $(if $(filter-out yes, $(MXE_NATIVE_BUILD)),
        $(INSTALL) -m755 '$($(PKG)_INSTALL_ROOT)$($(PKG)_PREFIX)/bin/lrelease' '$($(PKG)_INSTALL_ROOT)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)lrelease'))

endef
