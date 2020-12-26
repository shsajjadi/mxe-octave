# This file is part of MXE.
# See index.html for further information.

PKG             := python-sympy
$(PKG)_VERSION  := 1.4
$(PKG)_CHECKSUM := 9485daf9e29f4ffa20e04111bea940a917eb3a69
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := sympy-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/sympy/sympy/releases/download/sympy-$($(PKG)_VERSION)/$($(PKG)_FILE)

$(PKG)_DEPS     := python-mpmath

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
    rm -rf '$($(PKG)_PYTHON_PKG_DIR)/sympy*'

    mkdir -p '$($(PKG)_PYTHON_PKG_DIR)'
    cd '$(1)/sympy-$($(PKG)_VERSION)' && tar cf - sympy | ( cd '$($(PKG)_PYTHON_PKG_DIR)'; tar xpf - )
    cd '$(1)' && tar cf - --exclude=sympy-$($(PKG)_VERSION)/sympy . | ( cd '$($(PKG)_PYTHON_PKG_DIR)'; tar xpf - )
endef
