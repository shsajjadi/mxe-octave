# This file is part of MXE.
# See index.html for further information.

PKG             := libssh2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.0
$(PKG)_CHECKSUM := 21e98282b103307a16792e5e2d4c99beaf0b3b9c
$(PKG)_SUBDIR   := libssh2-$($(PKG)_VERSION)
$(PKG)_FILE     := libssh2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.libssh2.org/download/$($(PKG)_FILE)
$(PKG)_DEPS     := libgcrypt zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.libssh2.org/download/?C=M;O=D' | \
    grep 'libssh2-' | \
    $(SED) -n 's,.*libssh2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./buildconf
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-examples-build \
        --without-openssl \
        --with-libgcrypt \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'

##    '$(MXE_CC)' \
##        -W -Wall -Werror -ansi -pedantic \
##        '$(2).c' -o '$(HOST_BINDIR)/test-libssh2.exe' \
##        `'$(MXE_PKG_CONFIG)' --cflags --libs libssh2`

endef
