# This file is part of MXE.
# See index.html for further information.

PKG             := libodbc++
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := 8a77921b21c23926042c413f4a7a187a3656025b
$(PKG)_SUBDIR   := libodbc++-$($(PKG)_VERSION)
$(PKG)_FILE     := libodbc++-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/libodbcxx/libodbc++/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://libodbcxx.svn.sourceforge.net/viewvc/libodbcxx/tags/?sortby=date' | \
    grep '<a name="' | \
    $(SED) -n 's,.*<a name="libodbc++-\([0-9][^"]*\)".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoreconf --install
    cd '$(1)' && ./configure \
        $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS) \
      --prefix='$(HOST_PREFIX)' \
      $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
      $(ENABLE_SHARED_OR_STATIC) \
      --without-tests \
      --disable-dependency-tracking
    $(MAKE) -C '$(1)' -j '$(JOBS)' install doxygen= progref_dist_files=
endef
