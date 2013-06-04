# This file is part of MXE.
# See index.html for further information.

PKG             := qrupdate
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f7403b646ace20f4a2b080b4933a1e9152fac526
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qrupdate-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/qrupdate/files/$($(PKG)_FILE)
$(PKG)_DEPS     := blas lapack

ifeq ($(ENABLE_64),yes)
  $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := FFLAGS="-g -O2 -fdefault-integer-8"
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qrupdate.' >&2;
    echo $(qrupdate_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    touch '$(1)/NEWS' '$(1)/AUTHORS'
    cd '$(1)' && autoreconf -W none
    chmod a+rx '$(1)/configure'
    cd '$(1)/.build' && '$(1)/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install
endef
