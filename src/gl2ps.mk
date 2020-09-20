# This file is part of MXE.
# See index.html for further information.

PKG             := gl2ps
$(PKG)_VERSION  := 1.4.2
$(PKG)_CHECKSUM := ee1eb8972e9d07bbe325552e4ec15d6828e8197c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://geuz.org/$(PKG)/src/$($(PKG)_FILE)
$(PKG)_DEPS     := libpng zlib
ifeq ($(USE_SYSTEM_OPENGL),no)
  $(PKG)_DEPS += mesa glu
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    ifeq ($(MXE_SYSTEM),msvc)
        $(PKG)_CMAKE_FLAGS := -G 'NMake Makefiles'
    endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://gitlab.onelab.info/gl2ps/gl2ps/-/tags' | \
        $(SED) -n 's/.*>gl2ps_\([0-9]\)_\([0-9]\)_\([0-9]\)<.*/\1\.\2\.\3/p' | \
        $(SORT) -V | tail -1
endef

ifeq ($(MXE_SYSTEM),msvc)
    define $(PKG)_BUILD
        cd '$(1)' && cmake \
            $($(PKG)_CMAKE_FLAGS) \
            $(CMAKE_CCACHE_FLAGS) \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
            -DPNG_NAMES=png16 \
            .
        cd '$(1)' && env -u MAKE -u MAKEFLAGS nmake
        cd '$(1)' && env -u MAKE -u MAKEFLAGS nmake DESTDIR='$(3)' install
    endef
else ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
    define $(PKG)_BUILD
        mkdir '$(1)/.build'
        cd '$(1)' && autoreconf --force
        cd '$(1)/.build' && ../configure \
            $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
            $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
            $(ENABLE_SHARED_OR_STATIC) \
            --prefix='$(HOST_PREFIX)' \
            LIBS=-lopengl32 \
            && $(CONFIGURE_POST_HOOK)
        $(MAKE) -C '$(1)/.build' -j '$(JOBS)' LDFLAGS='-no-undefined -L$(HOST_LIBDIR)'
        $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)'
    endef
else
    ifeq ($(MXE_SYSTEM),mingw)
        define $(PKG)_BUILD
            cd '$(1)' && cmake \
                $($(PKG)_CMAKE_FLAGS) \
                $(CMAKE_CCACHE_FLAGS) \
                -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
                .
            $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1 

            # native mingw build doesnt want to install the files, even
            # though it logs that it did
            if [ x$(MXE_NATIVE_MINGW_BUILD) = xyes ]; then \
                $(INSTALL) -d '$(3)$(HOST_LIBDIR)'; \
                $(INSTALL) -m644 '$(1)/libgl2ps.a' '$(3)$(HOST_LIBDIR)'; \
                $(INSTALL) -m644 '$(1)/libgl2ps.dll.a' '$(3)$(HOST_LIBDIR)'; \
                $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
                $(INSTALL) -m644 '$(1)/libgl2ps.dll' '$(3)$(HOST_BINDIR)'; \
                $(INSTALL) -d '$(3)$(HOST_INCDIR)'; \
                $(INSTALL) -m644 '$(1)/gl2ps.h' '$(3)$(HOST_INCDIR)'; \
            else \
                $(MAKE) -C '$(1)' -j 1 VERBOSE=1 DESTDIR='$(3)' install; \
                if [ $(MXE_SYSTEM) = mingw ]; then \
                    echo "Install dll"; \
                    $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
                    $(INSTALL) '$(3)$(HOST_LIBDIR)/libgl2ps.dll' '$(3)$(HOST_BINDIR)/'; \
                    rm -f '$(3)$(HOST_LIBDIR)/libgl2ps.dll'; \
                fi; \
            fi
        endef
    else
        define $(PKG)_BUILD
            mkdir '$(1)/.build'
            cd '$(1)' && aclocal && libtoolize && autoreconf --force
            cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
                $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
                $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
                --prefix='$(HOST_PREFIX)' \
                && $(CONFIGURE_POST_HOOK)

            $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
            $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)'
        endef
    endif
endif


