# This file is part of MXE.
# See index.html for further information.

PKG             := libidn2
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.3.0
$(PKG)_CHECKSUM := 53f54fd3c305d871ed5716406c0695fad5c34c45
$(PKG)_SUBDIR   := libidn2-$($(PKG)_VERSION)
$(PKG)_FILE     := libidn2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/libidn/$($(PKG)_FILE)
$(PKG)_DEPS     := gettext libiconv libunistring

define $(PKG)_UPDATE
    $(WGET) -q -O- https://ftp.gnu.org/gnu/libidn/ | \
    $(SED) -n 's,.*libidn2-\([0-9][^t]*\).tar.gz.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-doc \
        && $(CONFIGURE_POST_HOOK)
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(MXE_DISABLE_PROGS) DESTDIR='$(3)'
    $(MAKE) -C '$(1)' -j 1 install $(MXE_DISABLE_PROGS) $(MXE_DISABLE_DOCS) DESTDIR='$(3)'
    # create pkg-config files
    $(INSTALL) -d '$(HOST_LIBDIR)/pkgconfig'
    (echo 'Name: $(PKG)'; \
     echo 'Version: $($(PKG)_VERSION)'; \
     echo 'Description: implementation of IDNA2008/TR46 internationalized domain names'; \
     echo 'Libs: -lidn2'; \
     echo 'Libs.private: -lunistring -liconv -lcharset';) \
     > '$(HOST_LIBDIR)/pkgconfig/$(PKG).pc'
    # TODO create pc files for iconv and unistring.

endef
