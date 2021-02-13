# This file is part of MXE.
# See index.html for further information.

PKG             := libsndfile
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.0.30
$(PKG)_CHECKSUM := 494b427f814858d1e4092c1767ab5652080fcffe
$(PKG)_SUBDIR   := libsndfile-$($(PKG)_VERSION)
$(PKG)_FILE     := libsndfile-$($(PKG)_VERSION).tar.gz
$(PKG)_URL      := https://github.com/$(PKG)/$(PKG)/archive/v$($(PKG)_VERSION).tar.gz
$(PKG)_DEPS     := sqlite flac ogg opus vorbis

define $(PKG)_UPDATE
    $(WGET) -q -O- 'https://github.com/libsndfile/libsndfile/tags' | \
    $(SED) -n 's|.*releases/tag/v\([^"]*\).*|\1|p' | $(SORT) -V | \
    tail -1
endef

define $(PKG)_BUILD
    cd '$(1)' && cmake \
        $($(PKG)_CMAKE_FLAGS) \
        -DBUILD_TESTING=no \
        -DBUILD_PROGRAMS=no \
        -DBUILD_EXAMPLES=no \
        -DINSTALL_MANPAGES=no \
        -DENABLE_EXTERNAL_LIBS=yes \
        $(CMAKE_CCACHE_FLAGS) \
        $(CMAKE_BUILD_SHARED_OR_STATIC) \
        -DCMAKE_TOOLCHAIN_FILE='$(CMAKE_TOOLCHAIN_FILE)' \
        .

    $(MAKE) -C '$(1)' -j '$(JOBS)' VERBOSE=1
    $(MAKE) -C '$(1)' -j '1' VERBOSE=1 DESTDIR='$(3)' install

    if [ "$(ENABLE_DEP_DOCS)" == "no" ]; then \
        rm -rf '$(3)$(HOST_PREFIX)/share/doc/$(PKG)'; \
    fi

endef
