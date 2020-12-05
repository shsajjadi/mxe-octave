# This file is part of MXE.
# See index.html for further information.

## This package is intended for building a minimal version of Octave that
## runs on the build system.  Some Octave Forge packages need Octave as a
## build tool.
## This version of Octave is built from the same tarball that is used for
## cross-compiling.  However, the native Octave is unavoidably different
## from the Octave that is built for the target system.  Packages must be
## careful when relying on Octave for configuration settings.  Wherever
## possible, packages should try to not depend on Octave as a build tool
## and should use alternatives instead (e.g., [target]-octave-config or
## check the macros defined in octave-config.h).
##
## It is assumed that the necessary dependencies for a native build are
## present on the build system.

PKG             := build-octave
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := $($(OCTAVE_TARGET)_VERSION)
$(PKG)_CHECKSUM := $($(OCTAVE_TARGET)_CHECKSUM)
$(PKG)_SUBDIR   := $($(OCTAVE_TARGET)_SUBDIR)
$(PKG)_FILE     := $($(OCTAVE_TARGET)_FILE)
$(PKG)_URL      := $($(OCTAVE_TARGET)_URL)
$(PKG)_DEPS     := $(OCTAVE_TARGET)

## The following dependencies and some native build tools are necessary
## on the build system:
# $(PKG)_DEPS     := blas lapack pcre

define $(PKG)_UPDATE
    echo 'Warning: Updates are disabled for package build-octave.' >&2;
    echo $($(PKG)_VERSION)
endef

$(PKG)_ENV_FLAGS := \
    PKG_CONFIG_PATH='$(BUILD_PKG_CONFIG_PATH)' \
    LD_LIBRARY_PATH='$(LD_LIBRARY_PATH)' \
    PATH='$(ENV_PATH)'

ifeq ($(ENABLE_64),yes)
  $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --enable-64
else
  $(PKG)_ENABLE_64_CONFIGURE_OPTIONS := --disable-64
endif

define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && \
        $($(PKG)_ENV_FLAGS) '$(1)/configure' \
        --prefix=$(ROOT_PREFIX) \
        $($(PKG)_ENABLE_64_CONFIGURE_OPTIONS) \
        --disable-docs --disable-fftw-threads --disable-java \
        --disable-jit --disable-openmp --disable-readline --without-amd \
        --without-arpack --without-bz2 --without-camd --without-ccolamd \
        --without-cholmod --without-colamd --without-curl \
        --without-cxsparse --without-fftw3 --without-fftw3f \
        --without-fltk --without-fontconfig --without-framework-opengl \
        --without-freetype --without-glpk --without-hdf5 --without-klu \
        --without-magick --without-opengl --without-openssl \
        --without-osmesa --without-portaudio --without-qhull \
        --without-qrupdate --without-qscintilla --without-qt \
        --without-sndfile --without-sundials_ida \
        --without-sundials_nvecserial --without-umfpack --without-x \
        --without-z

    $($(PKG)_ENV_FLAGS) $(MAKE) -C '$(1)/.build' all -j '$(JOBS)'
    $($(PKG)_ENV_FLAGS) $(MAKE) -C '$(1)/.build' install
endef
