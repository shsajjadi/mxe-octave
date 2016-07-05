# This file is part of MXE.
# See index.html for further information.

PKG             := libsndfile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.27
$(PKG)_CHECKSUM := e112d4937352d1722b06911b00c79e9bce15095c
$(PKG)_SUBDIR   := libsndfile-$($(PKG)_VERSION)
$(PKG)_FILE     := libsndfile-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.mega-nerd.com/libsndfile/files/$($(PKG)_FILE)
$(PKG)_DEPS     := sqlite flac ogg vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.mega-nerd.com/libsndfile/' | \
    grep '<META NAME="Version"' | \
    $(SED) -n 's,.*CONTENT="libsndfile-\([0-9][^"]*\)">.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -IM4
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-sqlite \
        --enable-external-libs \
        --disable-octave \
        --disable-alsa \
        --disable-shave
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= man_MANS= html_DATA=
endef
