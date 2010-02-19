# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# FreeImage
PKG             := freeimage
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.13.1
$(PKG)_CHECKSUM := 52ba4453aa9682c57104c3420e58f843aaa6ab61
$(PKG)_SUBDIR   := FreeImage
$(PKG)_FILE     := FreeImage$(subst .,,$($(PKG)_VERSION)).zip
$(PKG)_WEBSITE  := http://freeimage.sourceforge.net/
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/freeimage/Source Distribution/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(call SOURCEFORGE_FILES,http://sourceforge.net/projects/freeimage/files/) | \
    $(SED) -n 's,.*/\([0-9][^>]*\)/FreeImage.*,\1,p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,install ,$(INSTALL) ,' '$(1)'/Makefile.gnu

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.gnu \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        INCDIR='$(PREFIX)/$(TARGET)/include' \
        INSTALLDIR='$(PREFIX)/$(TARGET)/lib'

    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile.gnu install \
        CXX='$(TARGET)-g++' \
        CC='$(TARGET)-gcc' \
        AR='$(TARGET)-ar' \
        INCDIR='$(PREFIX)/$(TARGET)/include' \
        INSTALLDIR='$(PREFIX)/$(TARGET)/lib'
endef
