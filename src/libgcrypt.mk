# This file is part of MXE.
# See index.html for further information.

PKG             := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 2c6553cc17f2a1616d512d6870fe95edf6b0e26e
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

ifeq ($(TARGET),x86_64-w64-mingw32)
  $(PKG)_TARGET_CONFIGURE_OPTIONS := ac_cv_sys_symbol_underscore=no
else
  $(PKG)_TARGET_CONFIGURE_OPTIONS :=
endif

define $(PKG)_BUILD
    sed -i -e '/^ *;/d' -e '/^ *$$/d' '$(1)/src/libgcrypt.def'
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-gpg-error-prefix='$(HOST_PREFIX)' \
        $($(PKG)_TARGET_CONFIGURE_OPTIONS) && $(CONFIGURE_POST_HOOK)
    $(if $(filter msvc,$(MXE_SYSTEM)), \
        $(SED) -i -e '/^LTCPPASCOMPILE/ {s/$$(LIBTOOL)/& --tag=CC/;}' '$(1)/mpi/Makefile')
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= DESTDIR='$(3)'
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/libgcrypt-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)libgcrypt-config'; \
    fi
endef
