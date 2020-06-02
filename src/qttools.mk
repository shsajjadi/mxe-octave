# This file is part of MXE.
# See index.html for further information.

PKG             := qttools
$(PKG)_IGNORE   :=
$(PKG)_VERSION   = $(qtbase_VERSION)
$(PKG)_CHECKSUM := 9b5ea97ebe7e3e3be118060b42293c4237a465de
$(PKG)_SUBDIR    = $(subst qtbase,qttools,$(qtbase_SUBDIR))
$(PKG)_FILE      = $(subst qtbase,qttools,$(qtbase_FILE))
$(PKG)_URL       = $(subst qtbase,qttools,$(qtbase_URL))
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
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5CLucened.dll '$(HOST_BINDIR)'/Qt5CLucened.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5CLucene.dll '$(HOST_BINDIR)'/Qt5CLucene.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Helpd.dll '$(HOST_BINDIR)'/Qt5Helpd.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/Qt5Help.dll '$(HOST_BINDIR)'/Qt5Help.dll; \
      mv '$(HOST_PREFIX)'/qt5/bin/qdbus.exe '$(HOST_BINDIR)'/qdbus.exe; \
      mv '$(HOST_PREFIX)'/qt5/bin/qdbusviewer.exe '$(HOST_BINDIR)'/qdbusviewer.exe; \
      mv '$(HOST_PREFIX)'/qt5/bin/qtdiag.exe '$(HOST_BINDIR)'/qtdiag.exe; \
      mv '$(HOST_PREFIX)'/qt5/bin/qtpaths.exe '$(HOST_BINDIR)'/qtpaths.exe; \
      mv '$(HOST_PREFIX)'/qt5/bin/qtplugininfo.exe '$(HOST_BINDIR)'/qtplugininfo.exe; \
    fi
endef

