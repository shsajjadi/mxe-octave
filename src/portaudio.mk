# This file is part of MXE.
# See index.html for further information.

PKG             := portaudio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 19_20111121
$(PKG)_CHECKSUM := f07716c470603729a55b70f5af68f4a6807097eb
$(PKG)_SUBDIR   := portaudio
$(PKG)_FILE     := pa_stable_v$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.portaudio.com/archives/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.portaudio.com/download.html' | \
    $(SED) -n 's,.*pa_stable_v\([0-9][^>]*\)\.tgz.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --with-host_os=mingw \
        --with-winapi=wmme,directx,wasapi,wdmks \
        --with-dxdir=$(HOST_PREFIX) \
        ac_cv_path_AR=$(MXE_AR)
    $(MAKE) -C '$(1)' -j '$(JOBS)' SHARED_FLAGS= TESTS=
    $(MAKE) -C '$(1)' -j 1 install

    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-portaudio.exe' \
        `'$(MXE_PKG_CONFIG)' portaudio-2.0 --cflags --libs`
endef
