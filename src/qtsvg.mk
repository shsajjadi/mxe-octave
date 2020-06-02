# This file is part of MXE.
# See index.html for further information.

PKG             := qtsvg
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 6da4345fcb676f8483c282dee1366db31370775b
$(PKG)_SUBDIR    = $(subst qtbase,qtsvg,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qtsvg,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qtsvg,$(qtbase_URL))
$(PKG)_DEPS     := qtbase

define $(PKG)_UPDATE
    echo $(qtbase_VERSION)
endef

define $(PKG)_BUILD
    cd '$(1)' && '$(MXE_QMAKE)'
    $(MAKE) -C '$(1)' -j '$(JOBS)'
    $(MAKE) -C '$(1)' -j 1 install

    if [ $(MXE_WINDOWS_BUILD) = yes ]; then \
      $(INSTALL) -d '$(HOST_BINDIR)'; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Svgd.dll '$(HOST_BINDIR)'/Qt5Svgd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Svg.dll '$(HOST_BINDIR)'/Qt5Svg.dll; \
    fi
endef
