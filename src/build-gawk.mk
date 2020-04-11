# This file is part of MXE.
# See index.html for further information.

PKG             := build-gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.1
$(PKG)_CHECKSUM := 4ad1a3e5d016b5484bcbcbf866d73967c4af1b5e
$(PKG)_SUBDIR   := gawk-$($(PKG)_VERSION)
$(PKG)_FILE     := gawk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gawk/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://ftp.gnu.org/gnu/gawk/?C=M;O=D' | \
    $(SED) -n 's,.*<a href="gawk-\([0-9\.]*\)\.tar.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
define $(PKG)_BUILD
    # copy from pc folder
    cp    '$(1)'/pc/*.* '$(1)'
    cp    '$(1)/pc/Makefile' '$(1)'
    cp    '$(1)/pc/Makefile.ext' '$(1)/extension/Makefile'
    cp    '$(1)/pc/Makefile.tst' '$(1)/test/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)' mingw32
    $(MAKE) -C '$(1)/extension' -j '$(JOBS)' 
    $(MAKE) -C '$(1)' -j 1 install prefix=$(BUILD_TOOLS_PREFIX) 
endef
else
define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
	--disable-shared \
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
endif
