# This file is part of MXE.
# See index.html for further information.

PKG             := build-perl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.26.1
$(PKG)_CHECKSUM := 74a0822429508d593513a0dfd6f51a907bad68d0
$(PKG)_SUBDIR   := perl-$($(PKG)_VERSION)
$(PKG)_FILE     := perl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.cpan.org/src/5.0/$($(PKG)_FILE)

$(PKG)_DEPS     := 

ifeq ($(MXE_WINDOWS_BUILD),yes)
  define $(PKG)_BUILD
  endef
else
  define $(PKG)_BUILD
    cd '$(1)' && $($(PKG)_CONFIGURE_ENV) './Configure' -s -d -e -Dprefix='$(HOST_PREFIX)' \
        -D $(CONFIGURE_CPPFLAGS) -D $(CONFIGURE_LDFLAGS) \
        && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)' -j '$(JOBS)' install DESTDIR='$(3)'
  endef
endif
