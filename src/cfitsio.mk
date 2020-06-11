# This file is part of MXE.
# See index.html for further information.

PKG             := cfitsio
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3450
$(PKG)_CHECKSUM := 85b4adeba79a7691114695e6bafd6d968e68c21f
$(PKG)_SUBDIR   := $(PKG)
$(PKG)_FILE     := $(PKG)$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/$($(PKG)_FILE)
$(PKG)_DEPS     := curl

$(PKG)_MAKE_FLAGS :=
ifeq ($(BUILD_SHARED),yes)
  $(PKG)_MAKE_FLAGS += shared
endif

$(PKG)_CONFIGURE_FLAGS :=
ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_CONFIGURE_FLAGS += CURLCONFIG=none
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- "http://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/?C=M;O=D" | \
    grep -i '<a href="cfitsio.*tar' | \
    $(SED) -n 's,.*cfitsio\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    $(SED) -i 's/cfitsio\.dll/$(LIBRARY_PREFIX)cfitsio$(LIBRARY_SUFFIX).dll/g' '$(1)/makefile.vcc'
    cd '$(1)' && env -u MAKE -u MAKEFLAGS nmake -f makefile.vcc
    $(SED) -e 's#@prefix@#$(HOST_PREFIX)#' \
           -e 's#@exec_prefix@#$${prefix}#' \
           -e 's#@libdir@#$${exec_prefix}/lib#' \
           -e 's#@includedir@#$${prefix}/include#' \
           -e 's#@LIBS@##' \
           -e '/^Libs\.private:/ { s#-lm\>##; }' \
           -e 's#@CFITSIO_MAJOR@#$(word 1,$(subst ., ,$($(PKG)_VERSION)))#' \
           -e 's#@CFITSIO_MINOR@#$(word 2,$(subst ., ,$($(PKG)_VERSION)))#' \
           '$(1)/cfitsio.pc.in' > '$(1)/cfitsio.pc'
    $(INSTALL) -d '$(HOST_BINDIR)'
    $(INSTALL) '$(1)/$(LIBRARY_PREFIX)cfitsio$(LIBRARY_SUFFIX).dll' '$(HOST_BINDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) '$(1)/cfitsio.lib' '$(HOST_LIBDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)/pkgconfig'
    $(INSTALL) '$(1)/cfitsio.pc' '$(HOST_LIBDIR)/pkgconfig'
    $(INSTALL) -d '$(HOST_INCDIR)'
    for f in fitsio.h fitsio2.h longnam.h drvrsmem.h; do \
        $(INSTALL) "$(1)/$$f" '$(HOST_INCDIR)'; \
    done
endef
else
define $(PKG)_BUILD
    cd '$(1)' && autoreconf -fi && '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
	$($(PKG)_CONFIGURE_FLAGS) \
        --prefix='$(HOST_PREFIX)' 
    $(MAKE) -C '$(1)' -j '$(JOBS)' $($(PKG)_MAKE_FLAGS)
    $(MAKE) -C '$(1)' -j 1 install

    if [ "$(MXE_SYSTEM)" == "mingw" ]; then \
        $(INSTALL) '$(1)/libcfitsio$(LIBRARY_SUFFIX).dll' '$(HOST_BINDIR)'; \
	rm -f $(HOST_LIBDIR)/libcfitsio$(LIBRARY_SUFFIX).dll; \
    fi
endef
endif
