# This file is part of MXE.
# See index.html for further information.

PKG             := dbus
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.7.6
$(PKG)_CHECKSUM := 3b2b5375251408c524519ef8a418ad5681832876
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(PKG).freedesktop.org/releases/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://cgit.freedesktop.org/dbus/dbus/refs/tags' | \
    $(SED) -n "s,.*<a href='[^']*/tag/?id=[^0-9]*\\([0-9][^']*\\)'.*,\\1,p" | \
    grep -v '^1\.[01234]\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --with-xml=expat \
        --disable-tests \
        --disable-verbose-mode \
        --disable-asserts \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-maintainer-mode \
        --disable-silent-rules \
        --disable-launchd \
        --disable-doxygen-docs \
        --disable-xml-docs \
        CFLAGS='-DPROCESS_QUERY_LIMITED_INFORMATION=0x1000' \
	&& $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
endef
