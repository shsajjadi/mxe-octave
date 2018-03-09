# This file is part of MXE.
# See index.html for further information.

PKG             := llvm
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 5.0.0
$(PKG)_CHECKSUM := 7b0fd212ecc38461e392cbdcbe6a1d4944138a04
$(PKG)_SUBDIR   := llvm-$($(PKG)_VERSION).src
$(PKG)_FILE     := llvm-$($(PKG)_VERSION).src.tar.xz
$(PKG)_URL      := http://releases.llvm.org/$($(PKG)_VERSION)/$($(PKG)_FILE)
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
  define $(PKG)_BUILD
    echo "unsupported LLVM configuration" 1>&2
    exit 1
  endef
endif
