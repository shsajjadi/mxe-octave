# This file is part of MXE.
# See index.html for further information.

PKG             := qtbase
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.7.0
$(PKG)_CHECKSUM := ba835ff158932eebbf1ed9f678414923dfd7cce4
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

define $(PKG)_BUILD
    # ICU is buggy. See #653. TODO: reenable it some time in the future.
    cd '$(1)' && \
        PSQL_LIBS="-lpq -lsecur32 -lws2_32" \
        ./configure \
            -opensource \
            -c++std c++11 \
            -confirm-license \
            -xplatform win32-g++ \
            -device-option CROSS_COMPILE=$(MXE_TOOL_PREFIX) \
            -device-option PKG_CONFIG='$(MXE_PKG_CONFIG)' \
            -force-pkg-config \
            -no-use-gold-linker \
            -release \
            -shared \
            -prefix '$(HOST_PREFIX)/qt5' \
            -hostprefix '$(BUILD_TOOLS_PREFIX)' \
            -no-icu \
            -opengl desktop \
            -no-glib \
            -accessibility \
            -nomake examples \
            -nomake tests \
            -plugin-sql-sqlite \
            -plugin-sql-odbc \
            -plugin-sql-psql \
            -system-zlib \
            -system-libpng \
            -system-libjpeg \
            -system-sqlite \
            -fontconfig \
            -system-freetype \
            -system-pcre \
            -no-openssl \
            -dbus-linked \
            -v \
            $($(PKG)_CONFIGURE_OPTS)

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    rm -rf '$(HOST_PREFIX)/qt5'
    $(MAKE) -C '$(1)' -j 1 install

# remove this
    if [ "$(MXE_NATIVE_BUILD)" = "xxno" ]; then \
        for f in moc qdbuscpp2xml qdbusxml2cpp qlalr qmake rcc uic; do \
          mv "$(HOST_PREFIX)/qt5/bin/$$f" "$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)$$f-qt5"; \
        done; \
    fi
 
    #ln -sf '$(HOST_PREFIX)/qt5/bin/qmake' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'qmake-qt5
    ln -sf '$(BUILD_TOOLS_PREFIX)/bin/qmake' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'qmake-qt5
    ln -sf '$(BUILD_TOOLS_PREFIX)/bin/moc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'moc
    ln -sf '$(BUILD_TOOLS_PREFIX)/bin/uic' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'uic
    ln -sf '$(BUILD_TOOLS_PREFIX)/bin/rcc' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'rcc
    ln -sf '$(BUILD_TOOLS_PREFIX)/bin/lrelease' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)'lrelease

    # setup cmake toolchain
    #echo 'set(CMAKE_SYSTEM_PREFIX_PATH "$(PREFIX)/$(TARGET)/qt5" ${CMAKE_SYSTEM_PREFIX_PATH})' > '$(CMAKE_TOOLCHAIN_DIR)/$(PKG).cmake'

endef

