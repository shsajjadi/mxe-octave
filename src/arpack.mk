# This file is part of MXE.
# See index.html for further information.

PKG             := arpack
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f5453e2d576f131890ca023e1d853e18920f9c3c
$(PKG)_SUBDIR   := $(PKG)-ng_$($(PKG)_VERSION)
$(PKG)_FILE     := arpack-ng_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://forge.scilab.org/index.php/p/arpack-ng/downloads/get/$($(PKG)_FILE)
$(PKG)_DEPS     := blas lapack

ifeq ($(USE_PIC_FLAG),yes)
  $(PKG)_CONFIGURE_PIC_OPTION := --with-pic
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package arpack.' >&2;
    echo $(arpack_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
	$($(PKG)_CONFIGURE_PIC_OPTION) \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'

    if [ $(BUILD_STATIC) = yes ]; then \
      $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install; \
    fi

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/.build/.libs/libarpack.a' --install '$(INSTALL)' --libdir '$(MXE_LIBDIR)' --bindir '$(MXE_BINDIR)' -llapack -lblas; \
    fi
endef
