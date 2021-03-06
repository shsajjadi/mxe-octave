# This file is part of MXE.
# See index.html for further information.

PKG             := libsamplerate
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.1.8
$(PKG)_CHECKSUM := e5fe82c4786be2fa33ca6bd4897db4868347fe70
$(PKG)_SUBDIR   := libsamplerate-$($(PKG)_VERSION)
$(PKG)_FILE     := libsamplerate-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.mega-nerd.com/SRC/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.mega-nerd.com/SRC/download.html' | \
    $(SED) -n 's,.*libsamplerate-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
