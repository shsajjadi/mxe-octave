# This file is part of MXE.
# See index.html for further information.

PKG             := libproxy
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 0.4.15
$(PKG)_CHECKSUM := 5261bf6875feef15a706b34e7c010619f484e92f
$(PKG)_SUBDIR   := $(PKG)-$($(PKG)_VERSION)
$(PKG)_FILE     := $($(PKG)_SUBDIR).tar.xz
$(PKG)_URL      := https://github.com/libproxy/libproxy/releases/download/0.4.15/$($(PKG)_FILE)
$(PKG)_DEPS     :=

$(PKG)_CMAKE_FLAGS :=

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $($(PKG)_CMAKE_FLAGS) \
        -DWITH_KDE=no \
        -DBUILD_TESTING=no \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        .

    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)' -j '1' VERBOSE=1 DESTDIR='$(3)' install

    ## Note error in installed .dll.a file name.
    if [ $(MXE_SYSTEM) = mingw ]; then \
        $(INSTALL) -d '$(3)$(HOST_BINDIR)'; \
        $(INSTALL) '$(3)$(HOST_LIBDIR)/libproxy.dll' '$(3)$(HOST_BINDIR)/'; \
        rm -f '$(3)$(HOST_LIBDIR)/libproxy.dll'; \
        mv '$(3)$(HOST_LIBDIR)/liblibproxy.dll.a' '$(3)$(HOST_LIBDIR)/libproxy.dll.a'; \
    fi
endef
