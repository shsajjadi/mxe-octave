# This file is part of MXE.
# See index.html for further information.

PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.12.0
$(PKG)_CHECKSUM := 6020131b6e18e6866816b1fe68980512c696c2bf
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://support.hdfgroup.org/ftp/HDF5/releases/$(PKG)-$(call SHORT_PKG_VERSION,$(PKG))/$(PKG)-$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package hdf5.' >&2;
    echo $(hdf5_VERSION)
endef

ifeq ($(MXE_NATIVE_BUILD),yes)
  define $(PKG)_BUILD
    # build GCC and support libraries using autotools
    cd '$(1)' && aclocal && libtoolize && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && LD_LIBRARY_PATH=$(LD_LIBRARY_PATH) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-direct-vfd && $(CONFIGURE_POST_HOOK)

    # libtool is somehow created to effectively disallow shared builds
    $(SED) -i 's,allow_undefined_flag="unsupported",allow_undefined_flag="",g' '$(1)/.build/libtool'

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' 
    $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)'

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf '$(3)$(HOST_PREFIX)/share/hdf5_examples'; \
    fi
  endef
else
  define $(PKG)_BUILD
    # build rules for windows target using cmake

    mkdir '$(1)/pregen'
    case '$(TARGET)' in \
      x86_64-w64-mingw32) \
        cp '$(1)/src/H5Tinit.c.mingw64' '$(1)/pregen/H5Tinit.c' & \
        cp '$(1)/src/H5lib_settings.c.mingw64' '$(1)/pregen/H5lib_settings.c' \
      ;; \
      i686-w64-mingw32) \
        cp '$(1)/src/H5Tinit.c.mingw32' '$(1)/pregen/H5Tinit.c' & \
        cp '$(1)/src/H5lib_settings.c.mingw32' '$(1)/pregen/H5lib_settings.c' \
      ;; \
      i686-pc-mingw32) \
        cp '$(1)/src/H5Tinit.c.mingw32' '$(1)/pregen/H5Tinit.c' & \
        cp '$(1)/src/H5lib_settings.c.mingw32' '$(1)/pregen/H5lib_settings.c' \
      ;; \
    esac

    mkdir '$(1)/.build'

    # platform specific settings using https://github.com/steven-varga/HDFGroup-mailinglist/tree/master/crosscompile-2020-mar-25
    cd '$(1)/.build' && cmake .. -G "Unix Makefiles" \
      -DCMAKE_INSTALL_PREFIX=${prefix} \
       $($(PKG)_CMAKE_FLAGS) \
      -DBUILD_SHARED_LIBS=$(if $(findstring yes,$(BUILD_SHARED)),ON,OFF) \
      -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
      -DHDF5_INSTALL_BIN_DIR='$(HOST_BINDIR)' \
      -DHDF5_INSTALL_LIB_DIR='$(HOST_LIBDIR)' \
      -DHDF5_INSTALL_INCLUDE_DIR='$(HOST_INCDIR)' \
      -DHDF5_INSTALL_DATA_DIR='$(HOST_PREFIX)/share' \
      -DHDF5_BUILD_CPP_LIB=OFF \
      -DHDF5_BUILD_HL_LIB=ON \
      -DHDF5_ENABLE_Z_LIB_SUPPORT=ON \
      -DHDF5_ENABLE_SZIP_SUPPORT=OFF \
      -DHDF5_ENABLE_SZIP_ENCODING=OFF \
      -DBUILD_TESTING=OFF \
      -DHDF5_USE_PREGEN=ON \
      -DHDF5_USE_PREGEN_DIR='$(1)/pregen' \
      $($(PKG)_CCACHE_OPTIONS) \
      -DHAVE_IOEO_EXITCODE=0 \
      -DH5_LDOUBLE_TO_LONG_SPECIAL_RUN=1 \
      -DH5_LDOUBLE_TO_LONG_SPECIAL_RUN__TRYRUN_OUTPUT="" \
      -DH5_LONG_TO_LDOUBLE_SPECIAL_RUN=1 \
      -DH5_LONG_TO_LDOUBLE_SPECIAL_RUN__TRYRUN_OUTPUT="" \
      -DH5_LDOUBLE_TO_LLONG_ACCURATE_RUN=0 \
      -DH5_LDOUBLE_TO_LLONG_ACCURATE_RUN__TRYRUN_OUTPUT="" \
      -DH5_LLONG_TO_LDOUBLE_CORRECT_RUN=0 \
      -DH5_LLONG_TO_LDOUBLE_CORRECT_RUN__TRYRUN_OUTPUT="" \
      -DH5_DISABLE_SOME_LDOUBLE_CONV_RUN=1 \
      -DH5_DISABLE_SOME_LDOUBLE_CONV_RUN__TRYRUN_OUTPUT="" \
      -DH5_NO_ALIGNMENT_RESTRICTIONS_RUN=0 \
      -DH5_NO_ALIGNMENT_RESTRICTIONS_RUN__TRYRUN_OUTPUT="" \
      -DH5_PRINTF_LL_TEST_RUN=1 \
      -DH5_PRINTF_LL_TEST_RUN__TRYRUN_OUTPUT="" \
      -DTEST_LFS_WORKS_RUN=0

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' 
    $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR=$(3)
    
    # FIXME: Change the build rule to create the shared libs with the prefix
    mv '$(3)/$(HOST_LIBDIR)/hdf5.lib' '$(3)/$(HOST_LIBDIR)/libhdf5.lib'
    mv '$(3)/$(HOST_LIBDIR)/hdf5_tools.lib' '$(3)/$(HOST_LIBDIR)/libhdf5_tools.lib'
    mv '$(3)/$(HOST_LIBDIR)/hdf5_hl.lib' '$(3)/$(HOST_LIBDIR)/libhdf5_hl.lib'
    # Remove version suffix from pkg-config files
    mv '$(3)/$(HOST_LIBDIR)/pkgconfig/hdf5-$($(PKG)_VERSION).pc' '$(3)/$(HOST_LIBDIR)/pkgconfig/hdf5.pc'
    mv '$(3)/$(HOST_LIBDIR)/pkgconfig/hdf5_hl-$($(PKG)_VERSION).pc' '$(3)/$(HOST_LIBDIR)/pkgconfig/hdf5_hl.pc'

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf '$(HOST_PREFIX)/share/hdf5_examples'; \
    fi
  endef
endif

