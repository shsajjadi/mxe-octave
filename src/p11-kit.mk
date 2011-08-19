# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# p11-kit
PKG             := p11-kit
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4
$(PKG)_CHECKSUM := e12c6918e5de9f26f197bcc1a274bbfbf24efe06
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_WEBSITE  := http://p11-glue.freedesktop.org/
$(PKG)_URL      := http://p11-glue.freedesktop.org/releases/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc dlfcn-win32

define $(PKG)_UPDATE
    wget -q -O- 'http://cgit.freedesktop.org/p11-glue/p11-kit/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --enable-static \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)/p11-kit' -j '$(JOBS)' install
endef
