# This file is part of MXE.
# See index.html for further information.

PKG             := llvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 8.0.1
$(PKG)_CHECKSUM := 09964f9eabc364f221a3caefbdaea28557273b4a
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).src.tar.xz
$(PKG)_URL      := https://github.com/llvm/llvm-project/releases/download/llvmorg-$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := build-python

define $(PKG)_UPDATE
    wget -q -O- 'http://releases.llvm.org/download.html?' | \
    grep 'Download LLVM' | \
    $(SED) -n 's,.*LLVM \([0-9][^<]*\).*,\1,p' | \
    head -1
endef

ifeq ($(MXE_NATIVE_BUILD),yes)
    ifeq ($(MXE_SYSTEM),gnu-linux)
        define $(PKG)_BUILD
            mkdir '$(1)/.build' && cd '$(1)/.build' && cmake .. \
                $($(PKG)_CMAKE_FLAGS) \
                $(CMAKE_CCACHE_FLAGS) \
                -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
                -DLLVM_BUILD_LLVM_DYLIB=ON \
                -DLLVM_LINK_LLVM_DYLIB=ON \
                -DLLVM_VERSION_SUFFIX= \
                -DLLVM_TARGETS_TO_BUILD='X86' \
                -DLLVM_ENABLE_EH=ON \
                -DLLVM_ENABLE_RTTI=ON \
                -DLLVM_BUILD_EXAMPLES=OFF \
                -DLLVM_INCLUDE_EXAMPLES=OFF \
                -DLLVM_BUILD_TESTS=OFF \
                -DLLVM_INCLUDE_TESTS=OFF \
                -DLLVM_INCLUDE_GO_TESTS=OFF \
                -DLLVM_INCLUDE_DOCS=OFF \
                -DLLVM_BUILD_DOCS=OFF \
                -DLLVM_ENABLE_DOXYGEN=OFF \
                -DLLVM_ENABLE_BACKTRACES=OFF

            $(MAKE) -C '$(1)/.build' -j '$(JOBS)' install DESTDIR='$(3)'
        endef
    else
        define $(PKG)_BUILD
            echo "unsupported LLVM configuration" 1>&2
            exit 1
        endef
    endif
else
    ifeq ($(ENABLE_WINDOWS_64),yes)
        $(PKG)_SYSDEP_CMAKE_OPTIONS += \
            -DLLVM_DEFAULT_TARGET_TRIPLE='x86_64-pc-win32'
    else
        $(PKG)_SYSDEP_CMAKE_OPTIONS += \
            -DLLVM_DEFAULT_TARGET_TRIPLE='x86-pc-win32'
    endif
    ifeq ($(USE_CCACHE),yes)
        $(PKG)_CCACHE_OPTIONS += \
            -DLLVM_CCACHE_BUILD=ON
    endif

    define $(PKG)_BUILD
        mkdir '$(1)/.build'
        cd '$(1)/.build' && 'cmake' .. \
            $($(PKG)_CMAKE_FLAGS) \
            $(CMAKE_CCACHE_FLAGS) \
            -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
            -DLLVM_BUILD_TOOLS=OFF \
            -DLLVM_BUILD_LLVM_DYLIB=ON \
            -DLLVM_LINK_LLVM_DYLIB=ON \
            -DLLVM_VERSION_SUFFIX= \
            -DLLVM_TARGETS_TO_BUILD='X86' \
            $($(PKG)_SYSDEP_CMAKE_OPTIONS) \
            -DCROSS_TOOLCHAIN_FLAGS_NATIVE="-DCMAKE_TOOLCHAIN_FILE='$(CMAKE_NATIVE_TOOLCHAIN_FILE)'" \
            -DLLVM_ENABLE_EH=ON \
            -DLLVM_ENABLE_RTTI=ON \
            -DLLVM_BUILD_EXAMPLES=OFF \
            -DLLVM_INCLUDE_EXAMPLES=OFF \
            -DLLVM_BUILD_TESTS=OFF \
            -DLLVM_INCLUDE_TESTS=OFF \
            -DLLVM_INCLUDE_GO_TESTS=OFF \
            -DLLVM_ENABLE_BACKTRACES=OFF \
            -DLLVM_INCLUDE_DOCS=OFF \
            -DLLVM_BUILD_DOCS=OFF \
            -DLLVM_ENABLE_DOXYGEN=OFF \
            -DLLVM_ENABLE_OCAMLDOC=OFF \
            -DLLVM_ENABLE_BINDINGS=OFF \
            -DLLVM_ENABLE_SPHINX=OFF \
            -DLLVM_BUILD_RUNTIME=OFF \
            -DLLVM_BUILD_RUNTIMES=OFF \
            -DLLVM_INCLUDE_RUNTIMES=OFF \
            $($(PKG)_CCACHE_OPTIONS)

        $(MAKE) -C '$(1)/.build' -j $(JOBS) LLVMSupport
        $(MAKE) -C '$(1)/.build' -j $(JOBS) CONFIGURE_LLVM_NATIVE
        $(MAKE) -C '$(1)/.build/NATIVE' -j $(JOBS) LLVMSupport
        $(MAKE) -C '$(1)/.build' -j $(JOBS) llvm-config
        $(MAKE) -C '$(1)/.build' -j $(JOBS) install DESTDIR='$(3)'

        # create symlink for shared library so that llvm-config can find it
        cd '$(3)/$(HOST_BINDIR)' && ln -s LLVM.dll LLVM-$(word 1,$(subst ., ,$($(PKG)_VERSION))).dll

        # install native llvm-config in HOST_BINDIR because it won't find the libs otherwise
        $(INSTALL) -d '$(HOST_BINDIR)'
        $(INSTALL) -m755 '$(1)/.build/NATIVE/bin/llvm-config' '$(HOST_BINDIR)/$(MXE_TOOL_PREFIX)llvm-config'
    endef
endif
