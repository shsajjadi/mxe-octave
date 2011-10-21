# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# mpfr
PKG             := mpfr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.1
$(PKG)_CHECKSUM := caa0609934c0d2ffa29bd11bfa9c05fbade130eb
$(PKG)_SUBDIR   := mpfr-$($(PKG)_VERSION)
$(PKG)_FILE     := mpfr-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.mpfr.org/
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/mpfr/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc gmp

define $(PKG)_UPDATE
    wget -q -O- 'http://www.mpfr.org/mpfr-current/#download' | \
    grep 'mpfr-' | \
    $(SED) -n 's,.*mpfr-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --enable-static \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)' \
        --enable-threads=win32 \
	--with-gmp-include='$(PREFIX)/$(TARGET)/include/'
	--with-gmp-lib='$(PREFIX)/$(TARGET)/lib/'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
