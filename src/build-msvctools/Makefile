TARGETS = \
	ar-msvc \
	cc-msvc.exe \
	clgcc.exe \
	clg++.exe \
	clgfortran.exe \
	dirent.h \
	getopt.h \
	posixcompat.lib \
	inttypes.h \
	lt-postproc \
	ranlib-msvc \
	stdbool.h \
	unistd.h \
	compat/mingwcompat.lib \
	math/msvcmath.lib \
	gfortran-msvc.exe \
	gfortran-msvc.lib \
	gfortran-msvc-static.lib \
	Windows-clgcc.cmake

MSVCSTDINT := $(shell echo '\#include <stdint.h>' > t.c; cl -nologo -showIncludes -c t.c | $(SED) -n -e 's/^Note: including file: \(.*stdint\.h\)$$/\1/p'; rm -f t.c t.obj)
ifeq ($(MSVCSTDINT),)
TARGETS += stdint.h
endif

.PHONY: all
all: $(TARGETS)

cc-msvc.exe: cc-msvc.cc
	cl -nologo -O2 -EHsc cc-msvc.cc

clgcc.exe clg++.exe: cc-msvc.exe
	cp -a $< $@

fixlibtool2: fixlibtool2.in
	$(SED) \
		-e "s/@LIBRARY_PREFIX@/$(LIBRARY_PREFIX)/" \
		-e "s/@LIBRARY_SUFFIX@/$(LIBRARY_SUFFIX)/" $< > $@

stdint.h inttypes.h:
	$(WGET) http://msinttypes.googlecode.com/svn/trunk/$@

dirent.h:
	$(WGET) -O $@ 'http://sourceforge.net/p/mingw/mingw-org-wsl/ci/master/tree/include/dirent.h?format=raw'
	$(SED) -i -e 's/FILENAME_MAX/260/g' \
		-e 's/__MINGW_NOTHROW//g' \
		-e 's,^.*_mingw\.h.*$$,/*&*/,' \
		-e 's/_A_VOLID/0x00/g' \
		$@

dirent.c:
	$(WGET) -O $@ 'http://sourceforge.net/p/mingw/mingw-org-wsl/ci/master/tree/src/libcrt/tchar/dirent.c?format=raw'

dirent.obj: dirent.c dirent.h
	cl -nologo -O2 -MD -I. \
		-DFILENAME_MAX=260 \
		-Dinline=__inline \
		-D_TDIR=DIR \
		-D_tdirent=dirent \
		-D_topendir=opendir \
		-D_tclosedir=closedir \
		-D_treaddir=readdir \
		-D_trewinddir=rewinddir \
		-D_tseekdir=seekdir \
		-D_ttelldir=telldir \
		-c dirent.c -Fo$@

wdirent.obj: dirent.c dirent.h
	cl -nologo -O2 -MD -I. \
		-D_UNICODE \
		-DFILENAME_MAX=260 \
		-Dinline=__inline \
		-D_osver=GetVersion\(\) \
		-D_TDIR=_WDIR \
		-D_tdirent=_wdirent \
		-D_topendir=_wopendir \
		-D_tclosedir=_wclosedir \
		-D_treaddir=_wreaddir \
		-D_trewinddir=_wrewinddir \
		-D_tseekdir=_wseekdir \
		-D_ttelldir=_wtelldir \
		-c dirent.c -Fo$@

getopt.h:
	$(WGET) -O $@ 'http://sourceforge.net/p/mingw-w64/code/HEAD/tree/trunk/mingw-w64-headers/crt/getopt.h?format=raw'
	$(SED) -i -e 's,^.*crtdefs\.h.*$$,/*&*/,' $@

getopt.c:
	$(WGET) -O $@ 'http://sourceforge.net/p/mingw-w64/code/HEAD/tree/trunk/mingw-w64-crt/misc/getopt.c?format=raw'

getopt.obj: getopt.c getopt.h
	cl -nologo -O2 -MD -I. -c $< -Fo$@

posixcompat.lib: dirent.obj wdirent.obj getopt.obj
	lib -out:$@ $^

compat/mingwcompat.lib:
	$(MAKE) -C compat

math/msvcmath.lib:
	$(MAKE) -C math SED='$(SED)'

math/msvcmath.h: math/msvcmath.lib

gfortran-msvc.exe: gfortran-msvc.cc
	cl -nologo -O2 -EHsc gfortran-msvc.cc

clgfortran.exe: gfortran-msvc.exe
	cp -a $< $@

gfortran-msvc-gcc-patch.stamp:
	(cd ../gcc-$(GCCVERSION)/ && patch -p1) < gcc.diff
	(cd ../gcc-$(GCCVERSION)/ && \
		cp libgcc/config/i386/gthr-win32.h libgcc/gthr-default.h)
	touch $@

gfortran-msvc-build:
	mkdir $@

gfortran-msvc-build/.libs/libgfortran.a: gfortran-msvc-gcc-patch.stamp gfortran-msvc-build
	cd gfortran-msvc-build && \
		../../gcc-$(GCCVERSION)/libgfortran/configure \
		--disable-libquadmath-support \
		--disable-shared \
		--enable-static \
		--disable-multilib \
		CFLAGS="-O2 -mstackrealign -mincoming-stack-boundary=2" \
		FCFLAGS="-O3 -ff2c -mstackrealign -mincoming-stack-boundary=2"
	$(MAKE) -C gfortran-msvc-build

gfortran.lst: gfortran-msvc-build/.libs/libgfortran.a
	ar x $<
	ar t $< > $@

gfortran.def: gfortran.lst
	(echo 'EXPORTS'; nm -C @$< | grep ' T _gfortran_' | cut -d' ' -f3) > $@

libgfortran-dllinit.o: libgfortran-dllinit.c cc-msvc.exe
	cc-msvc -O2 -c $< -o $@

libgfortran-msvcinit.o: libgfortran-msvcinit.c cc-msvc.exe
	cc-msvc -O2 -c $< -o $@

gfortran-msvc.lib: gfortran-msvc-build/.libs/libgfortran.a gfortran.def gfortran.lst \
		   compat/mingwcompat.lib cc-msvc.exe libgfortran-dllinit.o
	cc-msvc -shared -o $(LIBRARY_PREFIX)gfortran-msvc$(LIBRARY_SUFFIX).dll \
		libgfortran-dllinit.o @gfortran.lst -Wl,-def:gfortran.def -Wl,-implib:gfortran-msvc.lib \
		-Lcompat -Lmath -lmingwcompat -ladvapi32

gfortran-msvc-static.lib: gfortran-msvc-build/.libs/libgfortran.a gfortran.lst libgfortran-msvcinit.o
	lib -out:$@ libgfortran-msvcinit.o @gfortran.lst

Windows-clgcc.cmake: Windows-clgcc.cmake.in
	$(SED) -e 's/@@LIBRARY_PREFIX@@/$(LIBRARY_PREFIX)/g' \
	       -e 's/@@LIBRARY_SUFFIX@@/$(LIBRARY_SUFFIX)/g' $< > $@

.PHONY: install
install: all
	$(INSTALL) -d $(DESTDIR)/bin
	$(INSTALL) ar-msvc $(DESTDIR)/bin/
	$(INSTALL) cc-msvc.exe $(DESTDIR)/bin/
	$(INSTALL) clgcc.exe $(DESTDIR)/bin/
	$(INSTALL) clg++.exe $(DESTDIR)/bin/
	$(INSTALL) lt-postproc $(DESTDIR)/bin/
	$(INSTALL) gfortran-msvc.exe $(DESTDIR)/bin/
	$(INSTALL) clgfortran.exe $(DESTDIR)/bin/
	$(INSTALL) ranlib-msvc $(DESTDIR)/bin/
	$(INSTALL) $(LIBRARY_PREFIX)gfortran-msvc$(LIBRARY_SUFFIX).dll $(DESTDIR)/bin/
	$(INSTALL) -d $(DESTDIR)/include
	test -n "$(MSVCSTDINT)" || $(INSTALL) stdint.h $(DESTDIR)/include
	$(INSTALL) inttypes.h $(DESTDIR)/include
	$(INSTALL) unistd.h $(DESTDIR)/include
	$(INSTALL) stdbool.h $(DESTDIR)/include
	$(INSTALL) dirent.h $(DESTDIR)/include
	$(INSTALL) getopt.h $(DESTDIR)/include
	$(INSTALL) math/msvcmath.h $(DESTDIR)/include/math.h
	$(INSTALL) -d $(DESTDIR)/lib
	$(INSTALL) posixcompat.lib $(DESTDIR)/lib
	$(INSTALL) compat/mingwcompat.lib $(DESTDIR)/lib
	$(INSTALL) math/msvcmath.lib $(DESTDIR)/lib
	$(INSTALL) gfortran-msvc.lib $(DESTDIR)/lib
	$(INSTALL) gfortran-msvc-static.lib $(DESTDIR)/lib
	$(INSTALL) -d $(CMAKE_DESTDIR)/Modules/Platform
	$(INSTALL) Windows-clg++.cmake $(CMAKE_DESTDIR)/Modules/Platform
	$(INSTALL) Windows-clgcc.cmake $(CMAKE_DESTDIR)/Modules/Platform
