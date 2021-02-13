# This file is part of MXE.
# See index.html for further information.

PKG             := transfig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.8
$(PKG)_CHECKSUM := 6a4714b653d98734dcfd3d24e6bdf091c2e20195
$(PKG)_SUBDIR   := fig2dev-$($(PKG)_VERSION)
$(PKG)_FILE     := fig2dev-$($(PKG)_VERSION).tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mcj/$($(PKG)_FILE)
$(PKG)_DEPS     := jpeg libpng

$(PKG)_CONFIG_OPTS := LIBS=-liconv

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_CONFIG_OPTS += --without-xpm \
      BITMAPDIR="/share/fig2dev/bitmaps" \
      RGB_FILE="/share/fig2dev/rgb.txt"
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/mcj/files/' | \
    $(SED) -n 's,.*tr title="fig2dev-\(.*\)\.tar\.xz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' \
        && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $($(PKG)_CONFIG_OPTS) \
        --prefix='$(HOST_PREFIX)' 

    $(MAKE) -C '$(1)' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install DESTDIR='$(3)'
endef
