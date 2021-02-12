# This file is part of MXE.
# See index.html for further information.

PKG             := s2tc
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0
$(PKG)_CHECKSUM := 08295ae27abe2718f7be01f490e7a08353060291
$(PKG)_SUBDIR   := s2tc-$($(PKG)_VERSION)
$(PKG)_FILE     := s2tc-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://github.com/divVerent/s2tc/archive/v$($(PKG)_VERSION).zip
$(PKG)_DEPS     := mesa-proto

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
  cd '$(1)' && ./autogen.sh
  mkdir '$(1)/.build'
  cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
      $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
      $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
      $(ENABLE_SHARED_OR_STATIC) \
      --prefix='$(HOST_PREFIX)' \
      --disable-tools \
      && $(CONFIGURE_POST_HOOK)

  $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'

  ## Mesa attempts to dynamically load dxtn.dll on Windows systems.
  if [ $(MXE_WINDOWS_BUILD) = yes ]; then \
    mv '$(3)$(HOST_BINDIR)/libtxc_dxtn-0.dll' '$(3)$(HOST_BINDIR)/dxtn.dll'; \
  fi
endef
