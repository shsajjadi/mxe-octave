# This file is part of MXE.
# See index.html for further information.

PKG             := libcdio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.92
$(PKG)_CHECKSUM := 37f0b746181c9a3c2ff14e21147885addf357b5f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.gnu.org/gnu/libcdio/$(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'TODO: Updates for package libcdio need to be written.' >&2;
    echo $(libcdio_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) 
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' -j 1 install
endef
