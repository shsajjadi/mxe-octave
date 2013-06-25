# This file is part of MXE.
# See index.html for further information.

PKG             := fftw
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 11a8c31186ff5a7d686a79a3f21b2530888e0dc2
$(PKG)_SUBDIR   := fftw-$($(PKG)_VERSION)
$(PKG)_FILE     := fftw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.fftw.org/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_HAVE_LONG_DOUBLE := false
else
    $(PKG)_HAVE_LONG_DOUBLE := true
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.fftw.org/download.html' | \
    $(SED) -n 's,.*fftw-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        F77=$(MXE_F77) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads \
        --enable-sse2 \
        --enable-double && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=

    if $($(PKG)_HAVE_LONG_DOUBLE); then \
        cd '$(1)' && ./configure \
            F77=$(MXE_F77) \
            $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
            $(ENABLE_SHARED_OR_STATIC) \
            --prefix='$(HOST_PREFIX)' \
            --enable-threads \
            --enable-sse2 \
            --enable-long-double && $(CONFIGURE_POST_HOOK) ; \
        $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= ; \
        $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= ; \
    fi

    cd '$(1)' && ./configure \
        F77=$(MXE_F77) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads \
        --enable-sse2 \
        --enable-float && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
