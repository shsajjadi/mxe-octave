# This file is part of MXE.
# See index.html for further information.

PKG             := xerces
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.1.1
$(PKG)_CHECKSUM := 177ec838c5119df57ec77eddec9a29f7e754c8b2
$(PKG)_SUBDIR   := xerces-c-$($(PKG)_VERSION)
$(PKG)_FILE     := xerces-c-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://apache.linux-mirror.org/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_URL_2    := http://www.apache.org/dist/xerces/c/$(word 1,$(subst ., ,$($(PKG)_VERSION)))/sources/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv curl

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.apache.org/dist/xerces/c/3/sources/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="xerces-c-\([0-9][^"]*\)\.tar.*,\1,p' | \
    grep -v rc | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CONFIG_SHELL='$(SHELL)' ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-sse2 \
        --prefix='$(HOST_PREFIX)' \
        --enable-libtool-lock \
        --disable-pretty-make \
        --disable-threads \
        --enable-network \
        --enable-netaccessor-curl \
        --disable-netaccessor-socket \
        --disable-netaccessor-cfurl \
        --disable-netaccessor-winsock \
        --enable-transcoder-iconv \
        --disable-transcoder-gnuiconv \
        --disable-transcoder-icu \
        --disable-transcoder-macosunicodeconverter \
        --disable-transcoder-windows \
        --enable-msgloader-inmemory \
        --disable-msgloader-iconv \
        --disable-msgloader-icu \
        --with-curl='$(HOST_PREFIX)' \
        --without-icu \
        LIBS="`$(MXE_PKG_CONFIG) --libs libcurl`"
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CXX)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).cpp' -o '$(HOST_BINDIR)/test-xerces.exe' \
        `'$(MXE_PKG_CONFIG)' xerces-c --cflags --libs`
endef
