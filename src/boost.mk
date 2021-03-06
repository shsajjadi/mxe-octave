# This file is part of MXE.
# See index.html for further information.

PKG             := boost
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.53.0
$(PKG)_CHECKSUM := e6dd1b62ceed0a51add3dda6f3fc3ce0f636a7f3
$(PKG)_SUBDIR   := boost_$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := boost_$(subst .,_,$($(PKG)_VERSION)).tar.bz2
$(PKG)_URL      := https://$(SOURCEFORGE_MIRROR)/project/boost/boost/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib bzip2 expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://sourceforge.net/projects/boost/files/boost/' | \
    $(SED) -n 's,.*/boost/\([0-9][^"/]*\)/".*,\1,p' | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    # context switched library introduced in boost 1.51.0 does not build
    rm -r '$(1)/libs/context'
    # old version appears to interfere
    rm -rf '$(HOST_INCDIR)/boost/'
    echo 'using gcc : : $(MXE_CXX) : <rc>$(MXE_WINDRES) <archiver>$(MXE_AR) <ranlib>$(MXE_RANDLIB) ;' > '$(1)/user-config.jam'
    # compile boost jam
    cd '$(1)/tools/build/v2/engine' && ./build.sh
    cd '$(1)' && tools/build/v2/engine/bin.*/bjam \
        -j '$(JOBS)' \
        --ignore-site-config \
        --user-config=user-config.jam \
        target-os=windows \
        threading=multi \
        link=$(if $(filter $(BUILD_STATIC),,yes),static,shared) \
        threadapi=win32 \
        --layout=tagged \
        --disable-icu \
        --without-mpi \
        --without-python \
        --prefix='$(HOST_PREFIX)' \
        --exec-prefix='$(HOST_BINDIR)' \
        --libdir='$(HOST_LIBDIR)' \
        --includedir='$(HOST_INCDIR)' \
        -sEXPAT_INCLUDE='$(HOST_INCDIR)' \
        -sEXPAT_LIBPATH='$(HOST_LIBDIR)' \
        stage install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -U__STRICT_ANSI__ -pedantic \
        '$(2).cpp' -o '$(1)/test-boost.exe' \
        -DBOOST_THREAD_USE_LIB \
        -lboost_serialization-mt \
        -lboost_thread_win32-mt \
        -lboost_system-mt \
        -lboost_chrono-mt
endef
