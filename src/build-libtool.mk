# This file is part of MXE.
# See index.html for further information.

PKG             := build-libtool
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.4.2
$(PKG)_CHECKSUM := 22b71a8b5ce3ad86e1094e7285981cae10e6ff88
$(PKG)_SUBDIR   := libtool-$($(PKG)_VERSION)
$(PKG)_FILE     := libtool-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := ftp://ftp.gnu.org/pub/gnu/libtool/$($(PKG)_FILE)
$(PKG)_DEPS     := 

ifeq ($(MXE_SYSTEM),msvc)
    $(PKG)_DEPS += build-msvctools
    $(PKG)_CONFIGURE_OPTIONS := \
        CC='$(MXE_CC)' CXX='$(MXE_CXX)' F77='$(MXE_F77)' ac_cv_f77_compiler_gnu=no \
	FC='$(MXE_F77)' ac_cv_fc_compiler_gnu=no
else
    $(PKG)_CONFIGURE_OPTIONS :=
endif

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    mkdir '$(1).build'
    cd    '$(1).build' && '$(1)/configure' \
        --prefix='$(BUILD_TOOLS_PREFIX)' \
	$($(PKG)_CONFIGURE_OPTIONS)
    $(MAKE) -C '$(1).build' -j '$(JOBS)'
    if test x$(MXE_SYSTEM) = xmsvc; then \
        cd '$(1).build' && $(CONFIGURE_POST_HOOK); \
    fi
    $(MAKE) -C '$(1).build' -j 1 install DESTDIR='$(3)'
endef
