# This file is part of MXE.
# See index.html for further information.

PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.10
$(PKG)_CHECKSUM := 867a91b75ee0bbd1f1b13aecd52e883be1507a2c
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://www.hdfgroup.org/ftp/HDF5/current/src/$($(PKG)_FILE)
$(PKG)_DEPS     :=
ifeq ($(MXE_SYSTEM),mingw)
  ifneq ($(MXE_NATIVE_BUILD),yes)
    $(PKG)_CROSS_CONFIG_OPTIONS := \
      --disable-largefile \
      LIBS=-lws2_32 \
      hdf5_cv_gettimeofday_tz=no \
      hdf5_cv_vsnprintf_works=yes \
      hdf5_cv_printf_ll=l \
      hdf5_cv_system_scope_threads=yes \
      hdf5_cv_ldouble_to_integer_works=yes \
      hdf5_cv_ulong_to_float_accurate=yes \
      hdf5_cv_ulong_to_fp_bottom_bit_accurate=no \
      hdf5_cv_fp_to_ullong_accurate=yes \
      hdf5_cv_fp_to_ullong_right_maximum=no \
      hdf5_cv_fp_to_ullong_right_maximum=no \
      hdf5_cv_ldouble_to_uint_accurate=yes \
      hdf5_cv_ullong_to_ldouble_precision=yes \
      hdf5_cv_fp_to_integer_overflow_works=yes \
      hdf5_cv_ldouble_to_long_special=no \
      hdf5_cv_long_to_ldouble_special=no \
      hdf5_cv_ldouble_to_llong_accurate=yes \
      hdf5_cv_llong_to_ldouble_correct=yes
  endif
endif

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_ENV := LD_LIBRARY_PATH=$(LD_LIBRARY_PATH)
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package hdf5.' >&2;
    echo $(hdf5_VERSION)
endef

define $(PKG)_BUILD
    # build GCC and support libraries
    cd '$(1)' && autoreconf
    mkdir '$(1)/.build'
    cd '$(1)/.build' && $($(PKG)_CONFIGURE_ENV) '$(1)/configure' \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        $(ENABLE_SHARED_OR_STATIC) \
        --prefix='$(HOST_PREFIX)' \
        --disable-direct-vfd \
        $($(PKG)_CROSS_CONFIG_OPTIONS) && $(CONFIGURE_POST_HOOK)

    case '$(MXE_SYSTEM)' in \
      *mingw*) \
        echo "#define H5_HAVE_WIN32_API 1" >> $(1)/.build/src/H5pubconf.h; \
        echo "#define H5_HAVE_MINGW 1" >> $(1)/.build/src/H5pubconf.h; \
        echo "#define HAVE_WINDOWS_PATH 1" >> $(1)/.build/src/H5pubconf.h; \
      ;; \
      *msvc*) \
        sed -i -e 's/^\(#define H5_SIZEOF_SSIZE_T\) .*/\1 0/' \
	    '$(1)/.build/src/H5pubconf.h'; \
        echo "#define H5_HAVE_WIN32_API 1" >> $(1)/.build/src/H5pubconf.h; \
        echo "#define H5_HAVE_VISUAL_STUDIO 1" >> $(1)/.build/src/H5pubconf.h; \
        echo "#define HAVE_WINDOWS_PATH 1" >> $(1)/.build/src/H5pubconf.h; \
      ;; \
    esac

    # libtool is somehow created to effectively disallow shared builds
    $(SED) -i 's,allow_undefined_flag="unsupported",allow_undefined_flag="",g' '$(1)/.build/libtool'

    $(MAKE) -C '$(1)/.build' -j '$(JOBS)' 
    $(MAKE) -C '$(1)/.build' -j 1 install DESTDIR='$(3)'
endef
