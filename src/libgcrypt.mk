# This file is part of MXE.
# See index.html for further information.

PKG             := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := c9998383532ba3e8bcaf690f2f0d65e814b48d2f
$(PKG)_SUBDIR   := libgcrypt-$($(PKG)_VERSION)
$(PKG)_FILE     := libgcrypt-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_DEPS     := libgpg_error

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/' | \
    $(SED) -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v '^1\.4\.' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' && $(CONFIGURE_POST_HOOK)
    $(if $(filter msvc,$(MXE_SYSTEM)), \
        $(SED) -i -e '/^LTCPPASCOMPILE/ {s/$$(LIBTOOL)/& --tag=CC/;}' '$(1)/mpi/Makefile')
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -m755 '$(HOST_BINDIR)/libgcrypt-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)libgcrypt-config'; \
    fi
endef
