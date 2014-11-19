# This file is part of MXE.
# See index.html for further information.

PKG             := build-gawk
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 4.1.1
$(PKG)_CHECKSUM := 0480d23fffbf04bfd0d4ede4c1c3d57eb81cc771
$(PKG)_SUBDIR   := gawk-$($(PKG)_VERSION)
$(PKG)_FILE     := gawk-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/gawk/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
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
        --prefix='$(BUILD_TOOLS_PREFIX)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    $(MAKE) -C '$(1).build' -j 1 install
endef
endif
