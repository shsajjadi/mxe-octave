# This file is part of MXE Octave.
# See index.html for further information.

PKG             := mesa-proto
$(PKG)_VERSION  = $(mesa_VERSION)
$(PKG)_CHECKSUM = $(mesa_CHECKSUM)
$(PKG)_SUBDIR   = $(mesa_SUBDIR)
$(PKG)_FILE     = $(mesa_FILE)
$(PKG)_URL      = $(mesa_URL)
$(PKG)_DEPS     := 

define $(PKG)_UPDATE
    echo 'Warning: Updates are temporarily disabled for package $(PKG).' >&2;
    echo $($(PKG)_VERSION)
endef

ifeq ($(USE_SYSTEM_OPENGL),no)
  define $(PKG)_BUILD
    $(INSTALL) -d '$(3)$(HOST_INCDIR)/GL';
    for f in '$(1)/include/GL/*.h' ; do \
      $(INSTALL) -m 644 $$f '$(3)$(HOST_INCDIR)/GL'; \
    done
    $(INSTALL) -d '$(3)$(HOST_INCDIR)/KHR';
    for f in '$(1)/include/KHR/*.h' ; do \
      $(INSTALL) -m 644 $$f '$(3)$(HOST_INCDIR)/KHR'; \
    done
  endef
else
  define $(PKG)_BUILD
  endef
endif
