# This file is part of MXE.
# See index.html for further information.

PKG             := gl2ps
$(PKG)_VERSION  := 1.3.8
$(PKG)_CHECKSUM := 792e11db0fe7a30a4dc4491af5098b047ec378b1
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)-source
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://geuz.org/$(PKG)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := xft


ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    ifeq ($(MXE_SYSTEM),msvc)
        $(PKG)_CMAKE_FLAGS := -G 'NMake Makefiles'
    else
        $(PKG)_CMAKE_FLAGS := -G 'MSYS Makefiles'
    endif
else
    $(PKG)_CMAKE_FLAGS := \
        -DCMAKE_AR='$(MXE_AR)' \
        -DCMAKE_RANLIB='$(MXE_RANLIB)' 
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package octave.' >&2;
    echo $(gl2ps_VERSION)
endef

ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $($(PKG)_CMAKE_FLAGS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DPNG_NAMES=png16 \
        .
    cd '$(1)' && env -u MAKE -u MAKEFLAGS nmake
    cd '$(1)' && env -u MAKE -u MAKEFLAGS nmake DESTDIR='$(3)' install
endef
else
define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $($(PKG)_CMAKE_FLAGS) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        .
    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1 

    # native mingw build doesnt want to install the files, even
    # though it logs that it did
    if [ x$(MXE_NATIVE_MINGW_BUILD) = xyes ]; then \
      $(INSTALL) -d '$(3)$(HOST_LIBDIR)'; \
      $(INSTALL) -m644 '$(1)/libgl2ps.a' '$(3)$(HOST_LIBDIR)'; \
      $(INSTALL) -m644 '$(1)/libgl2ps.dll.a' '$(3)$(HOST_LIBDIR)'; \
      $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
      $(INSTALL) -m644 '$(1)/libgl2ps.dll' '$(3)$(HOST_BINDIR)'; \
      $(INSTALL) -d '$(3)$(HOST_INCDIR)'; \
      $(INSTALL) -m644 '$(1)/gl2ps.h' '$(3)$(HOST_INCDIR)'; \
    else \
      $(MAKE) -C '$(1)' -j 1 VERBOSE=1 DESTDIR='$(3)' install; \
      if [ $(MXE_SYSTEM) = mingw ]; then \
        echo "Install dll"; \
        $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
        $(INSTALL) '$(3)$(HOST_LIBDIR)/libgl2ps.dll' '$(3)$(HOST_BINDIR)/'; \
        rm -f '$(3)$(HOST_LIBDIR)/libgl2ps.dll'; \
      fi; \
    fi
endef
endif
