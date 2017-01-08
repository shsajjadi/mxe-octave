# This file is part of MXE.
# See index.html for further information.

PKG             := ghostscript
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.16
$(PKG)_CHECKSUM := cc06fbf8244b9e8d0694cee5bf3be5bdd444b888
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://downloads.ghostscript.com/public/old-gs-releases/$($(PKG)_FILE)
$(PKG)_DEPS     := jpeg lcms libpng tiff zlib
ifeq ($(MXE_WINDOWS_BUILD),no)
  ifeq ($(USE_SYSTEM_X11_LIBS),no)
    $(PKG)_DEPS += x11 xext
  endif
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    $(PKG)_DEPS += lcms
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package ghostscript.' >&2;
    echo $($(PKG)_VERSION)
endef

## Currently only works for native builds and i686 mingw cross builds.

ifeq ($(MXE_NATIVE_BUILD),yes)
  define $(PKG)_BUILD
    # force external lcm2
    mv '$(1)/lcms2' '$(1)/lcms2.x'
    # force external libpng
    mv '$(1)/libpng' '$(1)/libpng.x'
    cd '$(1)' && autoreconf
    cd '$(1)' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' \
        --with-system-libtiff \
        && $(CONFIGURE_POST_HOOK)

    if [ "$(MXE_SYSTEM)" == "mingw" ]; then \
        $(MAKE) -C '$(1)' -j '$(JOBS)' GS_LIB_DEFAULT=""; \
    else \
        $(MAKE) -C '$(1)' -j '$(JOBS)'; \
    fi
    $(MAKE) -C '$(1)' install
  endef
else
  ifeq ($(MXE_SYSTEM),mingw)
    ## Ghostscript configure script is not cross-compiler friendly,
    ## so instead of running it, copying configuration files from a
    ## native mingw build.  Some configuration is done by compiling
    ## and running programs during the build, but those programs
    ## probe the build system and don't know about cross compiling,
    ## so we generate the files then replace them with files from a
    ## mingw native build.
    ifeq ($(ENABLE_WINDOWS_64),yes)
      define $(PKG)_BUILD
        mv '$(1)/freetype' '$(1)/freetype.x'
        mv '$(1)/libpng' '$(1)/libpng.x'
        cp '$(TOP_DIR)/src/ghostscript-mingw-x86_64-makefile' '$(1)/Makefile'
        $(MAKE) -C '$(1)' TARGET='$(TARGET)' prefix='$(HOST_PREFIX)' obj/arch.h obj/gconfig_.h
        cp '$(TOP_DIR)/src/ghostscript-mingw-x86_64-arch.h' '$(1)/obj/arch.h'
        cp '$(TOP_DIR)/src/ghostscript-mingw-x86_64-arch.h' '$(1)/obj/gconfig_.h'
        $(MAKE) -C '$(1)' -j '$(JOBS)' \
          TARGET='$(TARGET)' prefix='$(HOST_PREFIX)' CC='$(MXE_CC)'
        $(MAKE) -C '$(1)' \
          TARGET='$(TARGET)' prefix='$(HOST_PREFIX)' CC='$(MXE_CC)' \
          install
      endef
    else
      define $(PKG)_BUILD
        mv '$(1)/freetype' '$(1)/freetype.x'
        cp '$(TOP_DIR)/src/ghostscript-mingw-i686-makefile' '$(1)/Makefile'
        $(MAKE) -C '$(1)' TARGET='$(TARGET)' prefix='$(HOST_PREFIX)' obj/arch.h obj/gconfig_.h
        cp '$(TOP_DIR)/src/ghostscript-mingw-i686-arch.h' '$(1)/obj/arch.h'
        cp '$(TOP_DIR)/src/ghostscript-mingw-i686-arch.h' '$(1)/obj/gconfig_.h'
        $(MAKE) -C '$(1)' -j '$(JOBS)' \
          TARGET='$(TARGET)' prefix='$(HOST_PREFIX)' CC='$(MXE_CC)'
        $(MAKE) -C '$(1)' \
          TARGET='$(TARGET)' prefix='$(HOST_PREFIX)' CC='$(MXE_CC)' \
          install
      endef
 
    endif
  endif
endif
