# This file is part of MXE.
# See index.html for further information.
# This file can be removed once Octave 5 is phased out.

PKG             := sundials-27-ida
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.7.0
$(PKG)_CHECKSUM := 3559c375ce9f875542e4a39978908f91792e6d57
$(PKG)_SUBDIR   := sundials-$($(PKG)_VERSION)
$(PKG)_FILE     := sundials-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://computation.llnl.gov/projects/sundials/download/$($(PKG)_FILE)
$(PKG)_DEPS     := lapack suitesparse
ifeq ($(USE_SYSTEM_GCC),no)
  $(PKG)_DEPS += libgomp
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd '$(1).build' && cmake \
        -DEXAMPLES_ENABLE=OFF \
        -DKLU_ENABLE=ON \
        -DKLU_INCLUDE_DIR=$(HOST_INCDIR)/suitesparse \
        -DKLU_LIBRARY_DIR=$(HOST_LIBDIR) \
        -DSUITESPARSECONFIG_LIBRARY=$(HOST_LIBDIR)/libsuitesparseconfig.dll.a \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
	-DBUILD_ARKODE=OFF \
	-DBUILD_CVODE=OFF \
	-DBUILD_CVODES=OFF \
	-DBUILD_IDA=ON \
	-DBUILD_IDAS=OFF \
	-DBUILD_KINSOL=OFF \
	-DBUILD_CPODES=OFF \
        '$(1)'
    $(MAKE) -C '$(1).build' -j '$(JOBS)' install DESTDIR='$(3)' VERBOSE=1

    if [ $(MXE_SYSTEM) = mingw ]; then \
        echo "Install dlls"; \
        $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
        mv '$(3)$(HOST_LIBDIR)/'libsundials*.dll '$(3)$(HOST_BINDIR)/'; \
    fi
endef
