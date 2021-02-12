# This file is part of MXE.
# See index.html for further information.

PKG             := fltk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.5
$(PKG)_CHECKSUM := d0ea44a68a9424d9e7d1ff9985d9c510b9ee2b75
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR)-source.tar.gz
$(PKG)_URL      := http://fltk.org/pub/fltk/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib jpeg libpng
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_DEPS   += pthreads uuid
else ifeq ($(MXE_SYSTEM),msvc)
  $(PKG)_DEPS   += freetype
else
  $(PKG)_DEPS   += pthreads freetype
  ifeq ($(USE_SYSTEM_X11_LIBS),no)
    $(PKG)_DEPS += x11 xcursor xext xrender xdmcp
  endif
endif
ifeq ($(USE_SYSTEM_OPENGL),no)
  $(PKG)_DEPS += mesa glu
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>\([0-9][^<]*\)<.*,\1,p' | \
    grep -v '^1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    if [ $(MXE_SYSTEM) = msvc ]; then \
        for f in '$(1)/configure.in' '$(1)/src/Makefile'; do \
            $(SED) -i -e 's/@@LIBRARY_PREFIX@@/$(LIBRARY_PREFIX)/g' \
                      -e 's/@@LIBRARY_SUFFIX@@/$(LIBRARY_SUFFIX)/g' $$f; \
        done; \
    fi
    cd '$(1)' && autoconf
##    $(SED) -i 's,\$$uname,MINGW,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
	DSOFLAGS='-L$(HOST_LIBDIR)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads
##        LIBS='-lws2_32'
    # enable exceptions, because disabling them doesn't make any sense on PCs
    $(SED) -i 's/-fno-exceptions//; s/-Wl,-gc-sections//; s/-fvisibility=hidden//' '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        DIRS=src \
        LIBCOMMAND='$(MXE_AR) cr' \
        DESTDIR='$(3)'
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/fltk-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)fltk-config'; \
    fi
endef
