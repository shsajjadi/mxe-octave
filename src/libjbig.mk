# This file is part of MXE.
# See index.html for further information.

PKG             := libjbig
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.1
$(PKG)_CHECKSUM := 4864646df004e8331d19f2fa103ed731fdb6c099
$(PKG)_SUBDIR   := jbigkit-$($(PKG)_VERSION)
$(PKG)_FILE     := jbigkit-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://www.cl.cam.ac.uk/~mgk25/jbigkit/download/$($(PKG)_FILE)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://www.cl.cam.ac.uk/~mgk25/jbigkit/CHANGES' |  \
    $(SED) -n 's,.*version \([0-9][^ ]*\) (.*,\1,p' | \
    $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    $(MAKE) -C '$(1)' -j '$(JOBS)'  CC=$(MXE_CC) AR=$(MXE_AR) LD=$(MXE_LD) CPPFLAGS='-I$(HOST_PREFIX)/include $(MXE_CC_PICFLAG)' LDFLAGS='-L$(HOST_PREFIX)/lib' lib
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -d '$(HOST_BINDIR)'
    if [ "x$(BUILD_STATIC)" == "xyes" ]; then \
      $(INSTALL) -m644 $(1)/libjbig/libjbig.a '$(HOST_LIBDIR)/'; \
      $(INSTALL) -m644 $(1)/libjbig/libjbig85.a '$(HOST_LIBDIR)/'; \
    else \
        $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CXX)' '$(1)/libjbig/libjbig.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
        $(MAKE_SHARED_FROM_STATIC) --ar '$(MXE_AR)' --ld '$(MXE_CXX)' '$(1)/libjbig/libjbig85.a' --install '$(INSTALL)' --libdir '$(HOST_LIBDIR)' --bindir '$(HOST_BINDIR)'; \
    fi
endef
