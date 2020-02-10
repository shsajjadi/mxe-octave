# This file is part of MXE.
# See index.html for further information.

PKG             := python-sympy
$(PKG)_VERSION  := 1.5
$(PKG)_CHECKSUM := be2e740860f7900f0ee2a8102d2943fded44125c
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := sympy-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/sympy/sympy/releases/download/sympy-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS += python-embedded python-mpmath

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(3)$(HOST_PREFIX)/python'
    cd '$(1)/sympy-$($(PKG)_VERSION)' && tar cf - sympy | ( cd '$(3)$(HOST_PREFIX)/python'; tar xpf - )
    cd '$(1)' && tar cf - --exclude=sympy-$($(PKG)_VERSION)/sympy . | ( cd '$(3)$(HOST_PREFIX)/python'; tar xpf - )
endef
