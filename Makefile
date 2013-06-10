# This file is part of MXE.
# See index.html for further information.

PWD := $(shell pwd)

## Configuration variables.

# Set the following configuration variables with a configure script?

# Current valid values are mingw (cross) and gnu-linux (native).
MXE_SYSTEM := mingw
#MXE_SYSTEM := gnu-linux

# Set to "no" if doing a cross compile build.
MXE_NATIVE_BUILD := no
#MXE_NATIVE_BUILD := yes

# Set to "yes" to use the versions of GCC and binutils already
# installed on your system.  NOTE: building a copy of GCC for a
# native build does not appear to work correctly yet, so for now you
# must set USE_SYSTEM_GCC to yes if MXE_NATIVE_BUILD is set to yes.
USE_SYSTEM_GCC := no
#USE_SYSTEM_GCC := yes

# Should match what config.guess prints for your system.
# If cross compiling, you must set it manually.
ifeq ($(MXE_NATIVE_BUILD),yes)
  TARGET := $(shell tools/config.guess)
else
  TARGET := i686-pc-mingw32
endif
BUILD_SYSTEM := $(shell tools/config.guess)

# Enable shared or static libs, or perhaps both.  At least one 
# package uses --with instead of --enable.  Probably it doesn't
# make sense to disable both...
BUILD_SHARED := yes
BUILD_STATIC := no

USE_PIC_FLAG := no
#USE_PIC_FLAG := yes

# Attempt to build Octave and dependencies with 64-bit indexing enabled.
ENABLE_64 := no
#ENABLE_64 := yes

## end of configuration variables.

ifneq ($(MXE_NATIVE_BUILD),yes)
  HOST_AND_BUILD_CONFIGURE_OPTIONS := \
    --host='$(TARGET)' --build='$(BUILD_SYSTEM)'
endif

# are we doing a native mingw build ?
ifeq ($(MXE_NATIVE_BUILD),yes)
  ifeq ($(MXE_SYSTEM),mingw)
    MXE_NATIVE_MINGW_BUILD := yes
  endif
endif

# These can't be chosen arbitrarily.  The way things are configured now,
# GCC expects to find cross-compiler include files in $(PREFIX)/$(TARGET).
# and it's not clear to me how to change that.
BUILD_TOOLS_PREFIX := $(PWD)/usr
HOST_PREFIX := $(PWD)/usr/$(TARGET)

ifeq ($(BUILD_SHARED),yes)
  ifeq ($(BUILD_STATIC),yes)
    ENABLE_SHARED_OR_STATIC := --enable-shared --enable-static
    WITH_SHARED_OR_STATIC := --with-shared --with-static
  else
    ENABLE_SHARED_OR_STATIC := --enable-shared --disable-static
    WITH_SHARED_OR_STATIC := --with-shared --without-static
  endif
else
  ENABLE_SHARED_OR_STATIC := --disable-shared --enable-static
  WITH_SHARED_OR_STATIC := --without-shared --with-static
endif

ifeq ($(USE_PIC_FLAG),yes)
  MXE_CC_PICFLAG := -fPIC
  MXE_CXX_PICFLAG := -fPIC
  MXE_F77_PICFLAG := -fPIC
endif

JOBS               := 1
SOURCEFORGE_MIRROR := freefr.dl.sourceforge.net
PKG_MIRROR         := s3.amazonaws.com/mxe-pkg
PKG_CDN            := d1yihgixbnrglp.cloudfront.net

SHELL      := bash

INSTALL    := $(shell ginstall --help >/dev/null 2>&1 && echo g)install
PATCH      := $(shell gpatch --help >/dev/null 2>&1 && echo g)patch
SED        := $(shell gsed --help >/dev/null 2>&1 && echo g)sed
WGET       := wget --no-check-certificate \
                   --user-agent=$(shell wget --version | \
                   $(SED) -n 's,GNU \(Wget\) \([0-9.]*\).*,\1/\2,p')

REQUIREMENTS := bash bzip2 gcc $(MAKE) openssl $(PATCH) $(PERL) \
                $(SED) unzip wget xz

LIBTOOL     := libtool
LIBTOOLIZE  := libtoolize
BUILD_TOOLS := $(patsubst src/%.mk, %, $(wildcard src/build-*.mk))
# Building flex for native mingw fails, so disable it.
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  BUILD_TOOLS := $(filter-out build-flex, $(BUILD_TOOLS))
endif

STAMP_DIR  := $(PWD)/installed-packages
MSYS_INFO_DIR := $(PWD)/msys-info
LOG_DIR    := $(PWD)/log
TIMESTAMP  := $(shell date +%Y%m%d_%H%M%S)
PKG_DIR    := $(PWD)/pkg
TMP_DIR     = $(PWD)/tmp-$(1)
TOP_DIR    := $(PWD)
MAKEFILE   := $(TOP_DIR)/Makefile
PKGS       := $(filter-out $(BUILD_TOOLS), $(shell $(SED) -n 's/^.* id="\([^"]*\)-package">.*$$/\1/p' '$(TOP_DIR)/index.html'))
PATH       := $(BUILD_TOOLS_PREFIX)/bin:$(PATH)

CONFIGURE_CPPFLAGS := CPPFLAGS='-I$(HOST_PREFIX)/include'
CONFIGURE_LDFLAGS := LDFLAGS='-L$(HOST_PREFIX)/lib'

ifeq ($(MXE_NATIVE_BUILD),yes)
  MXE_TOOL_PREFIX := 
  MXE_AR := ar
  MXE_RANLIB := ranlib
  MXE_CC := gcc
  MXE_CXX := g++
  MXE_F77 := gfortran
  MXE_DLLTOOL := dlltool
  MXE_NM := nm
  MXE_STRIP := strip
  ifeq ($(MXE_SYSTEM),mingw)
    MXE_WINDRES := windres
  else
    MXE_WINDRES := true
  endif
  MXE_PKG_CONFIG := pkg-config
  MXE_QMAKE := qmake
else
  MXE_TOOL_PREFIX := $(TARGET)-
  MXE_AR := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)ar'
  MXE_RANLIB := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)ranlib'
  MXE_CC := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)gcc'
  MXE_CXX := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)g++'
  MXE_F77 := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)gfortran'
  MXE_DLLTOOL := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)dlltool'
  MXE_NM := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)nm'
  MXE_STRIP := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)strip'
  ifeq ($(MXE_SYSTEM),mingw)
    MXE_WINDRES := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)windres'
  else
    MXE_WINDRES := true
  endif
  MXE_PKG_CONFIG := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)pkg-config'
  MXE_QMAKE := '$(BUILD_TOOLS_PREFIX)/bin/$(MXE_TOOL_PREFIX)qmake'
endif

ifeq ($(MXE_SYSTEM),mingw)
  MAKE_SHARED_FROM_STATIC_OPTIONS := --windowsdll
endif

HOST_BINDIR := '$(HOST_PREFIX)/bin'
HOST_LIBDIR := '$(HOST_PREFIX)/lib'
HOST_INCDIR := '$(HOST_PREFIX)/include'

ifeq ($(MXE_SYSTEM),mingw)
  ifneq ($(MXE_NATIVE_BUILD),yes)
    MSYS_BASE_URL := http://sourceforge.net/projects/mingw/files/MSYS/Base
    MSYS_BASE_VER := 1.0.13
    MSYS_BASE_DIR := $(TOP_DIR)/msys-base
    MSYS_BASE_PACKAGES := $(addprefix msys-,bash coreutils diffutils file findutils gawk grep gzip less libiconv libintl libmagic make msys-core regex sed tar termcap)

    NOTEPAD_BASE_DIR := $(TOP_DIR)/notepad++
  endif
else
  LD_LIBRARY_PATH := '$(HOST_LIBDIR)'
  export LD_LIBRARY_PATH
  MXE_CPPFLAGS := '-I$(HOST_INCDIR)'
  MXE_LDFLAGS := '-L$(HOST_LIBDIR)'
endif

LN := ln
LN_S := $(LN) -s
LN_SF := $(LN_S) -f
ifeq ($(MXE_SYSTEM),mingw)
  ifeq ($(MXE_NATIVE_BUILD),yes)
    LN := cp
    LN_S := $(LN)
    LN_SF := $(LN_S)
  endif
endif

OCTAVE_FORGE_BASE_URL := 'http://sourceforge.net/projects/octave/files/Octave Forge Packages/Individual Package Releases'
OCTAVE_FORGE_PACKAGES := $(addprefix of-,miscellaneous struct optim specfun general signal communications image io statistics control)

MAKE_SHARED_FROM_STATIC := \
  $(TOP_DIR)/tools/make-shared-from-static $(MAKE_SHARED_FROM_STATIC_OPTIONS)

CMAKE_TOOLCHAIN_FILE := $(HOST_PREFIX)/share/cmake/mxe-conf.cmake

# unexport any environment variables that might cause trouble
unexport AR CC CFLAGS C_INCLUDE_PATH CPATH CPLUS_INCLUDE_PATH CPP
unexport CPPFLAGS CROSS CXX CXXCPP CXXFLAGS EXEEXT EXTRA_CFLAGS
unexport EXTRA_LDFLAGS LD LDFLAGS LIBRARY_PATH LIBS NM
unexport OBJC_INCLUDE_PATH PKG_CONFIG QMAKESPEC RANLIB STRIP

# mingw on windows ignores the compiled in pc-path so we need to tell pkg-config where it is
ifeq ($(MXE_NATIVE_MINGW_BUILD),yes)
  export PKG_CONFIG_PATH='$(HOST_LIBDIR)/pkgconfig'
endif

SHORT_PKG_VERSION = \
    $(word 1,$(subst ., ,$($(1)_VERSION))).$(word 2,$(subst ., ,$($(1)_VERSION)))

UNPACK_ARCHIVE = \
    $(if $(filter %.tgz,     $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.gz,  $(1)),tar xzf '$(1)', \
    $(if $(filter %.tar.bz2, $(1)),tar xjf '$(1)', \
    $(if $(filter %.tar.lzma,$(1)),xz -dc -F lzma '$(1)' | tar xf -, \
    $(if $(filter %.tar.xz,$(1)),xz -dc '$(1)' | tar xf -, \
    $(if $(filter %.zip,     $(1)),unzip -q '$(1)', \
    $(error Unknown archive format: $(1))))))))

UNPACK_PKG_ARCHIVE = \
    $(call UNPACK_ARCHIVE,$(PKG_DIR)/$($(1)_FILE))

PKG_CHECKSUM = \
    openssl sha1 '$(PKG_DIR)/$($(1)_FILE)' 2>/dev/null | $(SED) -n 's,^.*\([0-9a-f]\{40\}\)$$,\1,p'

CHECK_PKG_ARCHIVE = \
    [ '$($(1)_CHECKSUM)' == "`$$(call PKG_CHECKSUM,$(1))`" ]

DOWNLOAD_PKG_ARCHIVE = \
    mkdir -p '$(PKG_DIR)' && \
    $(if $($(1)_URL_2), \
        ( $(WGET) -T 30 -t 3 -O- '$($(1)_URL)' || \
          $(WGET) -O- '$($(1)_URL_2)' || \
          $(WGET) -O- '$(PKG_MIRROR)/$($(1)_FILE)' || \
          $(WGET) -O- '$(PKG_CDN)/$($(1)_FILE)' ), \
        ( $(WGET) -O- '$($(1)_URL)' || \
          $(WGET) -O- '$(PKG_MIRROR)/$($(1)_FILE)' || \
          $(WGET) -O- '$(PKG_CDN)/$($(1)_FILE)' )) \
    $(if $($(1)_FIX_GZIP), \
        | gzip -d | gzip -9n, \
        ) \
    > '$(PKG_DIR)/$($(1)_FILE)' || rm -f '$(PKG_DIR)/$($(1)_FILE)'

ifeq ($(IGNORE_SETTINGS),yes)
    $(info [ignore settings.mk])
else ifeq ($(wildcard $(PWD)/settings.mk),$(PWD)/settings.mk)
    include $(PWD)/settings.mk
else
    $(info [create settings.mk])
    $(shell { \
        echo '#JOBS = $(JOBS)'; \
        echo '#PKGS ='; \
    } >'$(PWD)/settings.mk')
endif

.PHONY: all
all: octave

.PHONY: all-packages
all-packages: $(PKGS)

$(PKGS): $(BUILD_TOOLS)

.PHONY: msys-base
msys-base:  $(MSYS_BASE_PACKAGES)

.PHONY: octave-forge-packages
octave-forge-packages: $(OCTAVE_FORGE_PACKAGES)

.PHONY: check-requirements
define CHECK_REQUIREMENT
    @if ! $(1) --help &>/dev/null; then \
        echo; \
        echo 'Missing requirement: $(1)'; \
        echo; \
        echo 'Please have a look at "index.html" to ensure'; \
        echo 'that your system meets all requirements.'; \
        echo; \
        exit 1; \
    fi

endef
define CHECK_REQUIREMENT_VERSION
    @if ! $(1) --version | head -1 | grep ' \($(2)\)$$' >/dev/null; then \
        echo; \
        echo 'Wrong version of requirement: $(1)'; \
        echo; \
        echo 'Please have a look at "index.html" to ensure'; \
        echo 'that your system meets all requirements.'; \
        echo; \
        exit 1; \
    fi

endef
check-requirements: $(STAMP_DIR)/check-requirements
$(STAMP_DIR)/check-requirements: $(MAKEFILE)
	@echo '[check requirements]'
	$(foreach REQUIREMENT,$(REQUIREMENTS),$(call CHECK_REQUIREMENT,$(REQUIREMENT)))
	@[ -d '$(STAMP_DIR)' ] || mkdir -p '$(STAMP_DIR)'
	@if test "$(USE_SYSTEM_GCC)" = yes; then \
	  $(INSTALL) -d '$(BUILD_TOOLS_PREFIX)/bin' ; \
	  $(INSTALL) -m 755 tools/config.guess '$(BUILD_TOOLS_PREFIX)/bin/config.guess' ; \
	  $(INSTALL) -m 755 tools/config.sub '$(BUILD_TOOLS_PREFIX)/bin/config.sub' ; \
	fi
	@touch '$@'

define newline


endef
$(eval $(subst #,$(newline),$(shell \
    $(SED) -n \
        's/^.* id="\([A-Za-z0-9_+-]*\)-version">\([^<]*\)<.*$$/\1_VERSION := \2#/p' \
        '$(TOP_DIR)/index.html' \
)))

include $(patsubst %,$(TOP_DIR)/src/%.mk,$(BUILD_TOOLS))
include $(patsubst %,$(TOP_DIR)/src/%.mk,$(PKGS))

.PHONY: download
download: $(addprefix download-,$(PKGS)) $(addprefix download-,$(BUILD_TOOLS))

define PKG_RULE
.PHONY: download-$(1)
download-$(1): $(addprefix download-,$($(1)_DEPS))
	if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    $(call DOWNLOAD_PKG_ARCHIVE,$(1)); \
	    $(call CHECK_PKG_ARCHIVE,$(1)) || { echo 'Wrong checksum!'; exit 1; }; \
	fi

.PHONY: $(1)
$(1): $(STAMP_DIR)/$(1)
$(STAMP_DIR)/$(1): $(TOP_DIR)/src/$(1).mk \
                          $(wildcard $(TOP_DIR)/src/$(1)-*.patch) \
                          $(wildcard $(TOP_DIR)/src/$(1)-test*) \
                          $(addprefix $(STAMP_DIR)/,$($(1)_DEPS)) \
                          | check-requirements
	@[ -d '$(LOG_DIR)/$(TIMESTAMP)' ] || mkdir -p '$(LOG_DIR)/$(TIMESTAMP)'
	@if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	    echo '[download] $(1)'; \
	    touch '$(LOG_DIR)/$(TIMESTAMP)/$(1)-download'; \
	    ln -sf '$(TIMESTAMP)/$(1)-download' '$(LOG_DIR)/$(1)-download'; \
	    ($(call DOWNLOAD_PKG_ARCHIVE,$(1))) &> '$(LOG_DIR)/$(1)-download'; \
	    if ! $(call CHECK_PKG_ARCHIVE,$(1)); then \
	        echo; \
	        echo 'Wrong checksum of package $(1)!'; \
	        echo '------------------------------------------------------------'; \
	        tail -n 10 '$(LOG_DIR)/$(1)-download' | $(SED) -n '/./p'; \
	        echo '------------------------------------------------------------'; \
	        echo '[log]      $(LOG_DIR)/$(1)-download'; \
	        echo; \
	        exit 1; \
	    fi; \
	fi
	$(if $(value $(1)_BUILD),
	    @echo '[build]    $(1)'
	    ,)
	@touch '$(LOG_DIR)/$(TIMESTAMP)/$(1)'
	@ln -sf '$(TIMESTAMP)/$(1)' '$(LOG_DIR)/$(1)'
	@if ! (time $(MAKE) -f '$(MAKEFILE)' 'build-only-$(1)') &> '$(LOG_DIR)/$(1)'; then \
	    echo; \
	    echo 'Failed to build package $(1)!'; \
	    echo '------------------------------------------------------------'; \
	    tail -n 10 '$(LOG_DIR)/$(1)' | $(SED) -n '/./p'; \
	    echo '------------------------------------------------------------'; \
	    echo '[log]      $(LOG_DIR)/$(1)'; \
	    echo; \
	    exit 1; \
	fi
	@echo '[done]     $(1)'

.PHONY: build-only-$(1)
build-only-$(1): PKG = $(1)
build-only-$(1):
	$(if $(value $(1)_BUILD),
	    rm -rf   '$(2)'
	    mkdir -p '$(2)'
	    cd '$(2)' && $(call UNPACK_PKG_ARCHIVE,$(1))
	    cd '$(2)/$($(1)_SUBDIR)'
	    $(foreach PKG_PATCH,$(sort $(wildcard $(TOP_DIR)/src/$(1)-*.patch)),
	        (cd '$(2)/$($(1)_SUBDIR)' && $(PATCH) -p1 -u) < $(PKG_PATCH))
	    $$(call $(1)_BUILD,$(2)/$($(1)_SUBDIR),$(TOP_DIR)/src/$(1)-test)
	    (du -k -d 0 '$(2)' 2>/dev/null || du -k --max-depth 0 '$(2)') | $(SED) -n 's/^\(\S*\).*/du: \1 KiB/p'
	    rm -rfv  '$(2)'
	    ,)
	[ -d '$(STAMP_DIR)' ] || mkdir -p '$(STAMP_DIR)'
	touch '$(STAMP_DIR)/$(1)'
endef
$(foreach PKG,$(PKGS),$(eval $(call PKG_RULE,$(PKG),$(call TMP_DIR,$(PKG)))))
$(foreach TOOL,$(BUILD_TOOLS),$(eval $(call PKG_RULE,$(TOOL),$(call TMP_DIR,$(TOOL)))))

.PHONY: clean
clean:
	rm -rf $(call TMP_DIR,*) $(BUILD_TOOLS_PREFIX)
	rm -rf $(STAMP_DIR) $(MSYS_INFO_DIR) $(LOG_DIR)
	rm -rf $(MSYS_BASE_DIR) $(NOTEPAD_BASE_DIR)
	rm -rf native-tools cross-tools octave gnuplot

.PHONY: clean-pkg
clean-pkg:
	rm -f $(patsubst %,'%', \
                  $(filter-out \
                      $(foreach PKG,$(PKGS),$(PKG_DIR)/$($(PKG)_FILE)), \
                      $(wildcard $(PKG_DIR)/*)))

.PHONY: update
define UPDATE
    $(if $(2),
        $(if $(filter $(2),$($(1)_IGNORE)),
            $(info IGNORED  $(1)  $(2)),
            $(if $(filter $(2),$($(1)_VERSION)),
                $(info .        $(1)  $(2)),
                $(info NEW      $(1)  $($(1)_VERSION) --> $(2))
                $(SED) -i 's/\( id="$(1)-version"\)>[^<]*/\1>$(2)/' '$(TOP_DIR)/index.html'
                $(MAKE) -f '$(MAKEFILE)' 'update-checksum-$(1)' \
                    || { $(SED) -i 's/\( id="$(1)-version"\)>[^<]*/\1>$($(1)_VERSION)/' '$(TOP_DIR)/index.html'; \
                         exit 1; })),
        $(error Unable to update version number of package $(1)))

endef
update:
	$(foreach PKG,$(PKGS),$(call UPDATE,$(PKG),$(shell $($(PKG)_UPDATE))))

update-checksum-%:
	$(call DOWNLOAD_PKG_ARCHIVE,$*)
	$(SED) -i 's/^\([^ ]*_CHECKSUM *:=\).*/\1 '"`$(call PKG_CHECKSUM,$*)`"'/' '$(TOP_DIR)/src/$*.mk'

cleanup-style:
	@$(foreach FILE,$(wildcard $(addprefix $(TOP_DIR)/,Makefile index.html CNAME src/*.mk src/*test.* tools/*)),\
            $(SED) ' \
                s/\r//g; \
                s/[ \t]\+$$//; \
                s,^#!/bin/bash$$,#!/usr/bin/env bash,; \
                $(if $(filter %Makefile,$(FILE)),,\
                    s/\t/    /g; \
                ) \
            ' < $(FILE) > $(TOP_DIR)/tmp-cleanup-style; \
            diff -u $(FILE) $(TOP_DIR)/tmp-cleanup-style >/dev/null \
                || { echo '[cleanup] $(FILE)'; \
                     cp $(TOP_DIR)/tmp-cleanup-style $(FILE); }; \
            rm -f $(TOP_DIR)/tmp-cleanup-style; \
        )

