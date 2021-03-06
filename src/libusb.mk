# This file is part of MXE.
# See index.html for further information.

PKG             := libusb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.6.0
$(PKG)_CHECKSUM := 6b90d083e4aee2fa0edbf18dec79d40afe9ded7d
$(PKG)_SUBDIR   := $(PKG)-win32-src-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-win32-src-$($(PKG)_VERSION).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)-win32/$(PKG)-win32-releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libusb-win32/files/libusb-win32-releases/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # convert DOS line endings
    $(SED) -i 's,\r$$,,' '$(1)/Makefile'

    # don't actually build the library (DLL file),
    # just create the DLL import stubs
    $(MAKE) -C '$(1)' -j '$(JOBS)' host_prefix=$(TARGET) libusbd.a
    cd '$(1)' && $(MXE_DLLTOOL) \
        --dllname libusb0.dll \
        --kill-at \
        --add-stdcall-underscore \
        --def libusb0.def \
        --output-lib libusb.a

    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/src/lusb0_usb.h' '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libusb.a'  '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libusbd.a' '$(HOST_LIBDIR)'
endef
