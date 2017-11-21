# This file is part of MXE.
# See index.html for further information.

PKG             := librsb
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.0-rc7
$(PKG)_CHECKSUM := 66f66c74597228dfd7a3ba8215ad36a17b31f43b
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := libgomp

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/librsb/files/' | \
    $(SED) -n 's|.*librsb-\([0-9\.]*[-rc0-9]*\)\.tar.gz\/download.*|\1|p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && automake && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --disable-c-examples --disable-fortran-examples \
        --disable-sparse-blas-interface \
        --disable-octave-testing
    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'

    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/librsb-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/librsb-config'; \
    fi

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf "$(3)$(HOST_PREFIX)/share/doc/$(PKG)"; \
    fi
endef
