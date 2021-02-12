# This file is part of MXE.
# See index.html for further information.

PKG             := dcmtk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.6.0
$(PKG)_CHECKSUM := 469e017cffc56f36e834aa19c8612111f964f757
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://dicom.offis.de/pub/dicom/offis/software/$(PKG)/$(PKG)$(subst .,,$($(PKG)_VERSION))/$($(PKG)_FILE)
$(PKG)_URL_2    := http://ftp.debian.org/debian/pool/main/d/$(PKG)/$(PKG)_$($(PKG)_VERSION).orig.tar.gz
#$(PKG)_DEPS     := openssl tiff libpng libxml2 zlib
$(PKG)_DEPS     := tiff libpng libxml2 zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://dicom.offis.de/dcmtk.php.en' | \
    $(SED) -n 's,.*/dcmtk-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)'/config && autoconf -f
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --with-openssl \
        --with-libtiff \
        --with-libpng \
        --with-libxml \
        --with-libxmlinc='$(HOST_PREFIX)' \
        --with-zlib \
        --without-libwrap \
	--without-openssl \
        CXX='$(MXE_CXX)' \
        RANLIB='$(MXE_RANLIB)' \
        AR='$(MXE_AR)' \
        ARFLAGS=cru \
        LIBTOOL=$(LIBTOOL) \
        ac_cv_my_c_rightshift_unsigned=no
    $(MAKE) -C '$(1)' -j '$(JOBS)' install-lib
endef
