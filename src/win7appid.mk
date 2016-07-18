# This file is part of MXE.
# See index.html for further information.

PKG             := win7appid
$(PKG)_VERSION  := 1.1
$(PKG)_CHECKSUM := d726a5832d7a3f49bd7912ca08c70aad96eb95b4
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).zip
$(PKG)_URL      := https://storage.googleapis.com/google-code-archive-source/v2/code.google.com/win7appid/source-archive.zip
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)/trunk/' && \
      $(MXE_CXX) Win7AppId.cpp -municode -DWIN32_LEAN_AND_MEAN=1 -DUNICODE -D_UNICODE -lole32 -o win7appid.exe
    mkdir -p '$(3)$(HOST_BINDIR)'
    $(INSTALL) '$(1)/trunk/win7appid.exe' '$(3)$(HOST_BINDIR)/'
endef
