# This file is part of MXE.
# See index.html for further information.

PKG             := qtbase
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.7.1
$(PKG)_CHECKSUM := a3ddcde8978d3a05bb4342fce364a792472a16e6
$(PKG)_SUBDIR   := $(PKG)-opensource-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-opensource-src-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://download.qt.io/official_releases/qt/5.7/$($(PKG)_VERSION)/submodules/$($(PKG)_FILE)
$(PKG)_DEPS     := dbus freetds freetype fontconfig jpeg libpng pcre postgresql sqlite zlib
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
ifeq ($(USE_SYSTEM_OPENGL),no)
  $(PKG)_DEPS += mesa
endif
ifeq ($(MXE_WINDOWS_BUILD),no)
  ifeq ($(USE_SYSTEM_X11_LIBS),no)
    $(PKG)_DEPS += xdamage xdmcp xext xfixes xi xrender xt xxf86vm x11 xcb xcb-util xcb-util-cursor xcb-util-image xcb-util-keysyms xcb-util-renderutil xcb-util-wm
  endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- http://download.qt-project.org/official_releases/qt/5.5/ | \
    $(SED) -n 's,.*href="\(5\.[0-9]\.[^/]*\)/".*,\1,p' | \
    grep -iv -- '-rc' | \
    sort |
    tail -1
endef

$(PKG)_CONFIGURE_CROSS_COMPILE_OPTION :=
$(PKG)_CONFIGURE_DATABASE_OPTION :=
$(PKG)_CONFIGURE_ENV :=
$(PKG)_CONFIGURE_INCLUDE_OPTION :=
$(PKG)_CONFIGURE_LIBPATH_OPTION :=
$(PKG)_CONFIGURE_PLATFORM_OPTION :=
$(PKG)_CONFIGURE_OPTS :=

ifeq ($(MXE_WINDOWS_BUILD),yes)
  ## I haven't been able to change this to be just $(HOST_PREFIX),
  ## though I would prefer to do that.  If it is changed, then
  ## there are a number of other places that will need to be adjusted.
  ## --jwe
  $(PKG)_CONFIGURE_PREFIX_OPTION := -prefix '$(HOST_PREFIX)/qt5'
  $(PKG)_CONFIGURE_OPTS += -no-xcb
else
  $(PKG)_CONFIGURE_PREFIX_OPTION := -prefix '$(HOST_PREFIX)'
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_INCDIR)/freetype2'
  $(PKG)_CONFIGURE_OPTS += -qpa xcb -xcb
endif

## These are needed whether cross compiling or not.
ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_CONFIGURE_ENV := PSQL_LIBS="-lpq -lsecur32 -lws2_32"
  $(PKG)_CONFIGURE_DATABASE_OPTION += \
    -system-sqlite -plugin-sql-sqlite -plugin-sql-odbc -plugin-sql-psql
else
  $(PKG)_CONFIGURE_DATABASE_OPTION += -system-sqlite
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_INCDIR)'
  $(PKG)_CONFIGURE_LIBPATH_OPTION += -L '$(HOST_LIBDIR)'
  ifeq ($(MXE_USE_LIB64_DIRECTORY),yes)
    $(PKG)_CONFIGURE_LIBPATH_OPTION += -L '$(HOST_LIB64DIR)'
  endif
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_INCDIR)/dbus-1.0'
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_LIBDIR)/dbus-1.0/include'
  ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CONFIGURE_PLATFORM_OPTION := -platform win32-g++
  endif
else
  $(PKG)_CONFIGURE_CROSS_COMPILE_OPTION := \
    -device-option CROSS_COMPILE=$(MXE_TOOL_PREFIX)
  ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CONFIGURE_PLATFORM_OPTION := -xplatform win32-g++
  endif
endif

define $(PKG)_BUILD
    # ICU is buggy. See #653. TODO: reenable it some time in the future.
    # Use -qt-doubleconversion until we build our own version.
    # Disable libproxy until we can build our own package.
    cd '$(1)' && \
        $($(PKG)_CONFIGURE_ENV) \
        ./configure \
            $($(PKG)_CONFIGURE_INCLUDE_OPTION) \
            $($(PKG)_CONFIGURE_LIBPATH_OPTION) \
            -no-strip \
            -opensource \
            -c++std c++11 \
            -confirm-license \
            $($(PKG)_CONFIGURE_PLATFORM_OPTION) \
            $($(PKG)_CONFIGURE_CROSS_COMPILE_OPTION) \
            -device-option PKG_CONFIG='$(MXE_PKG_CONFIG)' \
            -force-pkg-config \
            -no-use-gold-linker \
            -shared \
            $($(PKG)_CONFIGURE_PREFIX_OPTION) \
            -hostprefix '$(BUILD_TOOLS_PREFIX)' \
            -no-icu \
            -opengl desktop \
            -no-glib \
            -accessibility \
            -nomake examples \
            -nomake tests \
            $($(PKG)_CONFIGURE_DATABASE_OPTION) \
            -system-zlib \
            -system-libpng \
            -system-libjpeg \
            -system-sqlite \
            -fontconfig \
            -system-freetype \
            -system-pcre \
            -qt-doubleconversion \
            -no-openssl \
            -dbus-linked \
            -no-libproxy \
            -no-pch \
            -v \
            $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    if [ $(MXE_WINDOWS_BUILD) = yes ]; then \
      $(INSTALL) -d '$(HOST_BINDIR)'; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Concurrentd.dll '$(HOST_BINDIR)'/Qt5Concurrentd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Concurrent.dll '$(HOST_BINDIR)'/Qt5Concurrent.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Cored.dll '$(HOST_BINDIR)'/Qt5Cored.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Core.dll '$(HOST_BINDIR)'/Qt5Core.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5DBusd.dll '$(HOST_BINDIR)'/Qt5DBusd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5DBus.dll '$(HOST_BINDIR)'/Qt5DBus.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Guid.dll '$(HOST_BINDIR)'/Qt5Guid.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Gui.dll '$(HOST_BINDIR)'/Qt5Gui.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Networkd.dll '$(HOST_BINDIR)'/Qt5Networkd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Network.dll '$(HOST_BINDIR)'/Qt5Network.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5OpenGLd.dll '$(HOST_BINDIR)'/Qt5OpenGLd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5OpenGL.dll '$(HOST_BINDIR)'/Qt5OpenGL.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5PrintSupportd.dll '$(HOST_BINDIR)'/Qt5PrintSupportd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5PrintSupport.dll '$(HOST_BINDIR)'/Qt5PrintSupport.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Sqld.dll '$(HOST_BINDIR)'/Qt5Sqld.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Sql.dll '$(HOST_BINDIR)'/Qt5Sql.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Testd.dll '$(HOST_BINDIR)'/Qt5Testd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Test.dll '$(HOST_BINDIR)'/Qt5Test.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Widgetsd.dll '$(HOST_BINDIR)'/Qt5Widgetsd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Widgets.dll '$(HOST_BINDIR)'/Qt5Widgets.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Xmld.dll '$(HOST_BINDIR)'/Qt5Xmld.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Xml.dll '$(HOST_BINDIR)'/Qt5Xml.dll; \
    fi

    if [ "$(MXE_NATIVE_BUILD)" = "no" ]; then \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/qmake' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'qmake-qt5; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/moc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'moc; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/uic' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'uic; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/rcc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'rcc; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/lrelease' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'lrelease; \
    fi

endef
