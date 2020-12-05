# This file is part of MXE.
# See index.html for further information.

PKG             := itsol
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2
$(PKG)_CHECKSUM := c7af215aaa6ab377521ba317eccf6859165ebefb
$(PKG)_SUBDIR   := ITSOL_2
$(PKG)_FILE     := ITSOL_2.tar.gz
$(PKG)_URL      := http://www-users.cs.umn.edu/~saad/software/ITSOL/itsol.php
$(PKG)_DEPS     := blas

ifeq ($(ENABLE_FORTRAN_INT64),yes)
  $(PKG)_DEFAULT_INTEGER_8_FLAG := -fdefault-integer-8
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)' \
        FC='$(MXE_F77)' \
	FCFLAGS='-c -O3 $(MXE_F77_PICFLAG) $($(PKG)_DEFAULT_INTEGER_8_FLAG) -I./INC' \
	CC='$(MXE_CC)' \
	CCFLAGS='-c -O2 $(MXE_CC_PICFLAG) -I./INC -DLINUX'

    if [ $(BUILD_SHARED) = yes ]; then \
      $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_F77)' '$(1)/LIB/libitsol.a' \
        --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)' \
        -llapack -lblas; \
    fi

    if [ $(BUILD_STATIC) = yes ]; then \
      $(INSTALL) -d '$(HOST_LIBDIR)'; \
      $(INSTALL) '$(1)/LIB/libitsol.a' '$(HOST_LIBDIR)/'; \
    fi

    $(INSTALL) -d '$(HOST_INCDIR)/itsol'
    for incfile in $(1)/INC/*.h; do \
      $(INSTALL) "$$incfile" '$(HOST_INCDIR)/itsol/'; \
    done
endef
