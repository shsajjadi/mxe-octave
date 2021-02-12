# This file is part of MXE.
# See index.html for further information.

PKG             := mman-win32
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3421c28e753c38d24a2e27c111b1c9b4601ebe7d
$(PKG)_CHECKSUM := c33e84043d49d0e33bc434bda3a16ce60432e789
$(PKG)_SUBDIR   := mman-win32-master
$(PKG)_FILE     := mman-win32-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/witwall/mman-win32/archive/master.tar.gz
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'TODO: Updates for package mman-win32 need to be written.' >&2;
    echo $(mman-win32_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && chmod +x configure
    cd '$(1)' && ./configure \
        --cross-prefix='$(MXE_TOOL_PREFIX)' \
        --enable-static \
        --prefix='$(HOST_PREFIX)' \
        --libdir='$(HOST_LIBDIR)' \
        --incdir='$(HOST_INCDIR)/sys'
    $(MAKE) -C '$(1)' -j $(JOBS)
    $(MAKE) -C '$(1)' -j 1 install

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(HOST_LIBDIR)/libmman.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
    fi
endef
