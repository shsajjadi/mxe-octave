# This file is part of MXE.
# See index.html for further information.

PKG             := bzip2
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 3f89f861209ce81a6bab1fd1998c0ef311712002
$(PKG)_SUBDIR   := bzip2-$($(PKG)_VERSION)
$(PKG)_FILE     := bzip2-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://www.bzip.org/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://www.bzip.org/downloads.html' | \
    grep 'bzip2-' | \
    $(SED) -n 's,.*bzip2-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

ifeq ($(MXE_SYSTEM),mingw)
define $(PKG)_BUILD
    $(SED) -i 's,sys\\stat\.h,sys/stat.h,g' '$(1)/bzip2.c'
    $(SED) -i 's,WINAPI,,g'                 '$(1)/bzlib.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' libbz2.a \
        PREFIX='$(HOST_PREFIX)' \
        CC='$(MXE_CC)' \
        AR='$(MXE_AR)' \
        RANLIB='$(MXE_RANLIB)'
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/bzlib.h' '$(HOST_INCDIR)'

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(TARGET)-ar' --ld '$(TARGET)-gcc' '$(1)/libbz2.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
    fi

    if [ $(BUILD_STATIC) = yes ]; then \
      $(INSTALL) '$(1)/libbz2.a' '$(HOST_LIBDIR)/'; \
    fi
endef
else
define $(PKG)_BUILD
    $(SED) -i 's,sys\\stat\.h,sys/stat.h,g' '$(1)/bzip2.c'
    $(SED) -i 's,WINAPI,,g'                 '$(1)/bzlib.h'
    $(MAKE) -C '$(1)' -j '$(JOBS)' -f Makefile-libbz2_so \
        PREFIX='$(HOST_PREFIX)' \
        CC='$(MXE_CC)' \
        AR='$(MXE_AR)' \
        RANLIB='$(MXE_RANLIB)'
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m755 '$(1)/libbz2.so.1.0.6' '$(HOST_LIBDIR)'
    rm -f '$(HOST_LIBDIR)/libbz2.so.1.0'
    $(LN_SF) libbz2.so.1.0.6 '$(HOST_LIBDIR)/libbz2.so.1.0'
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/bzlib.h' '$(HOST_INCDIR)'
endef
endif
