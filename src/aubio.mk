# This file is part of mingw-cross-env.
# See doc/index.html or doc/README for further information.

# aubio
PKG             := aubio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.2
$(PKG)_CHECKSUM := 8ef7ccbf18a4fa6db712a9192acafc9c8d080978
$(PKG)_SUBDIR   := aubio-$($(PKG)_VERSION)
$(PKG)_FILE     := aubio-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://www.aubio.org
$(PKG)_URL      := http://www.aubio.org/pub/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc fftw libsamplerate libsndfile

define $(PKG)_UPDATE
    wget -q -O- 'http://www.aubio.org/download' | \
    $(SED) -n 's,.*aubio-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --disable-jack \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
