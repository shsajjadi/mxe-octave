# This file is part of MXE.
# See index.html for further information.

PKG             := openssl
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.2m
$(PKG)_CHECKSUM := 27fb00641260f97eaa587eb2b80fab3647f6013b
$(PKG)_SUBDIR   := openssl-$($(PKG)_VERSION)
$(PKG)_FILE     := openssl-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.openssl.org/source/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.openssl.org/source/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib libgcrypt

ifeq ($(MXE_NATIVE_BUILD),yes)
  ifeq ($(MXE_SYSTEM),msvc)
    # Specifying -I and -L inteferes with possibly old installation
    # because they appear before the standard -I. and -L. in the
    # compilation/link command. These are not needed by clgcc anyway,
    # so better discard them.
    $(PKG)_CC := $(MXE_CC)
    $(PKG)_CONFIGURE := ./Configure $(MXE_SYSTEM) --openssldir='$(HOST_PREFIX)/share/openssl'
  else
    $(PKG)_CC := $(MXE_CC) -I$(HOST_INCDIR) -L$(HOST_LIBDIR)
    $(PKG)_CONFIGURE := ./config
  endif
else
  $(PKG)_CROSS_COMPILE_MAKE_ARG := CROSS_COMPILE='$(MXE_TOOL_PREFIX)'
  $(PKG)_CC := $(MXE_CC)
  $(PKG)_RC := $(MXE_WINDRES)
  ifeq ($(TARGET),x86_64-w64-mingw32)
    $(PKG)_CONFIGURE := ./Configure mingw64
  else
    $(PKG)_CONFIGURE := ./Configure $(MXE_SYSTEM)
  endif
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.openssl.org/source/' | \
    $(SED) -n 's,.*openssl-\([0-9][0-9a-z.]*\)\.tar.*,\1,p' | \
    grep -v '^0\.9\.' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && CC='$($(PKG)_CC)' RC='$($(PKG)_RC)' \
        $($(PKG)_CONFIGURE) \
        zlib \
        shared \
        no-capieng \
        --prefix='$(HOST_PREFIX)'
    case $(MXE_SYSTEM) in \
        msvc) \
            find '$(1)' -name 'Makefile' \
                -exec $(SED) -i -e 's,\<LIB\>,_LIB,g' -e 's,\<INCLUDE\>,_INCLUDE,g' {} \; ; \
            for f in '$(1)/util/mkdef.pl' '$(1)/Makefile.shared' '$(1)/Makefile' \
                     '$(1)/engines/Makefile' '$(1)/engines/ccgost/Makefile' \
                     '$(1)/crypto/dso/dso_win32.c'; do \
                $(SED) -i -e 's/@LIBRARY_PREFIX@/$(LIBRARY_PREFIX)/g' \
                          -e 's/@LIBRARY_SUFFIX@/$(LIBRARY_SUFFIX)/g' "$$f"; \
            done ; \
            ;; \
    esac
    $(MAKE) -C '$(1)' install -j 1 \
        CC='$($(PKG)_CC)' \
        $($(PKG)_CROSS_COMPILE_MAKE_ARG) \
        RANLIB='$(MXE_RANLIB)' \
        AR='$(MXE_AR) rcu' AS='$(MXE_CCAS)' \
        MANDIR='$(HOST_PREFIX)/share/man' \
        HTMLDIR='$(HOST_PREFIX)/share/doc/openssl' \
        INSTALL_PREFIX='$(3)'

    # Remove duplicate man page to "bn_internal.3"
    rm -f $(3)$(HOST_PREFIX)/share/man/man3/bn_print.3 
endef
