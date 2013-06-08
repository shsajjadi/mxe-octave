# This file is part of MXE.
# See index.html for further information.

PKG             := pthreads
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 24d40e89c2e66a765733e8c98d6f94500343da86
$(PKG)_SUBDIR   := pthreads-w32-$($(PKG)_VERSION)-release
$(PKG)_FILE     := pthreads-w32-$($(PKG)_VERSION)-release.tar.gz
$(PKG)_URL      := ftp://sourceware.org/pub/pthreads-win32/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://sourceware.org/pub/pthreads-win32/dll-latest/include/pthread.h' | \
    $(SED) -n 's/^#define PTW32_VERSION \([^,]*\),\([^,]*\),\([^,]*\),.*/\1-\2-\3/p;'
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j 1 GC-static 
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libpthreadGC2.a' '$(HOST_LIBDIR)/libpthread.a'

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CC)' '$(HOST_LIBDIR)/libpthread.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
    fi

    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/pthread.h'   '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/sched.h'     '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/semaphore.h' '$(HOST_INCDIR)'
endef

else
ifeq ($(MXE_SYSTEM),mingw)
define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j 1 GC-static CROSS='$(TARGET)-'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libpthreadGC2.a' '$(HOST_LIBDIR)/libpthread.a'

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(HOST_LIBDIR)/libpthread.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
    fi

    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/pthread.h'   '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/sched.h'     '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/semaphore.h' '$(HOST_INCDIR)'
endef
else
define $(PKG)_BUILD
endef
endif
endif
