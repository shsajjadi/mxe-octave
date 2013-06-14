# This file is part of MXE.
# See index.html for further information.

PKG             := blas
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a643b737c30a0a5b823e11e33c9d46a605122c61
$(PKG)_SUBDIR   := BLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

ifeq ($(ENABLE_64),yes)
  $(PKG)_DEFAULT_INTEGER_8_FLAG := -fdefault-integer-8
endif

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    $(SED) -i 's,$$(FORTRAN),$(MXE_F77) $(MXE_F77_PICFLAG) $($(PKG)_DEFAULT_INTEGER_8_FLAG),g' '$(1)/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cd '$(1)' && $(MXE_AR) cr libblas.a *.o

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libblas.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
    fi

    if [ $(BUILD_STATIC) = yes ]; then \
      $(INSTALL) -d '$(HOST_LIBDIR)'; \
      $(INSTALL) '$(1)/libblas.a' '$(HOST_LIBDIR)/'; \
    fi
endef
