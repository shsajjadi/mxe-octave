# This file is part of MXE.
# See index.html for further information.

PKG             := boost
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := cddd6b4526a09152ddc5db856463eaa1dc29c5d9
$(PKG)_SUBDIR   := boost_$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := boost_$(subst .,_,$($(PKG)_VERSION)).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/boost/boost/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 expat

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.boost.org/users/download/' | \
    $(SED) -n 's,.*/boost/\([0-9][^"/]*\)/".*,\1,p' | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    # context switched library introduced in boost 1.51.0 does not build
    rm -r '$(1)/libs/context'
    # old version appears to interfere
    rm -rf '$(HOST_PREFIX)/include/boost/'
    echo 'using gcc : : $(TARGET)-g++ : <rc>$(TARGET)-windres <archiver>$(TARGET)-ar ;' > '$(1)/user-config.jam'
    # compile boost jam
    cd '$(1)/tools/build/v2/engine' && ./build.sh
    cd '$(1)' && tools/build/v2/engine/bin.*/bjam \
        -j '$(JOBS)' \
        --ignore-site-config \
        --user-config=user-config.jam \
        target-os=windows \
        threading=multi \
        link=static \
        threadapi=win32 \
        --layout=tagged \
        --without-mpi \
        --without-python \
        --prefix='$(HOST_PREFIX)' \
        --exec-prefix='$(HOST_PREFIX)/bin' \
        --libdir='$(HOST_PREFIX)/lib' \
        --includedir='$(HOST_PREFIX)/include' \
        -sEXPAT_INCLUDE='$(HOST_PREFIX)/include' \
        -sEXPAT_LIBPATH='$(HOST_PREFIX)/lib' \
        stage install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -U__STRICT_ANSI__ -pedantic \
        '$(2).cpp' -o '$(HOST_PREFIX)/bin/test-boost.exe' \
        -DBOOST_THREAD_USE_LIB \
        -lboost_serialization-mt \
        -lboost_thread_win32-mt \
        -lboost_system-mt \
        -lboost_chrono-mt
endef
