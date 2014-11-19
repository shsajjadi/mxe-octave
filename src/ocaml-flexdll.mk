# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# zlib
PKG				:= ocaml-flexdll
$(PKG)_IGNORE	:=
$(PKG)_VERSION  := 0.30
$(PKG)_CHECKSUM := 585f066f890c7dca95be7541b4647128335f7df9
$(PKG)_SUBDIR	:= flexdll
$(PKG)_FILE		:= flexdll-$($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= http://alain.frisch.fr/flexdll/$($(PKG)_FILE)
$(PKG)_DEPS		:= ocaml-native

define $(PKG)_UPDATE
	wget -q -O- 'http://alain.frisch.fr/flexdll/' | \
	$(SED) -n 's,.*flexdll-\([0-9][^>]*\)\.tar.gz.*,\1,ip' | \
	head -1
endef

define $(PKG)_BUILD
	$(MAKE) -C '$(1)' -j '$(JOBS)' \
		CHAINS=mingw \
		MINGW_PREFIX=$(TARGET) \
		OCAMLOPT=$(HOST_BINDIR)/ocaml-native/ocamlopt \
		all
	mkdir -p '$(HOST_LIBDIR)/ocaml/flexdll'
	cd '$(1)' && mv flexlink.exe flexlink
	cd '$(1)' && strip --remove-section=.comment --remove-section=.note flexlink
	cd '$(1)' && $(INSTALL) -m 0755 flexdll.h '$(HOST_INCDIR)'
	cd '$(1)' && $(INSTALL) -m 0755 flexlink flexdll_mingw.o \
		flexdll_initer_mingw.o \
		'$(HOST_LIBDIR)/ocaml/flexdll'
	# create flexdll scripts
	cd '$(BUILD_TOOLS_PREFIX)/bin' && $(LN_SF) '$(HOST_LIBDIR)/ocaml/flexdll/flexlink'
	(echo '#!/bin/sh'; \
	 echo 'exec flexlink -I $(HOST_LIBDIR) -chain mingw -nocygpath "$$@"') \
			> '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)flexlink'
	chmod 0755 '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)flexlink'

	echo "testing flexlink..."
	$(MAKE) -C '$(1)/test' -j '$(JOBS)' dump.exe plug1.dll plug2.dll CC=$(MXE_CC) O=o FLEXLINK=$(MXE_TOOL_PREFIX)flexlink
	#works if wine is installed :
	#cd '$(1)/test' && ./dump.exe plug1.dll plug2.dll
endef
