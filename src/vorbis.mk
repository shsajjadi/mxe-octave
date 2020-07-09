# This file is part of MXE.
# See index.html for further information.

PKG             := vorbis
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.7
$(PKG)_CHECKSUM := 2b415495f89b103138a23da5017a2a00837c6c94
$(PKG)_SUBDIR   := libvorbis-$($(PKG)_VERSION)
$(PKG)_FILE     := libvorbis-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xiph.org/releases/vorbis/$($(PKG)_FILE)
$(PKG)_DEPS     := ogg

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.xiph.org/downloads/' | \
    $(SED) -n 's,.*libvorbis-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        PKG_CONFIG='$(MXE_PKG_CONFIG)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS)
endef
