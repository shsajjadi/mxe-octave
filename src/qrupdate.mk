# This file is part of MXE.
# See index.html for further information.

PKG             := qrupdate
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.1.2
$(PKG)_CHECKSUM := f7403b646ace20f4a2b080b4933a1e9152fac526
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := qrupdate-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := http://sourceforge.net/projects/qrupdate/files/$($(PKG)_FILE)
$(PKG)_DEPS     := blas lapack

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  $(PKG)_ENABLE_FORTRAN_INT64_CONFIGURE_OPTIONS := FFLAGS="-g -O2 -fdefault-integer-8"
endif

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_XERBLA_LIB_MAKE_OPTION := XERBLA_LIB="-lxerbla"
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package qrupdate.' >&2;
    echo $(qrupdate_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    touch '$(1)/NEWS' '$(1)/AUTHORS'
    cd '$(1)' && autoreconf -fi -I m4 -W none
    chmod a+rx '$(1)/configure'
    cd '$(1)/.build' && '$(1)/configure' \
        F77=$(MXE_F77) \
        $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
	$(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_ENABLE_FORTRAN_INT64_CONFIGURE_OPTIONS) \
          && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' \
        $($(PKG)_XERBLA_LIB_MAKE_OPTION) install DESTDIR='$(3)'
endef
