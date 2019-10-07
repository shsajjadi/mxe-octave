# This file is part of MXE.
# See index.html for further information.

PKG             := openexr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.0
$(PKG)_CHECKSUM := 0b9a24b8fa6b3f7f1d8813e91234308d3e43d10f
$(PKG)_SUBDIR   := openexr-$($(PKG)_VERSION)
$(PKG)_FILE     := openexr-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := ilmbase pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/$(PKG)/$(PKG)/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | \
    head -1
endef

ifeq ($(MXE_NATIVE_BUILD),yes)
define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake ..  \
      -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
      -DBUILD_TESTING='OFF' \
      -DPYILMBASE_ENABLE='OFF' \
      -DOPENEXR_VIEWERS_ENABLE='OFF'

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)/build' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=  DESTDIR='$(3)'
endef

else
define $(PKG)_BUILD
    # native build of parts
    mkdir '$(1)/native'
    cd '$(1)/native' && cmake ..  \
      -DCMAKE_BUILD_TYPE='Release' \
      -DBUILD_SHARED_LIBS='OFF' \
      -DBUILD_TESTING='OFF' \
      -DPYILMBASE_ENABLE='OFF' \
      -DOPENEXR_VIEWERS_ENABLE='OFF' \
      -DCMAKE_FIND_ROOT_PATH='$(ROOT_PREFIX)' 
    $(MAKE) -C '$(1)/native/IlmBase/Half/' eLut toFloat VERBOSE=1
    $(MAKE) -C '$(1)/native/OpenEXR/IlmImf' dwaLookups b44ExpLogTable VERBOSE=1

    # cross compile part
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake ..  \
      -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
      -DBUILD_TESTING='OFF' \
      -DCMAKE_VERBOSE_MAKEFILE='ON' \
      -DPYILMBASE_ENABLE='OFF' \
      -DOPENEXR_VIEWERS_ENABLE='OFF' \
      -DOPENEXR_INSTALL_PKG_CONFIG='ON' \
      -DILMBASE_LIB_SUFFIX='' \
      -DOPENEXR_LIB_SUFFIX='' \
      -DCMAKE_CXX_STANDARD=11 \
      -DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0500'
    $(MAKE) -C '$(1)/build/IlmBase/Half/' eLut toFloat VERBOSE=1

    # now use native build generators
    cd '$(1)/build/IlmBase/Half/' && '$(1)/native/IlmBase/Half/toFloat' > toFloat.h
    cd '$(1)/build/IlmBase/Half/' && '$(1)/native/IlmBase/Half/eLut' > eLut.h

    $(MAKE) -C '$(1)/build/OpenEXR/IlmImf' dwaLookups b44ExpLogTable VERBOSE=1

    cd '$(1)/build/OpenEXR/IlmImf/' && '$(1)/native/bin/dwaLookups' > dwaLookups.h
    cd '$(1)/build/OpenEXR/IlmImf/' && '$(1)/native/bin/b44ExpLogTable' > b44ExpLogTable.h

    $(MAKE) -C '$(1)/build' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)/build' -j 1 install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=  DESTDIR='$(3)'

endef
endif
