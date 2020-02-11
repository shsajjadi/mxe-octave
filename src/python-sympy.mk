# This file is part of MXE.
# See index.html for further information.

PKG             := python-sympy
$(PKG)_VERSION  := 1.4
$(PKG)_CHECKSUM := 9485daf9e29f4ffa20e04111bea940a917eb3a69
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := sympy-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/sympy/sympy/releases/download/sympy-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS += python-embedded python-mpmath

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    rm -rf '$(HOST_PREFIX)/python/sympy*'

    mkdir -p '$(3)$(HOST_PREFIX)/python'
    cd '$(1)/sympy-$($(PKG)_VERSION)' && tar cf - sympy | ( cd '$(3)$(HOST_PREFIX)/python'; tar xpf - )
    cd '$(1)' && tar cf - --exclude=sympy-$($(PKG)_VERSION)/sympy . | ( cd '$(3)$(HOST_PREFIX)/python'; tar xpf - )
endef
