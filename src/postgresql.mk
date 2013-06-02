# This file is part of MXE.
# See index.html for further information.

PKG             := postgresql
$(PKG)_IGNORE   :=
$(PKG)_CHECKSUM := cea9601b3acd1484fd98441b49a15ea1c42057ec
$(PKG)_SUBDIR   := postgresql-$($(PKG)_VERSION)
$(PKG)_FILE     := postgresql-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.postgresql.org/pub/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := gcc zlib openssl

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_FLAGS_OPTION := $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS)
endif

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_LIGS := -lsecur32
endif

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://git.postgresql.org/gitweb?p=postgresql.git;a=tags' | \
    grep 'refs/tags/REL9[0-9_]*"' | \
    $(SED) 's,.*refs/tags/REL\(.*\)".*,\1,g;' | \
    $(SED) 's,_,.,g' | \
    grep -v '^9\.[01]' | \
    head -1
endef

define $(PKG)_BUILD
    cd '$(1)' && autoconf
    cp -Rp '$(1)' '$(1).native'
    # Since we build only client libary, use bogus tzdata to satisfy configure.
    cd '$(1)' && ./configure \
        $($(PKG)_CONFIGURE_FLAGS_OPTION) \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --enable-shared \
        --disable-rpath \
        --without-tcl \
        --without-perl \
        --without-python \
        --without-gssapi \
        --without-krb5 \
        --without-pam \
        --without-ldap \
        --without-bonjour \
        --with-openssl \
        --without-readline \
        --without-ossp-uuid \
        --without-libxml \
        --without-libxslt \
        --with-zlib \
        --with-system-tzdata=/dev/null \
        LIBS="$($(PKG)_LIBS) `'$(TARGET)-pkg-config' openssl --libs`"
    $(MAKE) -C '$(1)'/src/interfaces/libpq -j '$(JOBS)' install haslibarule=
    $(MAKE) -C '$(1)'/src/port             -j '$(JOBS)'         haslibarule=
    $(MAKE) -C '$(1)'/src/bin/psql         -j '$(JOBS)' install haslibarule=
    $(INSTALL) -m644 '$(1)/src/include/pg_config.h'    '$(HOST_PREFIX)/include/'
    $(INSTALL) -m644 '$(1)/src/include/postgres_ext.h' '$(HOST_PREFIX)/include/'
    # Build a native pg_config.
    $(SED) -i 's,-DVAL_,-D_DISABLED_VAL_,g' '$(1).native'/src/bin/pg_config/Makefile
    cd '$(1).native' && ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(ENABLE_SHARED_OR_STATIC) \
        --disable-rpath \
        --without-tcl \
        --without-perl \
        --without-python \
        --without-gssapi \
        --without-krb5 \
        --without-pam \
        --without-ldap \
        --without-bonjour \
        --without-openssl \
        --without-readline \
        --without-ossp-uuid \
        --without-libxml \
        --without-libxslt \
        --without-zlib \
        --with-system-tzdata=/dev/null
    $(MAKE) -C '$(1).native'/src/port          -j '$(JOBS)'
    $(MAKE) -C '$(1).native'/src/bin/pg_config -j '$(JOBS)' install
    $(LN_SF) '$(HOST_PREFIX)/bin/pg_config' '$(BUILD_TOOLS_PREFIX)/bin/$(TARGET)-pg_config'
endef
