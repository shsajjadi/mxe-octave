# This file is part of MXE.
# See index.html for further information.

PKG             := ghostscript
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.07
$(PKG)_CHECKSUM := 550a85e73b7213d8ae41ea06523661638b4bc1a2
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://downloads.ghostscript.com/public/$($(PKG)_FILE)
$(PKG)_DEPS     := jpeg lcms libpng tiff zlib
ifeq ($(MXE_WINDOWS_BUILD),no)
  $(PKG)_DEPS += x11 xext
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
    # in native mingw, force it to use external lcm2
    if [ "$(MXE_SYSTEM)" == "mingw" ]; then \
        rm -rf '$(1)/lcms2'; \
    fi
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
    ifneq ($(ENABLE_64),yes)
      ## Ghostscript configure script is not cross-compiler friendly,
      ## so instead of running it, copying configuration files from a
      ## native mingw build.  Some configuration is done by compiling
      ## and running programs during the build, but those programs
      ## probe the build system and don't know about cross compiling,
      ## so we generate the files then replace them with files from a
      ## mingw native build.
      define $(PKG)_BUILD
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
