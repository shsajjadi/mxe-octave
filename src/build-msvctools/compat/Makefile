GCCHEADERS =
GCCSOURCES = gettimeofday.c usleep.c complex/cabsf.c complex/ccos.c complex/ccosf.c complex/cexp.c complex/cexpf.c complex/clog.c complex/clogf.c complex/csin.c complex/csinf.c complex/csqrt.c complex/csqrtf.c
ASMSOURCES =
MSCSOURCES = mingwcompat.c

OBJECTS = $(notdir $(GCCSOURCES:.c=.o)) $(ASMSOURCES:.S=.o) $(MSCSOURCES:.c=.obj) mingwcompat_gcc.o

GCCFLAGS = -mstackrealign -mincoming-stack-boundary=2

all: mingwcompat.lib

$(GCCSOURCES) $(GCCHEADERS) $(ASMSOURCES):
	@echo "DOWNLOAD $@"
	@wget -q -O $(notdir $@) 'http://cygwin.com/cgi-bin/cvsweb.cgi/~checkout~/src/winsup/mingw/mingwex/$@?&cvsroot=src'

%.o: %.c
	@echo "GCC $<"
	@gcc $(CFLAGS) $(GCCFLAGS) -O2 -c -o $@ $<

%.obj: %.c
	@echo "MSC $<"
	@cl -nologo -MD -O2 -Fo$@ -c $<

%.o : %.S
	@echo "AS $<"
	@as $(ASFLAGS) -o $@ $<

mingwcompat.lib: $(GCCHEADERS) $(OBJECTS)
	@echo "LIB $@"
	@lib -nologo -out:$@ $(OBJECTS)

clean:
	-rm -f $(OBJECTS)
	-rm -f mingwcompat.lib

files-clean: clean
	-rm $(GCCHEADERS) $(GCCSOURCES) $(ASMSOURCES)

sources: $(GCCSOURCES) $(ASMSOURCES)
