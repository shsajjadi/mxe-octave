# This file is part of MXE.
# See index.html for further information.

PKG             := libgd
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1.0
$(PKG)_CHECKSUM := 66c56fc07246b66ba649c83e996fd2085ea2f9e2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := https://bitbucket.org/libgd/gd-libgd/downloads/$(PKG)-$($(PKG)_VERSION).tar.xz
ifeq ($(USE_SYSTEM_FONTCONFIG),no)
  $(PKG)_FONTCONFIG := fontconfig
endif
$(PKG)_DEPS     := $($(PKG)_FONTCONFIG) freetype libpng jpeg tiff zlib

ifneq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS += pthreads
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package libgd.' >&2;
    echo $(libgd_VERSION)
endef

define $(PKG)_BUILD
    if [ $(MXE_SYSTEM) = msvc ]; then \
        cd '$(1)' && libtoolize && autoreconf -i; \
    fi

    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
	PKG_CONFIG='$(MXE_PKG_CONFIG)' \
	PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig' \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
