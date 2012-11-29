# This file is part of MXE.
# See index.html for further information.

PKG             := glpk
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 35e16d3167389b6bc75eb51b4b48590db59f789c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := glpk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/glpk/glpk/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package glpk.' >&2;
    echo $(glpk_VERSION)
endef

define $(PKG)_BUILD
    # build GCC and support libraries
    mkdir '$(1)/.build'
    cd '$(1)/.build' && '$(1)/configure' \
        --host='$(TARGET)' \
        --build="`config.guess`" \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(PREFIX)/$(TARGET)/lib/libglpk.a'; \
      $(INSTALL) -d '$(PREFIX)/$(TARGET)/bin'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libglpk.dll.a' '$(PREFIX)/$(TARGET)/lib/libglpk.dll.a'; \
      $(INSTALL) -m755 '$(PREFIX)/$(TARGET)/lib/libglpk.dll' '$(PREFIX)/$(TARGET)/bin/libglpk.dll'; \
      rm -f '$(PREFIX)/$(TARGET)/lib/libglpk.dll'; \
    fi
endef
