# This file is part of MXE.
# See index.html for further information.

PKG             := llvm
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 234c96e73ef81aec9a54da92fc2a9024d653b059
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION).src
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).src.tar.gz
$(PKG)_URL      := http://llvm.org/releases/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=
ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS += libffi
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://llvm.org/releases/download.html' | \
    grep 'Download LLVM' | \
    $(SED) -n 's,.*\([0-9]\.[0-9]\).*,\1,p' | \
    head -1
endef

ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
ifeq ($(MXE_SYSTEM),msvc)
define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && cmake \
        -G "NMake Makefiles" \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLIBTYPE=STATIC \
        -DLLVM_TARGETS_TO_BUILD="X86" \
        -DLLVM_ENABLE_FFI:BOOL=ON \
        "-DFFI_INCLUDE_DIR=$(HOST_LIBDIR)/libffi-$(libffi_VERSION)/include" \
        -DLLVM_REQUIRES_EH:BOOL=ON \
        ../
    sed -i '/^	echo "/ {s/echo "/echo /;s/" >>/ >>/;}' \
        '$(1)/.build/tools/llvm-config/CMakeFiles/llvm-config.dir/build.make'
    cd '$(1)/.build' && \
        env -u MAKE -u MAKEFLAGS \
            LIB="`echo \`cd ../../../usr/i686-pc-mingw32/lib && pwd -W\` | sed -e 's,/,\\\\\\\\,g'`\;$$LIB" \
            nmake && \
        env -u MAKE -u MAKEFLAGS nmake install
endef
else
define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && ../configure  \
      $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
      $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
      --enable-targets='host-only' \
      --disable-docs \
      --without-python \
      $(ENABLE_SHARED_OR_STATIC) \
      --prefix='$(HOST_PREFIX)'

    PATH='$(HOST_BINDIR):$(PATH)' $(MAKE) -C '$(1)/build' -j $(JOBS) install
endef
endif
else
define $(PKG)_BUILD
    mkdir '$(1)/build'
    cd '$(1)/build' && cmake .. \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DBUILD_SHARED_LIBS=ON \
        -DLLVM_TARGETS_TO_BUILD="X86" \
        -DLLVM_BUILD_TOOLS=OFF
    $(MAKE) -C '$(1)/build' -j $(JOBS) llvm-tblgen
    $(MAKE) -C '$(1)/build' -j $(JOBS) intrinsics_gen
    $(MAKE) -C '$(1)/build' -j $(JOBS) install
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
      $(MAKE) -C $(1)/build/native/tools/llvm-config; \
      $(INSTALL) -m755 '$(1)/build/native/bin/llvm-config' '$(BUILD_TOOLS_PREFIX)/bin/llvm-config'; \
    fi
endef
endif
