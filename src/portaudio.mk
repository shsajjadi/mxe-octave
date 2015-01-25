# This file is part of MXE.
# See index.html for further information.

PKG             := portaudio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 19_20140130
$(PKG)_CHECKSUM := 526a7955de59016a06680ac24209ecb6ce05527d
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
    # libtool looks for a pei* format when linking shared libs
    # apparently there's no real difference b/w pei and pe
    # so we set the libtool cache variables
    # https://sourceware.org/cgi-bin/cvsweb.cgi/src/bfd/libpei.h?annotate=1.25&cvsroot=src
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix='$(HOST_PREFIX)'
        $(ENABLE_SHARED_OR_STATIC) \
        --with-host_os=mingw \
        --with-winapi=wmme,directx \
        --with-dxdir=$(HOST_PREFIX) \
        ac_cv_path_AR=$(MXE_AR) \
        $(if $(filter $(BUILD_SHARED),yes),\
            lt_cv_deplibs_check_method='file_magic file format (pe-i386|pe-x86-64)' \
            lt_cv_file_magic_cmd='$$OBJDUMP -f')
    $(MAKE) -C '$(1)' -j '$(JOBS)' $(if $(filter $(BUILD_STATIC),yes),SHARED_FLAGS=) TESTS=
    $(MAKE) -C '$(1)' -j 1 install

endef

