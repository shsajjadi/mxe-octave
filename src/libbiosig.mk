# This file is part of MXE.
# See index.html for further information.

PKG             := libbiosig
$(PKG)_WEBSITE  := http://biosig.sf.net/
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.2.1
$(PKG)_CHECKSUM := f16bfc7e0f05901e09283020d7cd565bed13c75e
$(PKG)_SUBDIR   := biosig-$($(PKG)_VERSION)
$(PKG)_FILE     := biosig-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := https://sourceforge.net/projects/biosig/files/BioSig%20for%20C_C%2B%2B/src/$($(PKG)_FILE)
$(PKG)_DEPS     := suitesparse zlib libb64 libiberty libiconv lapack tinyxml dcmtk

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://biosig.sourceforge.io/download.html' | \
        $(SED) -n 's_.*>v\([0-9]\.[0-9]\.[0-9]\)<.*_\1_p' | \
        head -1
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_MAKE_FLAGS := TARGET=$(TARGET) CROSS=$(TARGET)
  $(PKG)_AUTOCONF_CROSS_FLAGS := \
    ac_cv_func_malloc_0_nonnull=yes \
    ac_cv_func_realloc_0_nonnull=yes
else
  $(PKG)_MAKE_FLAGS := \
  LDLIBS='-liconv -lm -ltinyxml' \
  LDFLAGS=$(MXE_LDFLAGS) \
  CFLAGS=$(MXE_CFLAGS)
endif


define $(PKG)_BUILD
  cd '$(1)' && ./configure \
    $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
    $($(PKG)_AUTOCONF_CROSS_FLAGS) \
    --prefix=$(HOST_PREFIX) \
    CC='$(MXE_CC)' \
    CXX='$(MXE_CXX)' \
    RANLIB='$(MXE_RANLIB)' \
    AR='$(MXE_AR)' \
    ARFLAGS=rcs \
    LDFLAGS=$(MXE_LDFLAGS) \
    CFLAGS=$(MXE_CFLAGS) \
    LIBTOOL=$(LIBTOOL) \
    PKG_CONFIG='$(MXE_PKG_CONFIG)' \
    PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig'

  # make sure NDEBUG is defined
  $(SED) -i '/NDEBUG/ s|#||g' '$(1)'/biosig4c++/Makefile

  $($(PKG)_MAKE_FLAGS) $(MAKE) -C '$(1)' lib tools
  $($(PKG)_MAKE_FLAGS) $(MAKE) -C '$(1)/biosig4c++' install DESTDIR='$(3)'

  # FIXME: These files aren't installed by the Makefile rule.
  # Do we really need them?
  if [ "x$(MXE_SYSTEM)" == "xmingw" ]; then \
    $(INSTALL) '$(1)/biosig4c++/libbiosig.dll.a' '$(3)$(HOST_LIBDIR)'; \
    $(INSTALL) '$(1)/biosig4c++/libgdf.dll' '$(3)$(HOST_BINDIR)'; \
    $(INSTALL) '$(1)/biosig4c++/libgdf.dll.a' '$(3)$(HOST_LIBDIR)'; \
    $(INSTALL) '$(1)/biosig4c++/libphysicalunits.dll' '$(3)$(HOST_BINDIR)'; \
    $(INSTALL) '$(1)/biosig4c++/libphysicalunits.dll.a' '$(3)$(HOST_LIBDIR)'; \
  fi
endef

