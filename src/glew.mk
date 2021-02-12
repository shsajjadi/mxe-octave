# This file is part of MXE.
# See index.html for further information.

PKG             := glew
$(PKG)_IGNORE   :=
$(PKG)_VERSION  := 1.9.0
$(PKG)_CHECKSUM := 9291f5c5afefd482c7f3e91ffb3cd4716c6c9ffe
$(PKG)_SUBDIR   := glew-$($(PKG)_VERSION)
$(PKG)_FILE     := glew-$($(PKG)_VERSION).tgz
$(PKG)_URL      := http://$(SOURCEFORGE_MIRROR)/project/glew/glew/$($(PKG)_VERSION)/$($(PKG)_FILE)
$(PKG)_DEPS     :=

define $(PKG)_UPDATE
    $(WGET) -q -O- 'http://sourceforge.net/projects/glew/files/glew/' | \
    $(SED) -n 's,.*glew/\([0-9][^"]*\)/".*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    # Build libGLEW
    cd '$(1)' && $(MXE_CC) -O2 -DGLEW_STATIC -Iinclude -c -o glew.o src/glew.c
    cd '$(1)' && $(MXE_AR) cr libGLEW.a glew.o
    $(MXE_RANLIB) '$(1)/libGLEW.a'
    $(SED) \
        -e "s|@prefix@|$(HOST_PREFIX)|g" \
        -e "s|@libdir@|$(HOST_LIBDIR)|g" \
        -e "s|@exec_prefix@|$(HOST_BINDIR)|g" \
        -e "s|@includedir@|$(HOST_INCDIR)/GL|g" \
        -e "s|@version@|$(glew_VERSION)|g" \
        -e "s|@cflags@|-DGLEW_STATIC|g" \
        -e "s|-l@libname@|-lGLEW -lopengl32|g" \
        < '$(1)'/glew.pc.in > '$(1)'/glew.pc

    # Build libGLEWmx
    cd '$(1)' && $(MXE_CC) -O2 -DGLEW_STATIC -DGLEW_MX -Iinclude -c -o glewmx.o src/glew.c
    cd '$(1)' && $(MXE_AR) cr libGLEWmx.a glewmx.o
    $(MXE_RANLIB) '$(1)/libGLEWmx.a'
    $(SED) \
        -e "s|@prefix@|$(HOST_PREFIX)|g" \
        -e "s|@libdir@|$(HOST_LIBDIR)|g" \
        -e "s|@exec_prefix@|$(HOST_BINDIR)|g" \
        -e "s|@includedir@|$(HOST_INCDIR)/GL|g" \
        -e "s|@version@|$(glew_VERSION)|g" \
        -e "s|@cflags@|-DGLEW_STATIC -DGLEW_MX|g" \
        -e "s|-l@libname@|-lGLEWmx -lopengl32|g" \
        < '$(1)'/glew.pc.in > '$(1)'/glewmx.pc

    # Install
    $(INSTALL) -d '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(HOST_LIBDIR)'
    $(INSTALL) -m644 '$(1)/libGLEW.a' '$(HOST_LIBDIR)/libglew32s.a'
    $(INSTALL) -m644 '$(1)/libGLEWmx.a' '$(HOST_LIBDIR)'
    $(INSTALL) -d '$(HOST_LIBDIR)/pkgconfig'
    $(INSTALL) -m644 '$(1)/glew.pc' '$(HOST_LIBDIR)/pkgconfig/'
    $(INSTALL) -m644 '$(1)/glewmx.pc' '$(HOST_LIBDIR)/pkgconfig/'
    $(INSTALL) -d '$(HOST_INCDIR)'
    $(INSTALL) -d '$(HOST_INCDIR)/GL'
    $(INSTALL) -m644 '$(1)/include/GL/glew.h' '$(1)/include/GL/wglew.h' '$(HOST_INCDIR)/GL/'

    # Test
    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-glew.exe' \
        `'$(MXE_PKG_CONFIG)' glew --cflags --libs`
    '$(MXE_CC)' \
        -W -Wall -Werror -ansi -pedantic \
        '$(2).c' -o '$(HOST_BINDIR)/test-glewmx.exe' \
        `'$(MXE_PKG_CONFIG)' glewmx --cflags --libs`
endef
