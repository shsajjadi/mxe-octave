# This file is part of MXE.
# See index.html for further information.

PKG             := log4cxx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.10.0
$(PKG)_CHECKSUM := d79c053e8ac90f66c5e873b712bb359fd42b648d
$(PKG)_SUBDIR   := apache-log4cxx-$($(PKG)_VERSION)
$(PKG)_FILE     := apache-log4cxx-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://apache.naggo.co.kr/logging/log4cxx/0.10.0/$($(PKG)_FILE)
$(PKG)_URL_2    := http://apache.mirror.cdnetworks.com//logging/log4cxx/0.10.0/$($(PKG)_FILE)
$(PKG)_DEPS     := apr-util

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://logging.apache.org/log4cxx/download.html' | \
    $(SED) -n 's,.*log4cxx-\([0-9.]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --with-apr='$(HOST_PREFIX)' \
        --with-apr-util='$(HOST_PREFIX)' \
        CFLAGS=-D_WIN32_WINNT=0x0500 \
        CXXFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
    mkdir -p '$(HOST_PREFIX)/share/cmake/log4cxx'
    cp '$(1)/log4cxx-config.cmake' '$(HOST_PREFIX)/share/cmake/log4cxx/log4cxx-config.cmake'

    '$(MXE_CXX)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-log4cxx.exe' \
        `$(MXE_PKG_CONFIG) liblog4cxx --libs`
endef
