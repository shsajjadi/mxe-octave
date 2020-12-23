# This file is part of MXE.
# See index.html for further information.

PKG             := fftw
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.9
$(PKG)_CHECKSUM := bf17b485417f0f6a896b8514a3813439fda075fc
$(PKG)_SUBDIR   := fftw-$($(PKG)_VERSION)
$(PKG)_FILE     := fftw-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.fftw.org/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_CONFIG_OPTS :=

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_HAVE_LONG_DOUBLE := false
else
    $(PKG)_HAVE_LONG_DOUBLE := true
    $(PKG)_CONFIG_OPTS += --with-our-malloc
endif

# some suggested mingw fftw settings from www.fftw.org
ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CONFIG_OPTS += \
      --with-combined-threads \
      --with-incoming-stack-boundary=2
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

    # default is double
    cd '$(1)' && ./configure \
        F77=$(MXE_F77) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads \
        --enable-sse2 \
        $($(PKG)_CONFIG_OPTS) \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS)
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS)  DESTDIR='$(3)'

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
        $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS) ; \
        $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)' ; \
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
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS) 
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
endef
