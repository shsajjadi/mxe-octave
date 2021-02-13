# This file is part of MXE.
# See index.html for further information.

PKG             := libgpg_error
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.41
$(PKG)_CHECKSUM := 66d6270511a48bac0bf347330e7a12c62f3a1ab4
$(PKG)_SUBDIR   := libgpg-error-$($(PKG)_VERSION)
$(PKG)_FILE     := libgpg-error-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := ftp://ftp.gnupg.org/gcrypt/libgpg-error/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext libiconv

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.gnupg.org/gcrypt/libgpg-error/' | \
    $(SED) -n 's,.*libgpg-error-\([1-9]\.[1-9][0-9][^>]*\)\.tar.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)/src/syscfg' && ln -s lock-obj-pub.mingw32.h lock-obj-pub.mingw32.static.h
    cd '$(1)/src/syscfg' && ln -s lock-obj-pub.mingw32.h lock-obj-pub.mingw32.shared.h
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-nls \
        --disable-languages && $(CONFIGURE_POST_HOOK)
    if [ $(MXE_WINDOWS_BUILD) = yes ]; then \
      $(SED) -i 's/-lgpg-error/-lgpg-error -lintl -liconv/;' '$(1)/src/gpg-error-config'; \
      $(SED) -i 's/host_os = mingw32.*/host_os = mingw32/' '$(1)/src/Makefile'; \
    fi
    $(MAKE) -C '$(1)/src' -j '$(JOBS)' bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
    $(MAKE) -C '$(1)/src' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS= DESTDIR='$(3)'
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/gpg-error-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)gpg-error-config'; \
    fi
endef
