# This file is part of MXE.
# See index.html for further information.

PKG             := hdf5
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.8.14
$(PKG)_CHECKSUM := 3c48bcb0d5fb21a3aa425ed035c08d8da3d5483a
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $(PKG)-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := https://www.hdfgroup.org/ftp/HDF5/releases/$(PKG)-$(call SHORT_PKG_VERSION,$(PKG))/$(PKG)-$($(PKG)_VERSION)/src/$($(PKG)_FILE)
$(PKG)_DEPS     :=
ifeq ($(MXE_SYSTEM),mingw)
  ifneq ($(MXE_NATIVE_BUILD),yes)
    $(PKG)_CROSS_CONFIG_OPTIONS := \
      --disable-largefile \
      LIBS=-lws2_32 \
      hdf5_cv_gettimeofday_tz=no \
      hdf5_cv_vsnprintf_works=yes \
      hdf5_cv_ldouble_to_integer_works=yes \
      hdf5_cv_ulong_to_float_accurate=yes \
      hdf5_cv_fp_to_ullong_accurate=yes \
      hdf5_cv_fp_to_ullong_right_maximum=no \
      hdf5_cv_ldouble_to_uint_accurate=yes \
      hdf5_cv_ullong_to_ldouble_precision=yes \
      hdf5_cv_fp_to_integer_overflow_works=yes \
      hdf5_cv_ldouble_to_long_special=no \
      hdf5_cv_long_to_ldouble_special=no \
      hdf5_cv_ldouble_to_llong_accurate=yes \
      hdf5_cv_llong_to_ldouble_correct=yes
    ifeq ($(TARGET),x86_64-w64-mingw32)
      $(PKG)_CROSS_CONFIG_OPTIONS += \
        hdf5_cv_printf_ll=ll \
        hdf5_cv_system_scope_threads=no \
        hdf5_cv_ldouble_to_integer_accurate=yes \
        hdf5_cv_ulong_to_fp_bottom_bit_accurate=yes \
        ac_cv_sizeof_long=4 \
        ac_cv_sizeof_long_double=16 \
        ac_cv_sizeof_long_long=8 \
        ac_cv_sizeof_off_t=8 \
        ac_cv_sys_file_offset_bits=64
    else
      $(PKG)_CROSS_CONFIG_OPTIONS += \
        hdf5_cv_printf_ll=l \
        hdf5_cv_system_scope_threads=yes \
        hdf5_cv_ulong_to_fp_bottom_bit_accurate=no
    endif
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
    case '$(TARGET)' in \
      x86_64-w64-mingw32) \
        cp '$(1)/src/H5Tinit.c.mingw64' '$(1)/src/H5Tinit.c.mingw' \
      ;; \
      i686-w64-mingw32) \
        cp '$(1)/src/H5Tinit.c.mingw32' '$(1)/src/H5Tinit.c.mingw' \
      ;; \
      i686-pc-mingw32) \
        cp '$(1)/src/H5Tinit.c.mingw32' '$(1)/src/H5Tinit.c.mingw' \
      ;; \
    esac

    # build GCC and support libraries
    cd '$(1)' && aclocal && libtoolize && autoreconf
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

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
      rm -rf '$(3)$(HOST_PREFIX)/share/hdf5_examples'; \
    fi
    rm -f '$(3)$(HOST_BINPREFIX)/h5*.exe'
endef
