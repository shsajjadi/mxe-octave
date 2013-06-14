# This file is part of MXE.
# See index.html for further information.

PKG             := termcap
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 42dd1e6beee04f336c884f96314f0c96cc2578be
$(PKG)_SUBDIR   := termcap-$($(PKG)_VERSION)
$(PKG)_FILE     := termcap-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/termcap/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package termcap.' >&2;
    echo $(termcap_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        AR=$(MXE_AR)

    $(MAKE) AR=$(MXE_AR) -C '$(1)' -j '$(JOBS)' install

    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(HOST_LIBDIR)/libtermcap.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
    fi
endef
