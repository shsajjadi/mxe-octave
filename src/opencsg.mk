# This file is part of MXE.
# See index.html for further information.

PKG             := opencsg
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := e2b4abf169ae3e319eb5f6d9ae6136fa96710a05
$(PKG)_SUBDIR   := OpenCSG-$($(PKG)_VERSION)
$(PKG)_FILE     := OpenCSG-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.opencsg.org/$($(PKG)_FILE)
$(PKG)_DEPS     := freeglut glew qt

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.opencsg.org/#download' | \
    grep 'OpenCSG-' | \
    $(SED) -n 's,.*OpenCSG-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)/src' && '$(MXE_QMAKE)' src.pro
    $(MAKE) -C '$(1)/src' -j '$(JOBS)'
    $(INSTALL) -m644 '$(1)/include/opencsg.h' '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/lib/libopencsg.a' '$(HOST_LIBDIR)'

    cd '$(1)/example' && '$(MXE_QMAKE)' example.pro
    $(MAKE) -C '$(1)/example' -j '$(JOBS)'
    $(INSTALL) -m755 '$(1)/example/release/opencsgexample.exe' '$(HOST_BINDIR)/test-opencsg.exe'
endef
