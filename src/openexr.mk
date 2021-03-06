# This file is part of MXE.
# See index.html for further information.

PKG             := openexr
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.5.2
$(PKG)_CHECKSUM := e4773b3da36c38052b8172c22000a8bf715808bc
$(PKG)_SUBDIR   := openexr-$($(PKG)_VERSION)
$(PKG)_FILE     := openexr-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := pthreads zlib

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/$(PKG)/$(PKG)/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | \
    head -1
endef

ifeq ($(MXE_NATIVE_BUILD),yes)
    define $(PKG)_BUILD
        mkdir '$(1)/build'
        cd '$(1)/build' && cmake ..  \
            $(CMAKE_CCACHE_FLAGS) \
            $(CMAKE_BUILD_SHARED_OR_STATIC) \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
            -DBUILD_TESTING='OFF' \
            -DINSTALL_OPENEXR_DOCS='OFF' \
            -DINSTALL_OPENEXR_EXAMPLES='OFF' \
            -DOPENEXR_BUILD_UTILS='OFF' \
            -DPYILMBASE_ENABLE='OFF' \
            -DOPENEXR_VIEWERS_ENABLE='OFF'

        $(MAKE) -C '$(1)/build' -j '$(JOBS)' VERBOSE=1
        $(MAKE) -C '$(1)/build' -j 1 install DESTDIR='$(3)'
    endef
else
    define $(PKG)_BUILD
        mkdir '$(1)/build'
        cd '$(1)/build' && cmake ..  \
            $(CMAKE_CCACHE_FLAGS) \
            $(CMAKE_BUILD_SHARED_OR_STATIC) \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
            -DBUILD_TESTING='OFF' \
            -DCMAKE_VERBOSE_MAKEFILE='ON' \
            -DPYILMBASE_ENABLE='OFF' \
            -DINSTALL_OPENEXR_DOCS='OFF' \
            -DINSTALL_OPENEXR_EXAMPLES='OFF' \
            -DOPENEXR_BUILD_UTILS='OFF' \
            -DOPENEXR_VIEWERS_ENABLE='OFF' \
            -DOPENEXR_INSTALL_PKG_CONFIG='ON' \
            -DILMBASE_LIB_SUFFIX='' \
            -DOPENEXR_LIB_SUFFIX='' \
            -DCMAKE_CXX_STANDARD=11 \
            -DCMAKE_CXX_FLAGS='-D_WIN32_WINNT=0x0500'

        $(MAKE) -C '$(1)/build' -j '$(JOBS)' VERBOSE=1
        $(MAKE) -C '$(1)/build' -j 1 install DESTDIR='$(3)'
    endef
endif
