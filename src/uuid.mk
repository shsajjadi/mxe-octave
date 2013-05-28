# This file is part of MXE.
# See index.html for further information.

PKG             := uuid
$(PKG)_IGNORE   = $(w32api_IGNORE)
$(PKG)_CHECKSUM = $(w32api_CHECKSUM)
$(PKG)_SUBDIR   = $(w32api_SUBDIR)
$(PKG)_FILE     = $(w32api_FILE)
$(PKG)_URL      = $(w32api_URL)
$(PKG)_DEPS     = gcc

define $(PKG)_UPDATE
    echo "$(w32api_VERSION)"
endef

define $(PKG)_BUILD
    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(1)/lib/libuuid.a' --install '$(INSTALL)' --libdir '$(PREFIX)/$(TARGET)/lib' --bindir '$(PREFIX)/$(TARGET)/bin'; \
    fi
endef
