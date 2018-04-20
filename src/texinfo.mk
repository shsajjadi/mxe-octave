# This file is part of MXE.
# See index.html for further information.

PKG             := texinfo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.5
$(PKG)_CHECKSUM := 0f8e69781e28ec102b6a9487b093c440f5bb8545
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/texinfo/$($(PKG)_FILE)
$(PKG)_DEPS     := # libgnurx

ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_DEPS += pcre
    $(PKG)_LIBS += LIBS='-lpcre -lpcreposix -lpthread'
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package texinfo.' >&2;
    echo $(texinfo_VERSION)
endef

ifeq ($(MXE_NATIVE_BUILD),yes)
  ## We already have texinfo from the build-texinfo package.
  define $(PKG)_BUILD
  endef
else
  define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' $($(PKG)_LIBS)

    ## All we need for Octave is makeinfo
    $(MAKE) -C '$(1).build/gnulib/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/util' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/tp' -j '$(JOBS)'

    $(SED) -i '1 s|^.*$$|#! /usr/bin/env perl|' '$(1).build/tp/texi2any' '$(1).build/util/txixml2texi'

    $(MAKE) -C '$(1).build/tp' -j 1 install DESTDIR='$(3)'
    $(MAKE) -C '$(1).build/util' -j 1 install DESTDIR='$(3)'

    # octave-cli needs info to display help
    # for cross build, need build native tools in order to build info
    if [ "x$(MXE_NATIVE_BUILD)" = "xyes" ]; then \
        $(MAKE) -C '$(1).build/info' -j '$(JOBS)'; \
        $(MAKE) -C '$(1).build/info' -j 1 install DESTDIR='$(3)'; \
    else \
        $(MAKE) -C '$(1).build/tools/gnulib/lib' -j $(JOBS); \
        $(MAKE) -C '$(1).build/tools/info' -j $(JOBS) makedoc; \
        $(MAKE) -C '$(1).build/info' -j 1 funs.h; \
        $(MAKE) -C '$(1).build/info' -j '$(JOBS)' ginfo.exe; \
        $(INSTALL) '$(1).build/info/ginfo.exe' '$(3)$(HOST_BINDIR)/info.exe'; \
    fi
  endef
endif
