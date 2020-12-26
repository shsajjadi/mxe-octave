# This file is part of MXE.
# See index.html for further information.

PKG             := build-perl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.30.2
$(PKG)_CHECKSUM := e02a31cc8f536b4927d8e018d265cddb790bb4e2
$(PKG)_SUBDIR   := perl-$($(PKG)_VERSION)
$(PKG)_FILE     := perl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cpan.org/src/5.0/$($(PKG)_FILE)
$(PKG)_DEPS     := 

ifeq ($(BUILD_SHARED),yes)
  ## Without this, building libproxy fails.
  $(PKG)_CONFIGURE_ARGS := -Duseshrplib
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.cpan.org/src/5.0' | \
    $(SED) -n 's,.*<a href="perl-\([0-9\.]*\)\.tar.gz".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  define $(PKG)_BUILD
  endef
else
  define $(PKG)_BUILD
    cd '$(1)' \
      && $($(PKG)_CONFIGURE_ENV) './Configure' -s -d -e \
        -Dprefix='$(HOST_PREFIX)' \
        -D $(CONFIGURE_CPPFLAGS) -D $(CONFIGURE_LDFLAGS) \
        $($(PKG)_CONFIGURE_ARGS) \
      && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
    $(INSTALL) -m755 '$(1)/libperl.so' '$(3)/$(HOST_LIBDIR)'

  endef
endif
