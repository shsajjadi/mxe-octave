# This file is part of MXE.
# See index.html for further information.

PKG             := texinfo
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.2
$(PKG)_CHECKSUM := dc54edfbb623d46fb400576b3da181f987e63516
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/gnu/texinfo/$($(PKG)_FILE)
$(PKG)_DEPS     := # libgnurx

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package texinfo.' >&2;
    echo $(texinfo_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)' LIBS='-lpthread -lws2_32'

    $(MAKE) -C '$(1).build' -j '$(JOBS)'

    $(MAKE) -C '$(1).build' -j '1' install DESTDIR='$(3)'
endef
