# This file is part of MXE.
# See index.html for further information.

PKG             := winpcap
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 9155687ab23dbb2348e7cf93caf8a84f51e94795
$(PKG)_SUBDIR   := winpcap
$(PKG)_FILE     := WpcapSrc_$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.winpcap.org/install/bin/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.winpcap.org/devel.htm' | \
    $(SED) -n 's,.*WpcapSrc_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build
    cd '$(1)' && $(TARGET)-gcc -ICommon -IpacketNtx/Dll -O -c '$(1)/packetNtx/Dll/Packet32.c'
    $(TARGET)-ar rc '$(1)/libpacket.a' '$(1)/Packet32.o'
    $(TARGET)-ranlib '$(1)/libpacket.a'
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/Common'/*.h '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libpacket.a' '$(HOST_LIBDIR)'

    mv '$(1)/wpcap/libpcap/Win32/Include/ip6_misc.h' '$(1)/file.tmp'
    mv '$(1)/file.tmp' '$(1)/wpcap/libpcap/Win32/Include/IP6_misc.h'

    CC='$(TARGET)-gcc' \
    AR='$(TARGET)-ar' \
    RANLIB='$(TARGET)-ranlib' \
    $(MAKE) -C '$(1)/wpcap/PRJ' -j 1 libwpcap.a
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/wpcap/libpcap/'*.h '$(1)/wpcap/Win32-Extensions/'*.h '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/wpcap/PRJ/libwpcap.a' '$(HOST_LIBDIR)'
endef
