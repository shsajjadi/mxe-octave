# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# VMime
PKG             := vmime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.9.0
$(PKG)_CHECKSUM := 02215e1d8ea758f486c32e7bff63a04f71a9b736
$(PKG)_SUBDIR   := libvmime-$($(PKG)_VERSION)
$(PKG)_FILE     := libvmime-$($(PKG)_VERSION).tar.bz2
$(PKG)_WEBSITE  := http://vmime.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/vmime/vmime/0.9/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc libiconv gnutls libgsasl pthreads zlib

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/vmime/files/) | \
    $(SED) -n 's,.*vmime-\([0-9][^>]*\)\.tar\.bz2.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    # The configure script will make the real configuration, but
    # we need scons to generate configure.in, Makefile.am etc.
    # ansi and pedantic are too strict for mingw.
    # http://sourceforge.net/tracker/index.php?func=detail&aid=2373234&group_id=2435&atid=102435
    $(SED) -i "s/'-ansi', //;"                        '$(1)/SConstruct'
    $(SED) -i "s/'-pedantic', //;"                    '$(1)/SConstruct'
    $(SED) -i 's/pkg-config/$(TARGET)-pkg-config/g;'  '$(1)/SConstruct'

    cd '$(1)' && scons autotools \
         prefix='$(PREFIX)/$(TARGET)' \
         target='$(TARGET)' \
         sendmail_path=/sbin/sendmail

    cd '$(1)' && ./bootstrap
    cd '$(1)' && ./configure \
        --prefix='$(PREFIX)/$(TARGET)' \
        --host='$(TARGET)' \
        --disable-shared \
        --enable-platform-windows \
        --disable-rpath \
        --disable-dependency-tracking

    # Disable VMIME_HAVE_MLANG_H
    # We have the header, but there is no implementation for IMultiLanguage in MinGW
    $(SED) -i 's,^#define VMIME_HAVE_MLANG_H 1$$,,' '$(1)/vmime/config.hpp'

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' install

    $(SED) -i 's/posix/windows/g;' '$(1)/examples/example6.cpp'
    i686-pc-mingw32-g++ -s -o '$(1)/examples/test-vmime.exe' \
        -I'$(PREFIX)/$(TARGET)/include' \
        '$(1)/examples/example6.cpp' \
        -L'$(PREFIX)/$(TARGET)/lib' \
        -lvmime -lgnutls -lgsasl -lntlm -lgcrypt -lgpg-error -liconv -lidn -lz -lpthread -lws2_32
    $(INSTALL) -m755 '$(1)/examples/test-vmime.exe' '$(PREFIX)/$(TARGET)/bin/'
endef
