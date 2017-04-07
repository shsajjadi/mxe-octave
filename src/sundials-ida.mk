# This file is part of MXE.
# See index.html for further information.

PKG             := sundials-ida
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.9.0
$(PKG)_CHECKSUM := 375a061259b06f3ae46c218b7d5473c60a46e3f8
$(PKG)_SUBDIR   := ida-$($(PKG)_VERSION)
$(PKG)_FILE     := ida-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://computation.llnl.gov/projects/sundials/download/$($(PKG)_FILE)
$(PKG)_DEPS     := lapack libgomp

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DEXAMPLES_ENABLE=OFF \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install DESTDIR='$(3)' VERBOSE=1

    if [ $(MXE_SYSTEM) = mingw ]; then \
        echo "Install dlls"; \
        $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
        mv '$(3)$(HOST_LIBDIR)/'libsundials*.dll '$(3)$(HOST_BINDIR)/'; \
    fi
endef
