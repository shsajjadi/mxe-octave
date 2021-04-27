# This file is part of MXE.
# See index.html for further information.

PKG             := gsoap
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 2.8.11
$(PKG)_CHECKSUM := b1c17d501361939c6d419eeb2aa26e7fd2b586fe
$(PKG)_SUBDIR   := gsoap-$(call SHORT_PKG_VERSION,$(PKG))
$(PKG)_FILE     := gsoap_$($(PKG)_VERSION).zip
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/gsoap2/$($(PKG)_FILE)
$(PKG)_DEPS     := gnutls libgcrypt libntlm

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/gsoap2/files' | \
    $(SED) -n 's,.*gsoap_\([0-9][^>]*\)\.zip.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # avoid reconfiguration
    cd '$(1)' && touch configure config.h.in

    # Native build to get tools wsdl2h and soapcpp2
    cd '$(1)' && ./configure

    # Work around parallel build problem
    $(MAKE) -C '$(1)'/gsoap/src -j '$(JOBS)' soapcpp2_yacc.h
    $(MAKE) -C '$(1)'/gsoap -j '$(JOBS)'

    # Install the native tools manually
    $(INSTALL) -m755 '$(1)'/gsoap/wsdl/wsdl2h  '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)wsdl2h'
    $(INSTALL) -m755 '$(1)'/gsoap/src/soapcpp2 '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)soapcpp2'

    $(MAKE) -C '$(1)' -j '$(JOBS)' clean

    # fix hard-coded gnutls dependencies
    $(SED) -i "s/-lgnutls/`'$(MXE_PKG_CONFIG)' --libs-only-l gnutls`/g;" '$(1)/configure'

    # Build for mingw. Static by default.
    # Prevent undefined reference to _rpl_malloc.
    # http://groups.google.com/group/ikarus-users/browse_thread/thread/fd1d101eac32633f
    cd '$(1)' && ac_cv_func_malloc_0_nonnull=yes ./configure \
        --prefix='$(HOST_PREFIX)' \
        $(HOST_AND_BUILD_CONFIGURE_OPTIONS) \
        --enable-gnutls \
        CPPFLAGS='-DWITH_NTLM'

    # Building for mingw requires native soapcpp2
    $(LN_SF) '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)soapcpp2' '$(1)/gsoap/src/soapcpp2'

    # Work around parallel build problem
    $(MAKE) -C '$(1)'/gsoap/src -j '$(JOBS)' soapcpp2_yacc.h AR='$(MXE_AR)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' AR='$(MXE_AR)'

    $(MAKE) -C '$(1)' -j '$(JOBS)' install
    # Apparently there is a tradition of compiling gsoap source files into applications.
    # Since we linked dom.cpp and dom.c into the libraries, this should not be necessary.
    # But we bend to tradition and install these sources into MXE.
    $(INSTALL) -m644 '$(1)/gsoap/'*.c '$(1)/gsoap/'*.cpp '$(HOST_PREFIX)/share/gsoap'
endef
