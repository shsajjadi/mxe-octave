# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# lapack
PKG             := lapack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.4.0
$(PKG)_CHECKSUM := a141a19bebbef2a20d35a26eb9c120b1de747b38
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_WEBSITE  := http://www.netlib.org/$(PKG)/
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cp $(1)/make.inc.example  $(1)/make.inc
    $(SED) -i 's,PLAT =.*,PLAT = _MINGW32,g'    '$(1)/make.inc'
    $(SED) -i 's,gfortran,$(TARGET)-gfortran,g' '$(1)/make.inc'
    $(SED) -i 's, ar, $(TARGET)-ar,g'           '$(1)/make.inc'
    $(SED) -i 's, ranlib, $(TARGET)-ranlib,g'   '$(1)/make.inc'

    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)'
    $(INSTALL) -d                            '$(PREFIX)/$(TARGET)/lib'
    $(INSTALL) -m644 '$(1)/liblapack.a' '$(PREFIX)/$(TARGET)/lib/liblapack.a'
endef
