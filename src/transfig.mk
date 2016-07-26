# This file is part of MXE.
# See index.html for further information.

PKG             := transfig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.2.6
$(PKG)_CHECKSUM := 880acd94d679649da43ba5eea16e329b85840bcf
$(PKG)_SUBDIR   := fig2dev-$($(PKG)_VERSION)-rc
$(PKG)_FILE     := fig2dev-$($(PKG)_VERSION)-rc.tar.xz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/mcj/$($(PKG)_FILE)
$(PKG)_DEPS     := jpeg libpng

$(PKG)_CONFIG_OPTS := 

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_CONFIG_OPTS += --without-xpm LIBS=-liconv \
      BITMAPDIR="/share/fig2dev/bitmaps" \
      RGB_FILE="/share/fig2dev/rgb.txt"
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
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
