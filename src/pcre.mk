# This file is part of MXE.
# See index.html for further information.

PKG             := pcre
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c4dd6aa1ffeca7bea1bc45b214c8e862bfdacc3c
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
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= DESTDIR='$(3)'
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/pcre-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/pcre-config'; \
    fi
endef
