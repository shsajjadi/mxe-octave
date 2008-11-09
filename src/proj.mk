# proj
# http://trac.osgeo.org/proj/

PKG            := proj
$(PKG)_VERSION := 4.6.0
$(PKG)_SUBDIR  := proj-$($(PKG)_VERSION)
$(PKG)_FILE    := proj-$($(PKG)_VERSION).tar.gz
$(PKG)_URL     := ftp://ftp.remotesensing.org/proj/$($(PKG)_FILE)
$(PKG)_URL_2   := http://download.osgeo.org/proj/$($(PKG)_FILE)
$(PKG)_DEPS    := gcc

define $(PKG)_UPDATE
    wget -q -O- 'http://www.remotesensing.org/proj/' | \
    $(SED) -n 's,.*proj-\([0-9][^>]*\)\.tar.*,\1,p' | \
    head -1
endef

define $(PKG)_BUILD
    $(SED) 's,install-exec-local[^:],,' -i '$(1)/src/Makefile.in'
    cd '$(1)' && ./configure \
        --host='$(TARGET)' \
        --disable-shared \
        --prefix='$(PREFIX)/$(TARGET)'
    $(MAKE) -C '$(1)' -j '$(JOBS)' install bin_PROGRAMS= sbin_PROGRAMS= noinst_PROGRAMS=
endef
