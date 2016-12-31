# This file is part of MXE.
# See index.html for further information.

PKG             := pcre
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.39
$(PKG)_CHECKSUM := 5e38289fd1b4ef3e8426f31a01e34b6924d80b90
$(PKG)_SUBDIR   := pcre-$($(PKG)_VERSION)
$(PKG)_FILE     := pcre-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/pcre/pcre/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/pcre/files/pcre/' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(if $(filter-out msvc,$(MXE_SYSTEM)),
        $(SED) -i 's|__declspec(dllimport)||' '$(1)/pcre.h.in'
        $(SED) -i 's|__declspec(dllimport)||' '$(1)/pcreposix.h')
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-pcre16 \
        --enable-utf \
        --enable-unicode-properties \
        --disable-cpp \
        --disable-pcregrep-libz \
        --disable-pcregrep-libbz2 \
        --disable-pcretest-libreadline && $(CONFIGURE_POST_HOOK)
    rm -f '$(HOST_PREFIX)'/share/man/man3/pcre16*.3
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS) DESTDIR='$(3)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) DESTDIR='$(3)'
    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
       rm -rf "$(3)$(HOST_PREFIX)/share/doc/pcre/html"; \
       rm -rf "$(3)$(HOST_PREFIX)/share/man"; \
    fi
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/pcre-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/pcre-config'; \
    fi
endef
