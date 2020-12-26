# This file is part of MXE.
# See index.html for further information.

PKG             := freeimage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.15.4
$(PKG)_CHECKSUM := 1d30057a127b2016cf9b4f0f8f2ba92547670f96
$(PKG)_SUBDIR   := FreeImage
$(PKG)_FILE     := FreeImage$(subst .,,$($(PKG)_VERSION)).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeimage/Source Distribution/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/freeimage/files/Source Distribution/' | \
    $(SED) -n 's,.*tr title="\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,install ,$(INSTALL) ,' '$(1)'/Makefile.gnu

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.gnu \
        CXX='$(MXE_CXX)' \
        CC='$(MXE_CC)' \
        AR='$(MXE_AR)' \
        INCDIR='$(HOST_INCDIR)' \
        INSTALLDIR='$(HOST_LIBDIR)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.gnu install \
        CXX='$(MXE_CXX)' \
        CC='$(MXE_CC)' \
        AR='$(MXE_AR)' \
        INCDIR='$(HOST_INCDIR)' \
        INSTALLDIR='$(HOST_LIBDIR)'
endef
