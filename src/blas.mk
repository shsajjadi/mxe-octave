# This file is part of MXE.
# See index.html for further information.

PKG             := blas
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 3.8.0
$(PKG)_CHECKSUM := ee21dc04e563f50ccf173c957f98d2ff47702cb4
$(PKG)_SUBDIR   := BLAS-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  $(PKG)_DEFAULT_INTEGER_8_FLAG := -fdefault-integer-8
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- ftp://ftp.eq.uc.pt/pub/software/math/netlib/blas/ | \
    $(SED) -n 's|.*>blas-\([0-9\.]*\).tgz<.*|\1|p' | \
    tail -1
endef

define $(PKG)_BUILD
    $(SED) -i 's,$$(FORTRAN),$(MXE_F77) $(MXE_F77_PICFLAG) $($(PKG)_DEFAULT_INTEGER_8_FLAG),g' '$(1)/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cd '$(1)' && $(MXE_AR) cr libblas.a *.o

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libblas.a' --install '$(INSTALL)' --libdir '$(3)$(HOST_LIBDIR)' --bindir '$(3)$(HOST_BINDIR)'; \
    fi

    if [ $(BUILD_STATIC) = yes ]; then \
      $(INSTALL) -d '$(3)$(HOST_LIBDIR)'; \
      $(INSTALL) '$(1)/libblas.a' '$(3)$(HOST_LIBDIR)/'; \
    fi
endef
