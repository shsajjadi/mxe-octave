# This file is part of MXE.
# See index.html for further information.

PKG             := gdcm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.0.8
$(PKG)_CHECKSUM := 520d57530d20d5a0f5bb99a040cd261304902c89
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/$(PKG)/$(PKG) 3.x/GDCM $($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := expat zlib

$(PKG)_CMAKE_OPTS :=
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_CMAKE_OPTS := -G "MSYS Makefiles" 
  endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/gdcm/files/gdcm 3.x/' | \
    $(SED) -n 's,.*title=\"GDCM \([0-9.]*\)\".*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

ifeq ($(MXE_SYSTEM),msvc)
    define $(PKG)_BUILD
        mkdir '$(1)/../.build'
        cd '$(1)/../.build' && cmake \
            -G "NMake Makefiles" \
            $(CMAKE_CCACHE_FLAGS) \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'  \
            -DGDCM_BUILD_SHARED_LIBS:BOOL=TRUE \
            -DGDCM_USE_SYSTEM_ZLIB:BOOL=TRUE \
            -DGDCM_USE_SYSTEM_EXPAT:BOOL=TRUE \
            -DGDCM_BUILD_TESTING:BOOL=FALSE \
            -DGDCM_DOCUMENTATION:BOOL=FALSE \
            -DGDCM_BUILD_DOCBOOK_MANPAGES:BOOL=FALSE \
            ../$($(PKG)_SUBDIR)

        cd '$(1)/../.build' && \
            env -u MAKE -u MAKEFLAGS nmake && \
            env -u MAKE -u MAKEFLAGS nmake install
    endef
else
    define $(PKG)_BUILD
        mkdir '$(1)/../.build'
        cd '$(1)/../.build' && cmake \
            $($(PKG)_CMAKE_OPTS) \
            $(CMAKE_CCACHE_FLAGS) \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)'  \
            -DGDCM_BUILD_SHARED_LIBS:BOOL=TRUE \
            -DGDCM_BUILD_TESTING:BOOL=FALSE \
            -DGDCM_DOCUMENTATION:BOOL=FALSE \
            -DGDCM_BUILD_DOCBOOK_MANPAGES:BOOL=FALSE \
            ../$($(PKG)_SUBDIR)

        make -C $(1)/../.build -j $(JOBS) 
        make -C $(1)/../.build -j 1 install DESTDIR=$(3)
    endef

endif
