## Build and Octave tarball distribution from hg sources.  The
## resulting tarball may then be used by the default-octave target to
## build.  So the typical steps for building Octave from the mercurial
## sources are
##
##  ./bootstrap
##  ./configure --enable-octave=default
##  make hg-octave-dist
##  make
##
## The version number set in the mercurial sources for Octave must
## match the one used in src/default-octave.mk.

## Set PATH, PKG_CONFIG_PATH, and LD_LIBRARY_PATH to the original
## values from the environment so that we avoid the tools that we've
## built for cross compiling.  For these rules to work, you must have
## appropriate versions of the required tool installed outside of the
## mxe-octave build tree.  Things like pkg-config and other tools that
## are built for mxe-octave may produce the wrong values for these
## steps, especially if we eventually intend to cross compile Octave.
## Rather than try to work around those issues, it seems simpler to
## just use the system tools for this job.

HG_OCTAVE_DIST_ENV_FLAGS := \
  PKG_CONFIG_PATH='$(ENV_PKG_CONFIG_PATH)' \
  LD_LIBRARY_PATH='$(LD_LIBRARY_PATH)' \
  PATH='$(ENV_PATH)'

.PHONY: hg-octave-dist
hg-octave-dist: $(BUILD_TOOLS) update-hg-octave-repo
	cd octave-hg-repo && \
	rm -rf .build && \
	mkdir .build && \
	$(HG_OCTAVE_DIST_ENV_FLAGS) ./bootstrap && \
	cd .build && \
	$(HG_OCTAVE_DIST_ENV_FLAGS) ../configure && \
	$(HG_OCTAVE_DIST_ENV_FLAGS) make -j '$(JOBS)' all && \
	$(HG_OCTAVE_DIST_ENV_FLAGS) make -j '$(JOBS)' dist && \
	mv '$(default-octave_FILE)' '$(PKG_DIR)'

.PHONY: update-hg-octave-repo
update-hg-octave-repo:
	if [ -d octave-hg-repo ]; then \
	  cd octave-hg-repo && hg pull -u; \
	else \
	  hg clone http://octave.org/hg/octave octave-hg-repo; \
	fi