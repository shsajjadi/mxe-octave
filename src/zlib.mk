# This file is part of MXE.
# See index.html for further information.

PKG             := zlib
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.11
$(PKG)_CHECKSUM := e1cb0d5c92da8e9a8c2635dfa249c341dfd00322
$(PKG)_SUBDIR   := zlib-$($(PKG)_VERSION)
$(PKG)_FILE     := zlib-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://zlib.net/$($(PKG)_FILE)
$(PKG)_URL_2    := http://$(SOURCEFORGE_MIRROR)/project/libpng/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://zlib.net/' | \
    $(SED) -n 's,.*zlib-\([0-9][^>]*\)\.tar.*,\1,ip' | \
    head -1
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
define $(PKG)_BUILD
    cd '$(1)' && CC='$(MXE_CC)' ./configure \
      --prefix='$(HOST_PREFIX)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'

    if [ "$(BUILD_STATIC)" != yes ]; then \
      true; \
    fi

    if [ "$(BUILD_SHARED)" = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(1)/libz.a' --install '$(INSTALL)' --libdir '$(3)$(HOST_LIBDIR)' --bindir '$(3)$(HOST_BINDIR)'; \
    fi
endef
else
ifeq ($(MXE_NATIVE_BUILD),yes)
define $(PKG)_BUILD
    cd '$(1)' && ./configure \
      --prefix='$(HOST_PREFIX)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
endef
else
define $(PKG)_BUILD
    cd '$(1)' && CHOST='$(TARGET)' $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        ./configure \
        --prefix='$(HOST_PREFIX)' \
        --static
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'

    if [ "$(BUILD_SHARED)" = yes ]; then \
      rm -r $(3)$(HOST_LIBDIR)/libz.a; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(1)/libz.a' --install '$(INSTALL)' --libdir '$(3)$(HOST_LIBDIR)' --bindir '$(3)$(HOST_BINDIR)'; \
    fi
endef
endif
endif
