# This file is part of MXE.
# See index.html for further information.

PKG             := uuid
$(PKG)_IGNORE   = $(mingw-w64_IGNORE)
$(PKG)_VERSION  = 3.17
$(PKG)_CHECKSUM = $(mingw-w64_CHECKSUM)
$(PKG)_SUBDIR   = $(mingw-w64_SUBDIR)
$(PKG)_FILE     = $(mingw-w64_FILE)
$(PKG)_URL      = $(mingw-w64_URL)
$(PKG)_DEPS     = mingw-w64

define $(PKG)_UPDATE
    echo "$($(PKG)_VERSION)"
endef

define $(PKG)_BUILD
    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(HOST_BINDIR)'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(HOST_LIBDIR)/libuuid.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
      rm -f $(HOST_LIBDIR)/libuuid.dll.a; \
    fi
endef
