# This file is part of MXE.
# See index.html for further information.

PKG             := libgpg_error
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 95b324359627fbcb762487ab6091afbe59823b29
$(PKG)_SUBDIR   := libgpg-error-$($(PKG)_VERSION)
$(PKG)_FILE     := libgpg-error-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-nls \
        --disable-languages
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(LN_SF) '$(HOST_BINDIR)/gpg-error-config' '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)gpg-error-config'
endef
