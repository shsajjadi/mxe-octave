# This file is part of MXE.
# See index.html for further information.

PKG             := libgomp
$(PKG)_IGNORE    = $(gcc_IGNORE)
$(PKG)_CHECKSUM  = $(gcc_CHECKSUM)
$(PKG)_SUBDIR    = $(gcc_SUBDIR)
$(PKG)_FILE      = $(gcc_FILE)
$(PKG)_URL       = $(gcc_URL)
$(PKG)_URL_2     = $(gcc_URL_2)
$(PKG)_DEPS     := gcc pthreads

define $(PKG)_UPDATE
    echo $(gcc_VERSION)
endef

define $(PKG)_BUILD
    mkdir -p '$(1)/build/$(TARGET)/libgomp'
    cd       '$(1)/build/$(TARGET)/libgomp' && '$(1)/libgomp/configure' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --target='$(TARGET)' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
        --enable-version-specific-runtime-libs \
        --with-gnu-ld \
        $(ENABLE_SHARED_OR_STATIC) \
        LIBS='-lws2_32'
    $(MAKE) -C '$(1)/build/$(TARGET)/libgomp' -j '$(JOBS)' install

    '$(TARGET)-gcc' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_PREFIX)/bin/test-libgomp.exe' \
        -fopenmp
endef
