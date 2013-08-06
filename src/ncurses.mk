# This file is part of MXE.
# See index.html for further information.

# ncurses
PKG             := ncurses
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3e042e5f2c7223bffdaac9646a533b8c758b65b5
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

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --prefix=$(HOST_PREFIX) \
        --disable-home-terminfo \
        --enable-sp-funcs \
        --enable-term-driver \
        --enable-interop \
        --without-debug \
        --without-ada \
        --without-manpages \
        --enable-pc-files \
        CONFIG_SITE=/dev/null \
        $($(PKG)_CONFIG_OPTS)

    # MSVC generates invalid code in panel library when using -O2
    # command-line flag. Bug is reported. Disable optimization for
    # the time being.
    if test x$(MXE_SYSTEM) = xmsvc; then \
        find '$(1)' -name Makefile \
            -exec $(SED) -i 's,-\<O2\>,,' {} \; ; \
    fi

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
endef
