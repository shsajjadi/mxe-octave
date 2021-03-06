# This file is part of MXE.
# See index.html for further information.

PKG             := of-communications
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.2.3
$(PKG)_CHECKSUM := add4e746b34efe7156b10e5be42ab61473a69670
$(PKG)_REMOTE_SUBDIR :=
$(PKG)_SUBDIR   := communications-$($(PKG)_VERSION)
$(PKG)_FILE     := communications-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := '$(OCTAVE_FORGE_BASE_URL)/$($(PKG)_FILE)/download'
$(PKG)_DEPS     := of-signal

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
    ifeq ($(MXE_NATIVE_BUILD),no)
        ifeq ($(USE_SYSTEM_OCTAVE),no)
            # Remove this when package builds without calling Octave
            $(PKG)_DEPS += build-octave
        endif
    endif
endif

$(PKG)_OPTIONS := comm_cv_hdf5_cppflags='-I$(HOST_INCDIR)' comm_cv_hdf5_ldflags='-L$(HOST_LIBDIR)' comm_cv_hdf5_libs=-lhdf5

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    cd $(1)/src && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        PKG_CONFIG='$(MXE_PKG_CONFIG)' \
        PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig'
    $(call OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),$($(PKG)_OPTIONS))
endef
