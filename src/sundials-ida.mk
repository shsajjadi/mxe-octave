# This file is part of MXE.
# See index.html for further information.

PKG             := sundials-ida
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.3.0
$(PKG)_CHECKSUM := a33d5a9f19fad4e4a257a8c9ae1c321550885996
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

$(PKG)_CMAKE_FLAGS := \
    -DEXAMPLES_ENABLE_C=OFF \
    -DKLU_ENABLE=ON \
    -DKLU_INCLUDE_DIR=$(HOST_INCDIR)/suitesparse \
    -DKLU_LIBRARY_DIR=$(HOST_LIBDIR) \
    -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
    -DBUILD_ARKODE=OFF \
    -DBUILD_CVODE=OFF \
    -DBUILD_CVODES=OFF \
    -DBUILD_IDA=ON \
    -DBUILD_IDAS=OFF \
    -DBUILD_KINSOL=OFF \
    -DBUILD_CPODES=OFF

# Keep "sunindextype" in sync with LAPACK (bug #58795)
ifeq ($(ENABLE_FORTRAN_INT64),yes)
    $(PKG)_CMAKE_FLAGS += -DSUNDIALS_INDEX_SIZE=64
else
    $(PKG)_CMAKE_FLAGS += -DSUNDIALS_INDEX_SIZE=32
endif

ifeq ($(MXE_WINDOWS_BUILD),yes)

    $(PKG)_CMAKE_FLAGS += \
        -DSUITESPARSECONFIG_LIBRARY=$(HOST_LIBDIR)/libsuitesparseconfig.dll.a

    define $(PKG)_BUILD
        mkdir '$(1).build'
        cd '$(1).build' && cmake \
            $($(PKG)_CMAKE_FLAGS) \
            '$(1)'
        $(MAKE) -C '$(1).build' -j '$(JOBS)' install DESTDIR='$(3)' VERBOSE=1

        if [ $(MXE_SYSTEM) = mingw ]; then \
            echo "Install dlls"; \
            $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
            mv '$(3)$(HOST_LIBDIR)/'libsundials*.dll '$(3)$(HOST_BINDIR)/'; \
        fi
    endef

else

    define $(PKG)_BUILD
        mkdir '$(1).build'
        cd '$(1).build' && cmake \
            $($(PKG)_CMAKE_FLAGS) \
            '$(1)'
        $(MAKE) -C '$(1).build' -j '$(JOBS)' install VERBOSE=1
    endef

endif
