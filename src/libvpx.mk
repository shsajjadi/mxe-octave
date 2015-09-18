# This file is part of MXE.
# See index.html for further information.

PKG             := libvpx
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.4.0
$(PKG)_CHECKSUM := d05f4e9a9878886282ac9c9246f8fac080c94c8f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://storage.googleapis.com/downloads.webmproject.org/releases/webm/$($(PKG)_FILE)
$(PKG)_DEPS     := pthreads

$(PKG)_TARGET_OPTS := 
$(PKG)_ENV := 

ifeq ($(MXE_NATIVE_BUILD),no)
  ifeq ($(ENABLE_WINDOWS_64),yes)
    $(PKG)_TARGET_OPTS := --target=x86_64-win64-gcc 
  else
    $(PKG)_TARGET_OPTS := --target=x86-win32-gcc 
  endif
endif


define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://downloads.webmproject.org/releases/webm/index.html' | \
    $(SED) -n 's,.*libvpx-\([0-9][^>]*\)\.tar.*,\1,p' | \
    $(SORT) -Vr | \
    head -1
endef

ifeq ($(MXE_NATIVE_BUILD),no)
define $(PKG)_BUILD
    cd '$(1)' && \
        CROSS='$(MXE_TOOL_PREFIX)' \
        ./configure \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_TARGET_OPTS) \
        --as=yasm \
        --extra-cflags='-std=gnu89' \
        --disable-examples \
        --disable-install-docs
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
    $(MXE_RANLIB) $(HOST_LIBDIR)/libvpx.a
    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(HOST_LIBDIR)/libvpx.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)' -lpthread; \
    fi
endef
else
define $(PKG)_BUILD
    cd '$(1)' && \
        $($(PKG)_ENV) \
        ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-examples \
        --disable-install-docs
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install
endef
endif
