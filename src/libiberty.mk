# This file is part of MXE.
# See index.html for further information.

PKG             := libiberty
$(PKG)_IGNORE    = $(build-binutils_IGNORE)
$(PKG)_VERSION  := 2.34
$(PKG)_CHECKSUM  = $(build-binutils_CHECKSUM)
$(PKG)_SUBDIR    = $(build-binutils_SUBDIR)/libiberty
$(PKG)_FILE      = $(build-binutils_FILE)
$(PKG)_URL       = $(build-binutils_URL)
$(PKG)_URL_2     = $(build-binutils_URL_2)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo $(build-binutils_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && ./configure \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --enable-install-libiberty
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install target_header_dir=libiberty

    #'$(MXE_CC)' \
    #    -W -Wall -Werror -ansi -pedantic \
    #    '$(2).c' -o '$(HOST_BINDIR)/test-libiberty.exe' \
    #    -I$(HOST_INCDIR)/libiberty -liberty
endef
