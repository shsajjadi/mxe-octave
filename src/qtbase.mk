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

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_CONFIGURE_PREFIX_OPTION := -prefix '$(HOST_PREFIX)/qt5'
else
  $(PKG)_CONFIGURE_PREFIX_OPTION := -prefix '$(HOST_PREFIX)'
  $(PKG)_CONFIGURE_INCLUDE_OPTION += -I '$(HOST_INCDIR)/freetype2'
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
    cd '$(1)' && \
        $($(PKG)_CONFIGURE_ENV) \
        ./configure \
            $($(PKG)_CONFIGURE_INCLUDE_OPTION) \
            $($(PKG)_CONFIGURE_LIBPATH_OPTION) \
            -opensource \
            -c++std c++11 \
            -confirm-license \
            $($(PKG)_CONFIGURE_PLATFORM_OPTION) \
            $($(PKG)_CONFIGURE_CROSS_COMPILE_OPTION) \
            -device-option PKG_CONFIG='$(MXE_PKG_CONFIG)' \
            -force-pkg-config \
            -no-use-gold-linker \
            -release \
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
            -no-openssl \
            -dbus-linked \
	    -no-pch \
            -no-xcb \
            -v \
            $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    if [ "$(MXE_NATIVE_BUILD)" = "no" ]; then \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/qmake' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'qmake-qt5; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/moc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'moc; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/uic' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'uic; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/rcc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'rcc; \
        ln -sf '$(BUILD_TOOLS_PREFIX)/bin/lrelease' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'lrelease; \
    fi

endef

