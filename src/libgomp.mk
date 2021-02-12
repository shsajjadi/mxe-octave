# This file is part of MXE.
# See index.html for further information.

PKG             := libgomp
$(PKG)_IGNORE    = $(build-gcc_IGNORE)
$(PKG)_VERSION  := $(build-gcc_VERSION)
$(PKG)_CHECKSUM  = $(build-gcc_CHECKSUM)
$(PKG)_SUBDIR    = $(build-gcc_SUBDIR)
$(PKG)_FILE      = $(build-gcc_FILE)
$(PKG)_URL       = $(build-gcc_URL)
$(PKG)_URL_2     = $(build-gcc_URL_2)
$(PKG)_DEPS     := pthreads

ifeq ($(USE_SYSTEM_GCC),no)
    $(PKG)_DEPS += build-gcc
endif

define $(PKG)_UPDATE
    echo $(build-gcc_VERSION)
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  $(PKG)_SYSDEP_CONFIGURE_OPTIONS := LIBS='-lws2_32'
endif

define $(PKG)_BUILD
    mkdir -p '$(1)/build/$(TARGET)/libgomp'
    cd       '$(1)/build/$(TARGET)/libgomp' && '$(1)/libgomp/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --target='$(TARGET)' \
        --prefix='$(HOST_PREFIX)' \
        --enable-version-specific-runtime-libs \
        --disable-multilib \
        --with-gnu-ld \
        $(ENABLE_SHARED_OR_STATIC) \
        $($(PKG)_SYSDEP_CONFIGURE_OPTIONS)
    $(MAKE) -C '$(1)/build/$(TARGET)/libgomp' -j '$(JOBS)'
    $(MAKE) -C '$(1)/build/$(TARGET)/libgomp' -j '1' install DESTDIR='$(3)'

    # also copy omp.h to where other programs will see it
    $(INSTALL) -d "$(3)$(HOST_INCDIR)" 
    $(INSTALL) -m644 '$(1)/build/$(TARGET)/libgomp/omp.h' '$(3)$(HOST_INCDIR)/'
    if [ x"$(USE_SYSTEM_GCC)" == "xno" ]; then \
      $(INSTALL) -d "$(3)/$(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/"; \
      cat '$(1)/build/$(TARGET)/libgomp/libgomp.spec' | $(SED) 's,-lgomp,-L$(HOST_LIBDIR)/gcc/$(TARGET)/$($(PKG)_VERSION) -lgomp,' > '$(3)$(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/$($(PKG)_VERSION)/libgomp.spec'; \
    fi

    #'$(MXE_CC)' \
    #    -W -Wall -Werror -ansi -pedantic \
    #    '$(2).c' -o '$(HOST_BINDIR)/test-libgomp.exe' \
    #    -fopenmp
endef
