# This file is part of MXE.
# See index.html for further information.

PKG             := libdrm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.83
$(PKG)_CHECKSUM := b80228d235805e46f0d8e62ab1f7231ebd2fd67e
$(PKG)_SUBDIR   := libdrm-$($(PKG)_VERSION)
$(PKG)_FILE     := libdrm-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://dri.freedesktop.org/libdrm/$($(PKG)_FILE)
$(PKG)_DEPS     := 

ifeq ($(MXE_WINDOWS_BUILD),yes)
  define $(PKG)_BUILD
  endef
else
  define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
	--disable-udev \
	--disable-libkms \
	--disable-intel \
	--disable-radeon \
	--disable-amdgpu \
	--disable-nouveau \
	--disable-vmwgfx \
	--disable-omap-experimental-api \
	--disable-exynos-experimental-api \
	--disable-freedreno \
	--disable-freedreno-kgsl \
	--disable-tegra-experimental-api \
	--disable-vc4 \
	--disable-etnaviv-experimental-api \
	--disable-install-test-programs \
	--disable-cairo-tests \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
  endef
endif
