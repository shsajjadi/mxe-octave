# This file is part of MXE.
# See index.html for further information.

PKG             := mxml
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7
$(PKG)_CHECKSUM := a3bdcab48307794c297e790435bcce7becb9edae
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.easysw.com/pub/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads
    $(MAKE) -C '$(1)' -j '$(JOBS)' libmxml.a
    $(MAKE) -C '$(1)' -j 1 install-libmxml.a
    $(INSTALL) -d                   '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/mxml.h'  '$(HOST_INCDIR)'
    $(INSTALL) -d                   '$(HOST_LIBDIR)/pkgconfig'
    $(INSTALL) -m644 '$(1)/mxml.pc' '$(HOST_LIBDIR)/pkgconfig'

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-mxml.exe' \
        `'$(MXE_PKG_CONFIG)' mxml --cflags --libs`
endef
