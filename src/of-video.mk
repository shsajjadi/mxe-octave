# This file is part of MXE.
# See index.html for further information.

PKG             := of-video
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.2
$(PKG)_CHECKSUM := f7fd729ade4dcd8951cc61e9b13b89dbfaf342bd
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := video-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := ffmpeg


ifeq ($(MXE_SYSTEM),mingw)
$(PKG)_OPTIONS := ac_cv_func_realloc_0_nonnull=yes ac_cv_func_malloc_0_nonnull=yes
else
$(PKG)_OPTIONS := 
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="video-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(call OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),$($(PKG)_OPTIONS))
endef
