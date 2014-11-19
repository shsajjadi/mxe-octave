# This file is part of MXE.
# See index.html for further information.

PKG             := build-yasm
$(PKG)_IGNORE    = $(yasm_IGNORE)
$(PKG)_VERSION  := $(yasm_VERSION)
$(PKG)_CHECKSUM  = $(yasm_CHECKSUM)
$(PKG)_SUBDIR    = $(yasm_SUBDIR)
$(PKG)_FILE      = $(yasm_FILE)
$(PKG)_URL       = $(yasm_URL)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo $(yasm_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --disable-nls \
        --disable-python
    $(MAKE) -C '$(1).build' -j '$(JOBS)' 
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
