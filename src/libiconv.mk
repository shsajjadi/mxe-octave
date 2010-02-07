# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# libiconv
PKG             := libiconv
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.13.1
$(PKG)_CHECKSUM := 5b0524131cf0d7abd50734077f13aaa5508f6bbe
$(PKG)_SUBDIR   := libiconv-$($(PKG)_VERSION)
$(PKG)_FILE     := libiconv-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.gnu.org/software/libiconv/
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/libiconv/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.gnu.org/software/libiconv/' | \
    grep 'libiconv-' | \
    $(SED) -n 's,.*libiconv-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's, sed , $(SED) ,g' -i '$(1)/windows/windres-options'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --prefix='$(PREFIX)/$(TARGET)' \
        --disable-shared \
        --disable-nls
    $(MAKE) -C '$(1)/libcharset' -j '$(JOBS)' install
    $(MAKE) -C '$(1)/lib'        -j '$(JOBS)' install
    $(INSTALL) -d '$(PREFIX)/$(TARGET)/include'
    $(INSTALL) -m644 '$(1)/include/iconv.h.inst' '$(PREFIX)/$(TARGET)/include/iconv.h'
endef
