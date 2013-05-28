# This file is part of MXE.
# See index.html for further information.

PKG             := lapack
$(PKG)_CHECKSUM := 93a6e4e6639aaf00571d53a580ddc415416e868b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.netlib.org/lapack/' | \
    $(SED) -n 's_.*>LAPACK, version \([0-9]\.[0-9]\.[0-9]\).*_\1_ip' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DCMAKE_AR='$(MXE_AR)' \
        -DCMAKE_RANLIB='$(MXE_RANLIB)' \
        .
    $(MAKE) -C '$(1)/SRC' -j '$(JOBS)' install
endef
