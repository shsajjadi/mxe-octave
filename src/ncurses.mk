# This file is part of MXE.
# See index.html for further information.

# ncurses
PKG             := ncurses
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 6.1
$(PKG)_CHECKSUM := 57acf6bc24cacd651d82541929f726f4def780cc
$(PKG)_SUBDIR   := ncurses-$($(PKG)_VERSION)
$(PKG)_FILE     := ncurses-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://ftp.gnu.org/pub/gnu/ncurses/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/pub/gnu/ncurses/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="ncurses-\([0-9][^"]*\)\.tar.*,\1,p' | \
    head -1
endef

ifeq ($(MXE_SYSTEM),msvc)
  $(PKG)_CONFIG_OPTS := \
    --without-normal \
    --with-shared \
    --with-libtool
else
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_CONFIG_OPTS := --with-normal --without-shared
else
  $(PKG)_CONFIG_OPTS := --with-normal $(WITH_SHARED_OR_STATIC)
endif
endif

$(PKG)_COMMON_CONFIG_OPTS := \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix=$(HOST_PREFIX) \
        --disable-home-terminfo \
        --enable-sp-funcs \
        --enable-interop \
        --without-debug \
        --without-ada \
        --without-manpages \
        --enable-pc-files \
        CONFIG_SITE=/dev/null \
        $($(PKG)_CONFIG_OPTS)

define $(PKG)_BUILD

    ## Normal char version:

    mkdir '$(1)/.build' && cd '$(1)/.build' && ../configure \
        $($(PKG)_COMMON_CONFIG_OPTS)

    # MSVC generates invalid code in panel library when using -O2
    # command-line flag. Bug is reported. Disable optimization for
    # the time being.
    if test x$(MXE_SYSTEM) = xmsvc; then \
        find '$(1)/.build' -name Makefile \
            -exec $(SED) -i 's,-\<O2\>,,' {} \; ; \
    fi

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'

    ## Wide char version:

    mkdir '$(1)/.build-widec' && cd '$(1)/.build-widec' && ../configure \
        --enable-widec \
        $($(PKG)_COMMON_CONFIG_OPTS)

    # MSVC generates invalid code in panel library when using -O2
    # command-line flag. Bug is reported. Disable optimization for
    # the time being.
    if test x$(MXE_SYSTEM) = xmsvc; then \
        find '$(1)/.build-widec' -name Makefile \
            -exec $(SED) -i 's,-\<O2\>,,' {} \; ; \
    fi

    $(MAKE) -C '$(1)/.build-widec' -j '$(JOBS)' install DESTDIR='$(3)'

endef
