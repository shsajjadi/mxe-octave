# This file is part of MXE.
# See index.html for further information.

PKG             := rtmidi
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.0.0
$(PKG)_CHECKSUM := 227513d9087d95e171ccf42c7b7e2fe9c5040e27
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.gz
$(PKG)_URL      := https://github.com/thestk/$(PKG)/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     :=

$(PKG)_CMAKE_FLAGS :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/thestk/$(PKG)/tags' | \
    $(SED) -n 's|.*releases/tag/[v]\{0,1\}\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    
    cd '$(1)' && ./autogen.sh --no-configure && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
	ac_cv_prog_DOXYGEN= \
        --prefix='$(HOST_PREFIX)' \
        && $(CONFIGURE_POST_HOOK)
 
    $(MAKE) -C '$(1)' -j '$(JOBS)' noinst_PROGRAMS=  $(MXE_DISABLE_DOCS)
    if [ "$(MXE_WINDOWS_BUILD)" == "no" ]; then \
        $(SED) -i 's,^Requires,PrivateRequires,' '$(1)/rtmidi.pc'; \
    fi
    $(MAKE) -C '$(1)' -j '1' noinst_PROGRAMS= DESTDIR='$(3)'  $(MXE_DISABLE_DOCS) install
endef
