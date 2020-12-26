# This file is part of MXE.
# See index.html for further information.

PKG             := libsndfile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.28
$(PKG)_CHECKSUM := 85aa967e19f6b9bf975601d79669025e5f8bc77d
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

$(PKG)_EXTRA_CONFIGURE_OPTIONS :=
ifneq ($(filter mingw msvc,$(MXE_SYSTEM)),)
    $(PKG)_EXTRA_CONFIGURE_OPTIONS += --enable-stack-smash-protection
endif

define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi -IM4
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
	$(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --enable-sqlite \
        --enable-external-libs \
        --disable-octave \
        --disable-alsa \
	--disable-full-suite \
        $($(PKG)_EXTRA_CONFIGURE_OPTIONS)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS)  $(MXE_DISABLE_DOCS)
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS)  $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
