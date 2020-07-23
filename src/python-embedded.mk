# This file is part of MXE.
# See index.html for further information.
#
# NOTE: this is currently depreciated from the mxe build in favor of msys2-python

PKG             := python-embedded
$(PKG)_VERSION  := 3.8.1
$(PKG)_CHECKSUM := 7b33bfd3c61f5eb868acb6130b3215e044061046
$(PKG)_SUBDIR   := 
$(PKG)_FILE     := python-$($(PKG)_VERSION)-embed-win32.zip
$(PKG)_URL      := https://www.python.org/ftp/python/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(3)$(HOST_PREFIX)/python'
    cd '$(1)' && tar cf - . | ( cd '$(3)$(HOST_PREFIX)/python'; tar xpf - )
    if test x$(MXE_WINDOWS_BUILD) = xyes; then \
      cp '$(3)$(HOST_PREFIX)/python/python.exe' '$(3)$(HOST_PREFIX)/python/python3.exe'; \
    fi
endef
