# This file is part of MXE.
# See index.html for further information.

PKG             := libmng
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c21c84b614500ae1a41c6595d5f81c596e406ca2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG)-devel/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib jpeg lcms1

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/libmng/files/libmng-devel/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cp '$(1)'/makefiles/Makefile.am '$(1)'
    cp '$(1)'/makefiles/configure.in '$(1)/configure.in'
    cd '$(1)' && autoreconf --install
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-shared
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
    $(SED) -e 's^@prefix@^$(PREFIX)/$(TARGET)^;' \
           -e 's^@VERSION@^$(libmng_VERSION)^;' \
           -e 's^@mng_libs_private@^-ljpeg^;' \
           -e 's^@mng_requires_private@^lcms zlib^;' \
           < '$(1)/libmng.pc.in' > '$(1)/libmng.pc'
    $(INSTALL) -m644 '$(1)/libmng.pc' '$(PREFIX)/$(TARGET)/lib/pkgconfig/'
endef
