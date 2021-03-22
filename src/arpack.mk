# This file is part of MXE.
# See index.html for further information.

PKG             := arpack
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.7.0
$(PKG)_CHECKSUM := cb5a6e1f3c5ab231440bbe30f4a0808d76215e93
$(PKG)_SUBDIR   := $(PKG)-ng-$($(PKG)_VERSION)
$(PKG)_FILE     := arpack-ng_$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/opencollab/arpack-ng/archive/$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := blas lapack
$(PKG)_DESTDIR  := '$(3)'

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_ENV := LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)
endif

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  $(PKG)_DESTDIR := 
endif

ifeq ($(USE_PIC_FLAG),yes)
  $(PKG)_CONFIGURE_PIC_OPTION := --with-pic
endif

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := FFLAGS="-g -O2 -fdefault-integer-8"
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/opencollab/arpack-ng/tags' | \
    $(SED) -n 's,.*releases/tag/\([^"]*\).*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(1)/bootstrap'
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        F77=$(MXE_F77) \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
	$($(PKG)_CONFIGURE_PIC_OPTION) \
        --prefix='$(HOST_PREFIX)' \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS) && $(CONFIGURE_POST_HOOK)

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)'
    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$($(PKG)_DESTDIR)'
endef
