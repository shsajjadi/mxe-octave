# This file is part of MXE.
# See index.html for further information.

PKG             := fftw
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 11487180928d05746d431ebe7a176b52fe205cf9
$(PKG)_SUBDIR   := fftw-$($(PKG)_VERSION)
$(PKG)_FILE     := fftw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.fftw.org/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_HAVE_LONG_DOUBLE := false
else
    $(PKG)_HAVE_LONG_DOUBLE := true
    $(PKG)_CONFIG_OPTS := --with-our-malloc
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.fftw.org/download.html' | \
    $(SED) -n 's,.*fftw-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v alpha | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    if [ $(MXE_SYSTEM) = msvc ]; then \
        $(SED) -i -e 's,-lm\>,,' '$(1)/fftw.pc.in'; \
    fi
    cd '$(1)' && ./configure \
        F77=$(MXE_F77) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads \
        --enable-sse2 \
        $($(PKG)_CONFIG_OPTS) \
        --enable-double && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= DESTDIR='$(3)'

    if $($(PKG)_HAVE_LONG_DOUBLE); then \
        cd '$(1)' && ./configure \
            F77=$(MXE_F77) \
            $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
            $(ENABLE_SHARED_OR_STATIC) \
            --prefix='$(HOST_PREFIX)' \
            --enable-threads \
            --enable-sse2 \
            $($(PKG)_CONFIG_OPTS) \
            --enable-long-double && $(CONFIGURE_POST_HOOK) ; \
        $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= ; \
        $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= DESTDIR='$(3)' ; \
    fi

    cd '$(1)' && ./configure \
        F77=$(MXE_F77) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads \
        --enable-sse2 \
        $($(PKG)_CONFIG_OPTS) \
        --enable-float && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= DESTDIR='$(3)'
endef
