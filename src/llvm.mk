# This file is part of MXE.
# See index.html for further information.

PKG             := llvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 7.1.0
$(PKG)_CHECKSUM := d43bfea58a35e058b93a6af36a728cfc64add33d
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION).src
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).src.tar.xz
$(PKG)_URL      := https://releases.llvm.org/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

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
	-DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        -DLLVM_BUILD_LLVM_DYLIB=On \
        -DLLVM_LINK_LLVM_DYLIB=On \
        -DLLVM_VERSION_SUFFIX= \
        -DLLVM_TARGETS_TO_BUILD='X86' \
	-DLLVM_BUILD_EXAMPLES=Off \
	-DLLVM_INCLUDE_EXAMPLES=Off \
	-DLLVM_BUILD_TESTS=Off \
	-DLLVM_INCLUDE_TESTS=Off \
        -DLLVM_INCLUDE_GO_TESTS=OFF \
        -DLLVM_INCLUDE_DOCS=OFF \
        -DLLVM_BUILD_DOCS=OFF \
        -DLLVM_ENABLE_DOXYGEN=OFF \
	-DLLVM_ENABLE_BACKTRACES=Off

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
    ## WTF, setting LLVM_TARGETS_TO_BUILD to X64_64 doesn't work here?
    $(PKG)_SYSDEP_CMAKE_OPTIONS += \
      -DLLVM_DEFAULT_TARGET_TRIPLE='x86_64-pc-win32' \
      -DLLVM_TARGETS_TO_BUILD='X86'
  else
    $(PKG)_SYSDEP_CMAKE_OPTIONS += \
      -DLLVM_DEFAULT_TARGET_TRIPLE='x86-pc-win32' \
      -DLLVM_TARGETS_TO_BUILD='X86'
  endif
  ifeq ($(USE_CCACHE),yes)
    $(PKG)_CCACHE_OPTIONS += \
      -DLLVM_CCACHE_BUILD=On
  endif

  define $(PKG)_BUILD
    mkdir '$(1)/.build'
    cd '$(1)/.build' && 'cmake' .. \
      $($(PKG)_CMAKE_FLAGS) \
      -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
      -DLLVM_BUILD_TOOLS=OFF \
      -DLLVM_BUILD_LLVM_DYLIB=On \
      -DLLVM_LINK_LLVM_DYLIB=On \
      -DLLVM_VERSION_SUFFIX= \
      $($(PKG)_SYSDEP_CMAKE_OPTIONS) \
      -DCROSS_TOOLCHAIN_FLAGS_NATIVE=-DCMAKE_TOOLCHAIN_FILE='$(CMAKE_NATIVE_TOOLCHAIN_FILE)' \
      -DLLVM_BUILD_EXAMPLES=Off \
      -DLLVM_INCLUDE_EXAMPLES=Off \
      -DLLVM_BUILD_TESTS=Off \
      -DLLVM_INCLUDE_TESTS=Off \
      -DLLVM_INCLUDE_GO_TESTS=OFF \
      -DLLVM_ENABLE_BACKTRACES=Off \
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
    $(MAKE) -C '$(1)/.build' -j $(JOBS) llvm-config
    $(MAKE) -C '$(1)/.build' -j $(JOBS) install DESTDIR='$(3)'

    # create symlink for shared library so that llvm-config can find it
    cd '$(3)/$(HOST_BINDIR)' && ln -s LLVM.dll LLVM-$(word 1,$(subst ., ,$($(PKG)_VERSION))).$(word 2,$(subst ., ,$($(PKG)_VERSION))).dll

    # install native llvm-config in HOST_BINDIR because it won't find the libs otherwise
    # FIXME: Some of the configuration flags are hard coded into llvm-config with a patch.
    # If the configuration flags are changed, the patch might have to be adapted.
    $(INSTALL) -d '$(HOST_BINDIR)'
    $(INSTALL) -m755 '$(1)/.build/NATIVE/bin/llvm-config' '$(HOST_BINDIR)/$(MXE_TOOL_PREFIX)llvm-config'
  endef
endif
