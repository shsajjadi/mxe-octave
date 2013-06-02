# This file is part of MXE.
# See index.html for further information.

PKG             := fltk
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 717242e8aa118020cc05aa788015a2933895b99c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR)-source.tar.gz
$(PKG)_URL      := http://fltk.org/pub/fltk/$($(PKG)_VERSION)/$($(PKG)_FILE)
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_DEPS   := gcc zlib jpeg libpng pthreads uuid
else
  $(PKG)_DEPS   := gcc zlib jpeg libpng pthreads freetype
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.fltk.org/' | \
    $(SED) -n 's,.*>v\([0-9][^<]*\)<.*,\1,p' | \
    grep -v '^1\.1\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
##    $(SED) -i 's,\$$uname,MINGW,g' '$(1)/configure'
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
	DSOFLAGS='-L$(HOST_PREFIX)/lib' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-threads
##        LIBS='-lws2_32'
    # enable exceptions, because disabling them doesn't make any sense on PCs
    $(SED) -i 's,-fno-exceptions,,' '$(1)/makeinclude'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install DIRS=src LIBCOMMAND='$(MXE_AR) cr'
    $(LN_SF) '$(MXE_BINDIR)/fltk-config' '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-fltk-config'
endef
