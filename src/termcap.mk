# This file is part of MXE.
# See index.html for further information.

PKG             := termcap
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 42dd1e6beee04f336c884f96314f0c96cc2578be
$(PKG)_SUBDIR   := termcap-$($(PKG)_VERSION)
$(PKG)_FILE     := termcap-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/termcap/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package termcap.' >&2;
    echo $(termcap_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --host='$(TARGET)' \
        --prefix='$(HOST_PREFIX)' \
        AR=$(TARGET)-ar

    $(MAKE) AR=$(TARGET)-ar -C '$(1)' -j '$(JOBS)' install

    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(MXE_LIBDIR)/libtermcap.a' --install '$(INSTALL)' --libdir '$(MXE_LIBDIR)' --bindir '$(MXE_BINDIR)'; \
    fi
endef
