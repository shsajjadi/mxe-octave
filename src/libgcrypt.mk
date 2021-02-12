# This file is part of MXE.
# See index.html for further information.

PKG             := libgcrypt
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.6
$(PKG)_CHECKSUM := 406b02873833427898d16bcc8483bc5c91c73d4a
$(PKG)_SUBDIR   := libgcrypt-$($(PKG)_VERSION)
$(PKG)_FILE     := libgcrypt-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgcrypt/$($(PKG)_FILE)
$(PKG)_DEPS     := libgpg_error zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/' | \
    $(SED) -n 's,.*libgcrypt-\([0-9][^>]*\)\.tar.*,\1,p' | \
    grep -v '^1\.4\.' | \
    tail -1
endef

ifeq ($(TARGET),x86_64-w64-mingw32)
  $(PKG)_TARGET_CONFIGURE_OPTIONS := ac_cv_sys_symbol_underscore=no --disable-padlock-support
else
  $(PKG)_TARGET_CONFIGURE_OPTIONS :=
endif

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-gpg-error-prefix='$(HOST_PREFIX)' \
        $($(PKG)_TARGET_CONFIGURE_OPTIONS) && $(CONFIGURE_POST_HOOK)
    $(if $(filter msvc,$(MXE_SYSTEM)), \
        $(SED) -i -e '/^LTCPPASCOMPILE/ {s/$$(LIBTOOL)/& --tag=CC/;}' '$(1)/mpi/Makefile')
    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/libgcrypt-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)libgcrypt-config'; \
    fi
    # create pkg-config file
    $(INSTALL) -d '$(3)$(HOST_LIBDIR)/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: $(PKG)'; \
     echo 'Libs: ' "`$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)libgcrypt-config --libs`"; \
     echo 'Cflags: ' "`$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)libgcrypt-config --cflags`";) \
     > '$(3)$(HOST_LIBDIR)/pkgconfig/$(PKG).pc'
endef
