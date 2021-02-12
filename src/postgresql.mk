# This file is part of MXE.
# See index.html for further information.

PKG             := postgresql
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 9.4.26
$(PKG)_CHECKSUM := 832094c944c57ac19ddcd552ada732a77609de75
$(PKG)_SUBDIR   := postgresql-$($(PKG)_VERSION)
$(PKG)_FILE     := postgresql-$($(PKG)_VERSION).tar.bz2
$(PKG)_URL      := http://ftp.postgresql.org/pub/source/v$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     := zlib

ifeq ($(MXE_NATIVE_BUILD),yes)
  $(PKG)_CONFIGURE_FLAGS_OPTION := $(CONFIGURE_CPPFLAGS) $(CONFIGURE_LDFLAGS)
endif

ifeq ($(MXE_SYSTEM),mingw)
  $(PKG)_LIBS := -lsecur32
  $(PKG)_CONFIGURE_FLAGS_OPTION += ac_cv_func_getaddrinfo=no
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
        $(ENABLE_SHARED_OR_STATIC) \
        --with-libraries='$(HOST_LIBDIR)' \
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
        --with-zlib \
        --with-system-tzdata=/dev/null \
        LIBS="$($(PKG)_LIBS)"
    $(MAKE) -C '$(1)'/src/common             -j '$(JOBS)'         
    $(MAKE) -C '$(1)'/src/interfaces/libpq -j '$(JOBS)' install DESTDIR='$(3)'
    $(MAKE) -C '$(1)'/src/port             -j '$(JOBS)'         
    $(MAKE) -C '$(1)'/src/bin/psql         -j '$(JOBS)' install DESTDIR='$(3)'
    $(MAKE) -C '$(1)'/src/bin/pg_config    -j '$(JOBS)' install DESTDIR='$(3)'
    $(INSTALL) -m644 '$(1)/src/include/pg_config.h'    '$(3)$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/src/include/pg_config_ext.h' '$(3)$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/src/include/pg_config_os.h' '$(3)$(HOST_INCDIR)'
    $(INSTALL) -m644 '$(1)/src/include/postgres_ext.h' '$(3)$(HOST_INCDIR)'
    $(INSTALL) -d    '$(3)$(HOST_INCDIR)/libpq'
    $(INSTALL) -m644 '$(1)'/src/include/libpq/*        '$(3)$(HOST_INCDIR)/libpq/'
    # Build a native pg_config (if cross build).
    if [ $(MXE_NATIVE_BUILD) = no ]; then \
        $(SED) -i 's,-DVAL_,-D_DISABLED_VAL_,g' '$(1).native'/src/bin/pg_config/Makefile; \
        cd '$(1).native' && ./configure \
            --prefix='$(BUILD_TOOLS_PREFIX)' \
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
            --with-system-tzdata=/dev/null; \
        $(MAKE) -C '$(1).native'/src/port          -j '$(JOBS)'; \
        $(MAKE) -C '$(1).native'/src/bin/pg_config -j '$(JOBS)' install DESTDIR=$(3); \
        $(INSTALL) -m755 '$(3)$(BUILD_TOOLS_PREFIX)/bin/pg_config' '$(3)$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pg_config'; \
    fi
endef
