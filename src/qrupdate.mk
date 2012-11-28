# This file is part of MXE.
# See index.html for further information.

PKG             := qrupdate
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := f7403b646ace20f4a2b080b4933a1e9152fac526
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qrupdate-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/qrupdate/files/$($(PKG)_FILE)
$(PKG)_DEPS     := blas lapack

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qrupdate.' >&2;
    echo $(qrupdate_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) FC=$(TARGET)-gfortran AR=$(TARGET)-ar PREFIX=$(PREFIX)/$(TARGET) -C '$(1)' -j '$(JOBS)' lib install-staticlib

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gfortran' '$(1)/libqrupdate.a' -llapack -lblas; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(INSTALL) -m644 '$(1)/libqrupdate.dll.a' '$(PREFIX)/$(TARGET)/lib/libqrupdate.dll.a'; \
      $(INSTALL) -m644 '$(1)/libqrupdate.dll' '$(PREFIX)/$(TARGET)/bin/libqrupdate.dll'; \
    fi
endef
