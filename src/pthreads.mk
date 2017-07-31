# This file is part of MXE.
# See index.html for further information.

PKG             := pthreads
$(PKG)_IGNORE   := $(mingw-w64_IGNORE)
$(PKG)_VERSION  := $(mingw-w64_VERSION)
$(PKG)_CHECKSUM := $(mingw-w64_CHECKSUM)
$(PKG)_SUBDIR   := $(mingw-w64_SUBDIR)
$(PKG)_FILE     := $(mingw-w64_FILE)
$(PKG)_URL      := $(mingw-w64_URL)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo $(mingw-w64_VERSION)
endef

ifeq ($(MXE_SYSTEM)$(MXE_NATIVE_BUILD),mingwno)
define $(PKG)_BUILD
    # apply the mingw-w64 patches to the mingw sources
    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/mingw-w64-*.patch)),
      (cd '$(1)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/$(MXE_SYSTEM)-mingw-w64-*.patch)),
      (cd '$(1)' && $(PATCH) -p1 -u) < $(PKG_PATCH))

    cd '$(1)/mingw-w64-libraries/winpthreads' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC)
        
    $(MAKE) -C '$(1)/mingw-w64-libraries/winpthreads' -j '$(JOBS)'
    $(MAKE) -C '$(1)/mingw-w64-libraries/winpthreads' -j 1 install
endef
else
define $(PKG)_BUILD
endef
endif
