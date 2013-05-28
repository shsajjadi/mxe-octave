# This file is part of MXE.
# See index.html for further information.

PKG             := blas
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := a643b737c30a0a5b823e11e33c9d46a605122c61
$(PKG)_SUBDIR   := BLAS
$(PKG)_FILE     := $(PKG).tgz
$(PKG)_URL      := http://www.netlib.org/$(PKG)/$($(PKG)_FILE)
$(PKG)_URL_2    := ftp://ftp.eq.uc.pt/pub/software/math/netlib/$(PKG)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    echo 1
endef

define $(PKG)_BUILD
    $(SED) -i 's,$$(FORTRAN),$(MXE_F77) $(MXE_F77_PICFLAG),g' '$(1)/Makefile'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    cd '$(1)' && $(MXE_AR) cr libblas.a *.o

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/libblas.a' --install '$(INSTALL)' --libdir '$(MXE_LIBDIR)' --bindir '$(MXE_BINDIR)'; \
    fi
endef
