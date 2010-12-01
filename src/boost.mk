# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# Boost C++ Library
PKG             := boost
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.45.0
$(PKG)_CHECKSUM := eb7424ef99df4e38af7431e38ff9849651b8aaf5
$(PKG)_SUBDIR   := boost_$(subst .,_,$($(PKG)_VERSION))
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.bz2
$(PKG)_WEBSITE  := http://www.boost.org/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/boost/boost/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib bzip2 expat

define $(PKG)_UPDATE
    wget -q -O- 'http://sourceforge.net/projects/boost/files/boost/?sort=date&sortdir=desc' | \
    $(SED) -n 's,.*/\([0-9][^"]*\)/".*,\1,p' | \
    grep -v beta | \
    head -1
endef

define $(PKG)_BUILD
    echo 'using gcc : : $(TARGET)-g++ : <rc>$(TARGET)-windres <archiver>$(TARGET)-ar ;' > '$(1)/user-config.jam'
    # make the build script generate .a library files instead of .lib
    $(SED) -i 's,<target-os>windows : lib ;,<target-os>windows : a ;,' '$(1)/tools/build/v2/tools/types/lib.jam'
    # compile boost jam
    cd '$(1)/tools/build/v2/engine/src' && ./build.sh
    cd '$(1)' && tools/build/v2/engine/src/bin.*/bjam \
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
        --prefix='$(PREFIX)/$(TARGET)' \
        --exec-prefix='$(PREFIX)/$(TARGET)/bin' \
        --libdir='$(PREFIX)/$(TARGET)/lib' \
        --includedir='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_INCLUDE='$(PREFIX)/$(TARGET)/include' \
        -sEXPAT_LIBPATH='$(PREFIX)/$(TARGET)/lib' \
        stage install

    '$(TARGET)-g++' \
        -W -Wall -Werror -ansi -U__STRICT_ANSI__ -pedantic \
        '$(2).cpp' -o '$(PREFIX)/$(TARGET)/bin/test-boost.exe' \
        -DBOOST_THREAD_USE_LIB \
        -lboost_serialization-mt -lboost_thread_win32-mt
endef
