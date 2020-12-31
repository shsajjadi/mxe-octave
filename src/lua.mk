# This file is part of MXE.
# See index.html for further information.

PKG             := lua
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.4.2
$(PKG)_CHECKSUM := 96d4a21393c94bed286b8dc0568f4bdde8730b22
$(PKG)_SUBDIR   := lua-$($(PKG)_VERSION)
$(PKG)_FILE     := lua-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lua.org/ftp/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lua.org/download.html' | \
    $(SED) -n 's,.*lua-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        INSTALL_TOP='$(HOST_PREFIX)' \
        CC='$(MXE_CC)' \
        AR='$(MXE_AR) rcu' \
        RANLIB='$(MXE_RANLIB)' \
        a
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(HOST_PREFIX)' \
        INSTALL_BIN='$(1)/noinstall' \
        INSTALL_MAN='$(1)/noinstall' \
        TO_BIN='lua.h' \
        INSTALL='$(INSTALL)' \
        install

    #'$(MXE_CC)' \
    #    -W -Wall -Werror -ansi -pedantic \
    #    '$(2).c' -o '$(HOST_BINDIR)/test-lua.exe' \
    #    -llua
endef
