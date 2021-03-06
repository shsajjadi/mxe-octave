# This file is part of MXE.
# See index.html for further information.

PKG             := pdflib_lite
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.0.5p3
$(PKG)_CHECKSUM := 42e0605ae21f4b6d25fa2d20e78fed6df36fbaa9
$(PKG)_SUBDIR   := PDFlib-Lite-$($(PKG)_VERSION)
$(PKG)_FILE     := PDFlib-Lite-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.pdflib.com/binaries/PDFlib/$(subst .,,$(word 1,$(subst p, ,$($(PKG)_VERSION))))/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && aclocal -I config --install
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --without-openssl \
        --without-java \
        --without-py \
        --without-perl \
        --without-ruby \
        --without-tcl \
        --enable-cxx \
        --enable-large-files \
        CFLAGS='-D_IOB_ENTRIES=20'
    $(SED) -i 's,-DPDF_PLATFORM=[^ ]* ,,' '$(1)/config/mkcommon.inc'
    $(MAKE) -C '$(1)/libs' -j '$(JOBS)'
    $(MAKE) -C '$(1)/libs' -j 1 install
endef
