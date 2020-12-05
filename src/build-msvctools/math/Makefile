MSVCMATH := $(shell echo '\#include <math.h>' > t.c; cl -nologo -showIncludes -c t.c | $(SED) -n -e 's/^Note: including file: \(.*math\.h\)$$/\1/p'; rm -f t.c t.obj)
MSVCMATH := $(subst \,\\,$(MSVCMATH))

GCCHEADERS = cephes_mconf.h fastmath.h
GCCSOURCES = acosh.c acoshf.c asinh.c asinhf.c atanh.c atanhf.c cbrt.c cbrtf.c expm1.c expm1f.c fpclassify.c fpclassifyf.c isnan.c isnanf.c llrint.c llrintf.c logb.c logbf.c lrint.c lrintf.c modff.c nextafterf.c rint.c rintf.c trunc.c truncf.c
ASMSOURCES = exp2.S exp2f.S fma.S fmaf.S ilogb.S ilogbf.S log1p.S log1pf.S log2.S log2f.S nearbyint.S nearbyintf.S remainder.S remainderf.S scalbn.S scalbnf.S
MSCSOURCES = finite.c finitef.c funx.c isinf.c isinff.c nan.c nextafter.c

OBJECTS = $(GCCSOURCES:.c=.o) round.o roundf.o lround.o lroundf.o $(ASMSOURCES:.S=.o) $(MSCSOURCES:.c=.obj)
DOWNLOADSOURCES = $(GCCSOURCES) $(GCCHEADERS) $(ASMSOURCES) round_internal.h round_generic.c lround_generic.c

all: msvcmath.lib msvcmath.h

check: testmath.dll

$(DOWNLOADSOURCES):
	@echo "DOWNLOAD $@"
	@wget -q -O $@ 'http://cygwin.com/cgi-bin/cvsweb.cgi/~checkout~/src/winsup/mingw/mingwex/math/$@?&cvsroot=src'

round.o: CFLAGS += -DFUNCTION=round
roundf.o: CFLAGS += -DFUNCTION=roundf
lround.o: CFLAGS += -DFUNCTION=lround
lroundf.o: CFLAGS += -DFUNCTION=lroundf

GCCFLAGS = -mstackrealign -mincoming-stack-boundary=2

round.o roundf.o: round_generic.c round_internal.h
	@echo "GCC $(@:.o=).c"
	@gcc $(CFLAGS) $(GCCFLAGS) -O2 -c -o $@ $<

lround.o lroundf.o: lround_generic.c round_internal.h
	@echo "GCC $(@:.o=).c"
	@gcc $(CFLAGS) $(GCCFLAGS) -O2 -c -o $@ $<

%.o: %.c
	@echo "GCC $<"
	@gcc $(CFLAGS) $(GCCFLAGS) -O2 -c -o $@ $<

%.obj: %.c
	@echo "MSC $<"
	@cl -nologo -MD -O2 -D__CLGCC__ -Fo$@ -c $<

%.o : %.S
	@echo "AS $<"
	@as $(ASFLAGS) -o $@ $<

msvcmath.lib: $(GCCHEADERS) $(OBJECTS)
	@echo "LIB $@"
	@lib -nologo -out:$@ $(OBJECTS)

testmath.dll: $(GCCHEADERS) $(OBJECTS) math.def
	@echo "DLL $@"
	@cl -nologo -LD -Fe$@ $(OBJECTS) math.def msvcrt.lib

msvcmath.h: math.h.in
	@echo "HEADER $@"
	-@if sed -e 's,@MSVCMATH@,$(MSVCMATH),' $< > $@-t; then \
		mv $@-t $@; \
	fi
	@rm -f $@-t

clean:
	-rm -f $(OBJECTS)
	-rm -f msvcmath.lib msvcmath.h
	-rm -f testmath.dll testmath.lib testmath.exp

files-clean: clean
	-rm $(GCCHEADERS) $(GCCSOURCES) $(ASMSOURCES)

files: $(DOWNLOADSOURCES)

# Additional dependencies

funx.obj: msvcmath.h
