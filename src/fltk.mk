# This file is part of MXE.
# See index.html for further information.

PKG             := fltk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.3.2
$(PKG)_CHECKSUM := 25071d6bb81cc136a449825bfd574094b48f07fb
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR)-source.tar.gz
$(PKG)_URL      := http://fltk.org/pub/fltk/$($(PKG)_VERSION)/$($(PKG)_FILE)
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_DEPS   := zlib jpeg libpng pthreads uuid
else
ifeq ($(MXE_SYSTEM),msvc)
  $(PKG)_DEPS   := zlib jpeg libpng freetype
else
  $(PKG)_DEPS   := zlib jpeg libpng pthreads freetype
endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
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
    $(SED) -i 's,-fno-exceptions,,' '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install \
        DIRS=src \
        LIBCOMMAND='$(MXE_AR) cr' \
        DESTDIR='$(3)'
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(INSTALL) -d '$(3)$(BUILD_TOOLS_PREFIX)/bin'; \
      $(INSTALL) -m755 '$(3)$(HOST_BINDIR)/fltk-config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)fltk-config'; \
    fi
endef
