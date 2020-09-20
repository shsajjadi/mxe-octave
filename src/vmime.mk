# This file is part of MXE.
# See index.html for further information.

PKG             := vmime
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := fc9bc26
$(PKG)_CHECKSUM := 670aaecfbab41747e3a8f1d80dd757eb01ac93cb
$(PKG)_SUBDIR   := kisli-vmime-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/kisli/vmime/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := libiconv gnutls libgsasl pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/kisli/vmime/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | \
    $(SORT) -Vr | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $(CMAKE_CCACHE_FLAGS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(MXE_AR)' \
        -DCMAKE_RANLIB='$(MXE_RANLIB)' \
        .

    # Disable VMIME_HAVE_MLANG_H
    # We have the header, but there is no implementation for IMultiLanguage in MinGW
    $(SED) -i 's,^#define VMIME_HAVE_MLANG_H 1$$,,' '$(1)/vmime/config.hpp'

    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' install
    $(INSTALL) -m644 '$(1)/vmime/config.hpp' '$(HOST_INCDIR)/vmime/'

    $(SED) -i 's/posix/windows/g;' '$(1)/examples/example6.cpp'
    $(MXE_CXX) -s -o '$(1)/examples/test-vmime.exe' \
        '$(1)/examples/example6.cpp' \
        `'$(MXE_PKG_CONFIG)' libvmime --cflags --libs`
    $(INSTALL) -m755 '$(1)/examples/test-vmime.exe' '$(HOST_BINDIR)'
endef
