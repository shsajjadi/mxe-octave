# This file is part of MXE.
# See index.html for further information.

PKG             := texinfo
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := fbbc35c5857d11d1164c8445c78b66ad6d472072
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/texinfo/$($(PKG)_FILE)
$(PKG)_DEPS     := # libgnurx

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package texinfo.' >&2;
    echo $(texinfo_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)'

    for d in gnulib/lib install-info tp util; do \
      $(MAKE) -C '$(1).build' -C $$d -j '$(JOBS)'; \
    done
    for d in gnulib/lib install-info tp util; do \
      $(MAKE) -C '$(1).build' -C $$d -j '$(JOBS)' install DESTDIR='$(3)'; \
    done
endef
