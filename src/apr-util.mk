# This file is part of MXE.
# See index.html for further information.

PKG             := apr-util
$(PKG)_IGNORE   := 1.4.1
$(PKG)_VERSION  := 1.3.10
$(PKG)_CHECKSUM := f5aaf15542209fee479679299dc4cb1ac0924a59
$(PKG)_SUBDIR   := apr-util-$($(PKG)_VERSION)
$(PKG)_FILE     := apr-util-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://mirror.apache-kr.org/apr/$($(PKG)_FILE)
$(PKG)_URL_2    := http://archive.apache.org/dist/apr/$($(PKG)_FILE)
$(PKG)_DEPS     := apr expat libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://apr.apache.org/download.cgi' | \
    grep 'aprutil1.*best' |
    $(SED) -n 's,.*APR-util \([0-9.]*\).*,\1,p'
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --without-pgsql \
        --without-sqlite2 \
        --without-sqlite3 \
        --with-apr='$(HOST_PREFIX)' \
        CFLAGS=-D_WIN32_WINNT=0x0500
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS=
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -m755 '$(HOST_BINDIR)/apu-1-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)apu-1-config'; \
    fi
endef
