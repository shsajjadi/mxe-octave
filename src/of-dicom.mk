# This file is part of MXE.
# See index.html for further information.

PKG             := of-dicom
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.3.0
$(PKG)_CHECKSUM := c9cf943df76a6cf6469542b2be3c34f0904bd751
$(PKG)_REMOTE_SUBDIR := 
$(PKG)_SUBDIR   := dicom-$($(PKG)_VERSION)
$(PKG)_FILE     := dicom-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/octave/$($(PKG)_FILE)?download
$(PKG)_DEPS     := gdcm

ifeq ($(ENABLE_BINARY_PACKAGES),yes)
    $(PKG)_DEPS += $(OCTAVE_TARGET)
endif

ifeq ($(MXE_NATIVE_BUILD),no)
$(PKG)_OPTIONS := CMAKE_BINARY="cmake -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'"
else
$(PKG)_OPTIONS := 
endif

define $(PKG)_UPDATE
    $(OCTAVE_FORGE_PKG_UPDATE)
endef

define $(PKG)_BUILD
    $(call OCTAVE_FORGE_PKG_BUILD,$(1),$(2),$(3),$($(PKG)_OPTIONS))
endef
