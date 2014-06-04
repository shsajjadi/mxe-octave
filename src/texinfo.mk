# This file is part of MXE.
# See index.html for further information.

PKG             := texinfo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.13a
$(PKG)_CHECKSUM := a1533cf8e03ea4fa6c443b73f4c85e4da04dead0
$(PKG)_SUBDIR   := $(PKG)-4.13
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/texinfo/$($(PKG)_FILE)
$(PKG)_DEPS     := # libgnurx

ifeq ($(MXE_SYSTEM),mingw)
    $(PKG)_DEPS += pcre
    $(PKG)_LIBS += LIBS='-lpcre -lpcreposix'
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package texinfo.' >&2;
    echo $(texinfo_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' $($(PKG)_LIBS)

    ## All we need for Octave is makeinfo
    $(MAKE) -C '$(1).build/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/gnulib/lib' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/makeinfo' -j '$(JOBS)'
    $(MAKE) -C '$(1).build/makeinfo' -j 1 install DESTDIR='$(3)'

    # octave-cli needs info to display help
    # need build native tools in order to build info
    $(MAKE) -C '$(1).build/tools/lib' -j $(JOBS) 
    $(MAKE) -C '$(1).build/tools/gnulib/lib' -j $(JOBS) 
    $(MAKE) -C '$(1).build/tools/info' -j $(JOBS) makedoc
    $(MAKE) -C '$(1).build/info' -j 1 funs.h
    $(MAKE) -C '$(1).build/info' -j '$(JOBS)' ginfo.exe
    $(INSTALL) '$(1).build/info/ginfo.exe' '$(3)$(HOST_BINDIR)/info.exe'
endef
