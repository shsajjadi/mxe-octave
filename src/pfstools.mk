# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# pfstools
PKG             := pfstools
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.2
$(PKG)_CHECKSUM := 6109587b0f8e53d1d963e9e02f7298bf0d197d5d
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_WEBSITE  := http://$(PKG).sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/pfstools/files/pfstools/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-netpbm \
        --disable-openexr \
        --disable-tiff \
        --disable-qt \
        --disable-jpeghdr \
        --disable-imagemagick \
        --disable-octave \
        --disable-opengl \
        --disable-matlab \
        --disable-gdal
    $(MAKE) -C '$(1)'/src/pfs -j '$(JOBS)'
    $(MAKE) -C '$(1)'/src/pfs -j 1 install
endef
