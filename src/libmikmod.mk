# This file is part of MXE.
# See index.html for further information.

PKG             := libmikmod
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.0-beta2
$(PKG)_CHECKSUM := f16fc09ee643af295a8642f578bda97a81aaf744
$(PKG)_SUBDIR   := libmikmod-$($(PKG)_VERSION)
$(PKG)_FILE     := libmikmod-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://mikmod.raphnet.net/files/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://mikmod.raphnet.net/' | \
    $(SED) -n 's,.*libmikmod-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,-Dunix,,' '$(1)/libmikmod/Makefile.in'
    $(SED) -i 's,`uname`,MinGW,g' '$(1)/configure'
    cd '$(1)' && \
        CC='$(MXE_CC)' \
        NM='$(MXE_NM)' \
        RANLIB='$(MXE_RANLIB)' \
        STRIP='$(MXE_STRIP)' \
        ./configure \
            $(ENABLE_SHARED_OR_STATIC) \
            --prefix='$(HOST_PREFIX)' \
            --libdir='$(HOST_LIBDIR)' \
            --disable-esd
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    '$(MXE_CC)' \
        -W -Wall -Werror -std=c99 -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-libmikmod.exe' \
        `'$(HOST_BINDIR)/libmikmod-config' --cflags --libs`
endef
