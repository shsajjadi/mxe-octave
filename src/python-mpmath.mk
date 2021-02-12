# This file is part of MXE.
# See index.html for further information.

PKG             := python-mpmath
$(PKG)_VERSION  := 1.1.0
$(PKG)_CHECKSUM := 3f479408ea65b08bc23eeebe5dac2f2293dfec9d
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := mpmath-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://files.pythonhosted.org/packages/ca/63/3384ebb3b51af9610086b23ea976e6d27d6d97bf140a76a365bd77a3eb32/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(MXE_WINDOWS_BUILD),yes)
 $(PKG)_DEPS += msys2-python
 $(PKG)_PYTHON_PKG_DIR := $(MSYS2_DIR)/usr/lib/python$(call SHORT_PKG_VERSION,msys2-python)/site-packages/
else
 $(PKG)_PYTHON_PKG_DIR := $(3)$(HOST_PREFIX)/python
endif

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$($(PKG)_PYTHON_PKG_DIR)'
    cd '$(1)/mpmath-$($(PKG)_VERSION)' && tar cf - mpmath | ( cd '$($(PKG)_PYTHON_PKG_DIR)'; tar xpf - )
    cd '$(1)' && tar cf - --exclude=mpmath-$($(PKG)_VERSION)/mpmath . | ( cd '$($(PKG)_PYTHON_PKG_DIR)'; tar xpf - )
endef
