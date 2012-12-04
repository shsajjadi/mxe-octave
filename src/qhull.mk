# This file is part of MXE.
# See index.html for further information.

PKG             := qhull
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 108d59efa60b2ebaf94b121414c8f8b7b76a7409
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qhull-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://download.savannah.gnu.org/releases/qhull/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qhull.' >&2;
    echo $(qhull_VERSION)
endef

define $(PKG)_BUILD
    # build GCC and support libraries
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --enable-static --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install

    if [ $(BUILD_SHARED) = yes ]; then \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-g++' '$(PREFIX)/$(TARGET)/lib/libqhull.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libqhull.dll.a' '$(PREFIX)/$(TARGET)/lib/libqhull.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libqhull.dll' '$(PREFIX)/$(TARGET)/bin/libqhull.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libqhull.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libqhull.la'; \
    fi
endef
