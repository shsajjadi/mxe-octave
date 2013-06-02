# This file is part of MXE.
# See index.html for further information.

PKG             := lua
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 6bb1b0a39b6a5484b71a83323c690154f86b2021
$(PKG)_SUBDIR   := lua-$($(PKG)_VERSION)
$(PKG)_FILE     := lua-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.lua.org/ftp/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.lua.org/download.html' | \
    $(SED) -n 's,.*lua-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' \
        INSTALL_TOP='$(HOST_PREFIX)' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar rcu' \
        RANLIB='$(TARGET)-ranlib' \
        a
    $(MAKE) -C '$(1)' -j 1 \
        INSTALL_TOP='$(HOST_PREFIX)' \
        INSTALL_BIN='$(1)/noinstall' \
        INSTALL_MAN='$(1)/noinstall' \
        TO_BIN='lua.h' \
        INSTALL='$(INSTALL)' \
        install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-lua.exe' \
        -llua
endef
