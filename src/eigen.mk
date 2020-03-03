# This file is part of MXE.
# See index.html for further information.

PKG             := eigen
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.3.7
$(PKG)_CHECKSUM := 743c1dc00c6680229d8cc87d44debe5a71d15c01
$(PKG)_SUBDIR   := $(PKG)-$(PKG)-323c052e1731
$(PKG)_FILE     := $($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://bitbucket.org/$(PKG)/$(PKG)/get/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://bitbucket.org/$(PKG)/$(PKG)/downloads/?tab=tags' | \
    $(SED) -n 's|.*href=\"/eigen/eigen/get/\([0-9].*\)\.tar\.gz\".*|\1|p' | \
    $(GREP) -v "tip" | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && \
    cmake -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' DESTDIR='$(3)' install
endef
