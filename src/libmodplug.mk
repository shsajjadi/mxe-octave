# This file is part of MXE.
# See index.html for further information.

# libmodplug
PKG             := libmodplug
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.8.8.4
$(PKG)_CHECKSUM := df4deffe542b501070ccb0aee37d875ebb0c9e22
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/modplug-xmms/$(PKG)/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/modplug-xmms/files/libmodplug/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install

    '$(MXE_CC)' \
        -W -Wall -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-libmodplug.exe' \
        `'$(MXE_PKG_CONFIG)' libmodplug --cflags --libs`
endef
