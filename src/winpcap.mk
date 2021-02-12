# This file is part of MXE.
# See index.html for further information.

PKG             := winpcap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4_1_2
$(PKG)_CHECKSUM := 9155687ab23dbb2348e7cf93caf8a84f51e94795
$(PKG)_SUBDIR   := winpcap
$(PKG)_FILE     := WpcapSrc_$($(PKG)_VERSION).zip
$(PKG)_URL      := http://www.winpcap.org/install/bin/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.winpcap.org/devel.htm' | \
    $(SED) -n 's,.*WpcapSrc_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # build
    cd '$(1)' && $(MXE_CC) -ICommon -IpacketNtx/Dll -O -c '$(1)/packetNtx/Dll/Packet32.c'
    $(MXE_AR) rc '$(1)/libpacket.a' '$(1)/Packet32.o'
    $(MXE_RANLIB) '$(1)/libpacket.a'
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/Common'/*.h '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libpacket.a' '$(HOST_LIBDIR)'

    mv '$(1)/wpcap/libpcap/Win32/Include/ip6_misc.h' '$(1)/file.tmp'
    mv '$(1)/file.tmp' '$(1)/wpcap/libpcap/Win32/Include/IP6_misc.h'

    CC='$(MXE_CC)' \
    AR='$(MXE_AR)' \
    RANLIB='$(MXE_RANLIB)' \
    $(MAKE) -C '$(1)/wpcap/PRJ' -j 1 libwpcap.a
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/wpcap/libpcap/'*.h '$(1)/wpcap/Win32-Extensions/'*.h '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/wpcap/PRJ/libwpcap.a' '$(HOST_LIBDIR)'
endef
