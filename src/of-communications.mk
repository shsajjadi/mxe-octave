# This file is part of MXE.
# See index.html for further information.

PKG             := of-communications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.1
$(PKG)_CHECKSUM := bf70d8c315c2239e168c02522482c81e4b912968
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := communications-$($(PKG)_VERSION)
$(PKG)_FILE     := communications-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-signal

$(PKG)_OPTIONS := comm_cv_hdf5_cppflags='-I$(HOST_INCDIR)' comm_cv_hdf5_ldflags='-L$(HOST_LIBDIR)' comm_cv_hdf5_libs=-lhdf5

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://$(SOURCEFORGE_MIRROR)/projects/octave/files/Octave%20Forge%20Packages/Individual%20Package%20Releases/' | \
    $(SED) -n 's,.*title="communications-\([0-9][^"]*\).tar.gz".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(call OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),$($(PKG)_OPTIONS))
endef
