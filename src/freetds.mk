# This file is part of MXE.
# See index.html for further information.

PKG             := freetds
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.00.107
$(PKG)_CHECKSUM := cdf8fa31b0d81dc0c99fa30a3eef03ed241b2b5c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.freetds.org/pub/$(PKG)/stable/$($(PKG)_FILE)
$(PKG)_DEPS     := libiconv gnutls

$(PKG)_CONFIG_OPTS :=
ifeq ($(MXE_WINDOWS_BUILD),yes)
    $(PKG)_CONFIG_OPTS += --disable-threadsafe
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'ftp://ftp.freetds.org/pub/freetds/stable/' | \
    $(SED) -n 's,.*freetds-\([0-9.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --disable-rpath \
        --disable-dependency-tracking \
        $(ENABLE_SHARED_OR_STATIC) \
        $($(PKG)_CONFIG_OPTS) \
        --enable-libiconv \
        --enable-msdblib \
        --enable-sspi \
        --with-tdsver=7.2 \
        --with-gnutls \
        $($(PKG)_CONFIG_OPTS) \
        PKG_CONFIG='$(MXE_PKG_CONFIG)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install man_MANS=
endef
