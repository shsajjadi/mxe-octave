# This file is part of mingw-cross-env.
# See doc/index.html for further information.

# zlib
PKG				:= ocaml-native
$(PKG)_IGNORE	:=
$(PKG)_VERSION  := 4.00.0
$(PKG)_CHECKSUM := 9653e76dd14f0fbb750d7b438415890ab9fe2f4e
$(PKG)_SUBDIR	:= ocaml-$($(PKG)_VERSION)
$(PKG)_FILE		:= ocaml-$($(PKG)_VERSION).tar.gz
$(PKG)_URL		:= http://caml.inria.fr/pub/distrib/ocaml-4.00/$($(PKG)_FILE)
$(PKG)_DEPS		:=

define $(PKG)_UPDATE
	wget -q -O- 'http://caml.inria.fr/pub/distrib/ocaml-3.12' | \
	$(SED) -n 's,.*ocaml-\([0-9][^>]*\)\.tar.*,\1,ip' | \
	tail -1
endef

define $(PKG)_BUILD
	# patched ocaml source to get ocamlbuild use $(MXE_TOOL_PREFIX)ocamlc, $(MXE_TOOL_PREFIX)ocamlfind, ...
	cd '$(1)' && ./configure \
		-prefix '$(HOST_PREFIX)' \
		-bindir '$(HOST_BINDIR)/ocaml-native' \
		-libdir '$(HOST_LIBDIR)/ocaml-native' \
		-no-tk \
		-no-shared-libs \
		-verbose
	$(MAKE) -C '$(1)' -j 1 world opt
	$(SED) -i "s,@target@,$(TARGET),g" $(1)/ocamlbuild/options.ml
	$(SED) -i "s,@target@,$(TARGET),g" $(1)/ocamlbuild/findlib.ml
	$(MAKE) -C '$(1)' -j '$(JOBS)' ocamlbuild.native
	cp -f '$(1)/_build/ocamlbuild/ocamlbuild.native' $(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)ocamlbuild
	$(MAKE) -C '$(1)' install
	# the following script requires ocamlbuild with option -ocamlfind to work
	#(echo '#!/bin/sh'; \
	# echo 'exec $(BUILD_TOOLS_PREFIX)/bin/ocamlbuild -use-ocamlfind -ocamlfind $(MXE_TOOL_PREFIX)ocamlfind "$$@"') \
	# > '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)ocamlbuild'
	#chmod 0755 '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)ocamlbuild'
	# test will be done once cross ocamlopt is built
endef
