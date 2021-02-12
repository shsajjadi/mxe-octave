# This file is part of MXE.
# See index.html for further information.

PKG             := xvidcore
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.3
$(PKG)_CHECKSUM := 465763c92679ca230526d4890d17dbf6d6974b08
$(PKG)_SUBDIR   := xvidcore/build/generic
$(PKG)_FILE     := xvidcore-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.xvid.org/downloads/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

ifeq ($(MXE_NATIVE_BUILD),no)
define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' BUILD_DIR='build' $(if $(filter $(BUILD_STATIC), yes),SHARED,STATIC)_LIB=
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/../../src/xvid.h' '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -d '$(HOST_BINDIR)'
    if [ "x$(BUILD_STATIC)" == "xyes" ]; then \
      $(INSTALL) -m644 '$(1)/build/xvidcore.a' '$(HOST_LIBDIR)/libxvidcore.a'; \
    else \
      $(INSTALL) -m644 '$(1)/build/xvidcore.dll.a' '$(HOST_LIBDIR)/libxvidcore.dll.a'; \
      $(INSTALL) -m644 '$(1)/build/xvidcore.dll' '$(HOST_BINDIR)/'; \
    fi
endef
else
define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' BUILD_DIR='build'
    $(MAKE) -C '$(1)' -j 1 BUILD_DIR='build' install
endef
endif
