
ifeq ($(OCTAVE_TARGET),stable-octave)
  OCTAVE_DIST_NAME := octave-$($(OCTAVE_TARGET)_VERSION)
else
  OCTAVE_DIST_NAME := octave-$(DATE)
endif

OCTAVE_DIST_DIR := $(TOP_DIR)/dist/$(OCTAVE_DIST_NAME)

OCTAVE_NSI_FILE := $(TOP_DIR)/dist/octave.nsi

ifeq ($(MXE_WINDOWS_BUILD),yes)
  TAR_H_OPTION := -h
  WINDOWS_BINARY_DIST_DEPS := \
    msys-base \
    msys-base-sources

  ifeq ($(MXE_NATIVE_BUILD),no)
    WINDOWS_BINARY_DIST_DEPS += \
      native-binutils \
      native-gcc \
      npp
  endif

endif

BINARY_DIST_DEPS := \
  $(OCTAVE_TARGET) \
  blas-packages \
  octave-forge-packages \
  units \
  transfig \
  $(WINDOWS_BINARY_DIST_DEPS)

define delete-dist-directory
  echo "deleting previous dist directory..."
  rm -rf $(TOP_DIR)/dist
endef

define make-dist-directory
  echo "creating dist directory..."
  mkdir -p $(OCTAVE_DIST_DIR)
endef

define copy-dist-files
  echo "copying files..."
  echo "  octave and dependencies..."
  cd $(HOST_PREFIX) \
    && tar -c $(TAR_H_OPTION) -f - . | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - )
  echo "  octaverc file..."
  cp $(TOP_DIR)/octaverc $(OCTAVE_DIST_DIR)/share/octave/site/m/startup/octaverc
  echo "  build_packages.m..."
  cp $(TOP_DIR)/build_packages.m $(OCTAVE_DIST_DIR)/src
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  ifeq ($(MXE_NATIVE_BUILD),no)
    define copy-windows-dist-files
      echo "  DLL files..."
      cp $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/*.dll $(OCTAVE_DIST_DIR)/bin
      cp $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/*.dll $(OCTAVE_DIST_DIR)/bin
      cp $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/$(build-gcc_VERSION)/*.dll $(OCTAVE_DIST_DIR)/bin
      echo "  msys base files..."
      cd $(TOP_DIR)/msys-base \
        && tar -c $(TAR_H_OPTION) -f - . | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - )
      echo "  msys extension files..."
      cd $(TOP_DIR)/msys-extension \
        && tar -c $(TAR_H_OPTION) -f - . | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - )
      echo "  notepad++..."
      cd $(TOP_DIR) \
          && tar -c $(TAR_H_OPTION) -f - notepad++ | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - )
      echo "  README.html..."
      cp $(TOP_DIR)/installer-files/README.html $(OCTAVE_DIST_DIR)/
      echo "  refblas..."
      cp $(OCTAVE_DIST_DIR)/bin/libblas.dll $(OCTAVE_DIST_DIR)/bin/librefblas.dll
      echo "  octave.bat..."
      cp $(TOP_DIR)/installer-files/octave.bat $(OCTAVE_DIST_DIR)/
      cp $(TOP_DIR)/installer-files/octave.vbs $(OCTAVE_DIST_DIR)/
    endef
  else
    define copy-windows-dist-files
      echo "  DLL files..."
      cp /mingw/bin/*.dll $(OCTAVE_DIST_DIR)/bin
      echo "  README.html..."
      cp $(TOP_DIR)/installer-files/README.html $(OCTAVE_DIST_DIR)/
      echo "  refblas..."
      cp $(OCTAVE_DIST_DIR)/bin/libblas.dll $(OCTAVE_DIST_DIR)/bin/librefblas.dll
      echo "  octave.bat..."
      cp $(TOP_DIR)/installer-files/octave.bat $(OCTAVE_DIST_DIR)/
    endef
  endif
endif

define make-dist-files-writable
  echo "making all dist files writable by user..."
  chmod -R u+w $(OCTAVE_DIST_DIR)
endef

ifeq ($(STRIP_DIST_FILES),yes)
  ifeq ($(MXE_WINDOWS_BUILD),yes)
    define strip-dist-files
      echo "stripping files..."
      for f in `find $(OCTAVE_DIST_DIR) -name '*.dll' -o -name '*.exe'`; do \
	$(MXE_STRIP) $$f; \
      done
    endef
  else
    define strip-dist-files
      echo "stripping files..."
      for f in `find $(OCTAVE_DIST_DIR) -type f -a -perm /a+x`; do \
        case "`file $$f`" in \
          *script*) \
          ;; \
          *executable* | *archive* | *"shared object"*) \
            $(MXE_STRIP) $$f; \
          ;; \
        esac; \
      done
    endef
  endif
else
  define strip-dist-files
    echo "not stripping files..."
  endef
endif

OCTAVE_WRAPPER_SCRIPTS = octave octave-cli octave-config

ifeq ($(MXE_SYSTEM), gnu-linux)
  define install-octave-wrapper-scripts
    echo "installing octave wrapper scripts..."
    for f in $(OCTAVE_WRAPPER_SCRIPTS); do \
      mv $(OCTAVE_DIST_DIR)/bin/$$f-$($(OCTAVE_TARGET)_VERSION) \
	 $(OCTAVE_DIST_DIR)/bin/$$f-$($(OCTAVE_TARGET)_VERSION).real; \
      $(SED) < octave-wrapper.in \
	-e "s|@OCTAVE_VERSION@|$($(OCTAVE_TARGET)_VERSION)|" \
	-e "s|@GNUPLOT_MAJOR_MINOR_VERSION@|$(shell echo $(gnuplot_VERSION) | $(SED) -e 's/\(^[0-9]+\.[0-9]+\)/\1/')|" \
	-e "s|@PROGRAM_NAME@|$$f|" > $$f-t \
      && $(INSTALL) -m 755 $$f-t $(OCTAVE_DIST_DIR)/bin/$$f-$($(OCTAVE_TARGET)_VERSION); \
      rm -f $(OCTAVE_DIST_DIR)/bin/$$f; \
      ln -s $$f-$($(OCTAVE_TARGET)_VERSION) $(OCTAVE_DIST_DIR)/bin/$$f; \
    done
  endef
else
  define install-octave-wrapper-scripts
    echo "no octave wrapper scripts to install for this system..."
  endef
endif

.PHONY: binary-dist-files
binary-dist-files: $(BINARY_DIST_DEPS)
	@$(delete-dist-directory)
	@$(make-dist-directory)
	@$(copy-dist-files)
	@$(copy-windows-dist-files)
	@$(make-dist-files-writable)
	@$(strip-dist-files)
	@$(install-octave-wrapper-scripts)

define make-installer-file
  if [ -f $(OCTAVE_NSI_FILE) ]; then \
    echo "deleting previous installer script..."; \
    rm -f $(OCTAVE_NSI_FILE); \
  fi
  echo "generating installer script..."
  ./makeinst-script.sh $(OCTAVE_DIST_DIR) $(OCTAVE_NSI_FILE)
  echo "generating installer..."
  $(TARGET)-makensis $(OCTAVE_NSI_FILE) > $(TOP_DIR)/dist/nsis.log
endef

$(OCTAVE_DIST_NAME)-installer.exe: nsis binary-dist-files
	@$(make-installer-file)

.PHONY: nsis-installer
nsis-installer: $(OCTAVE_DIST_NAME)-installer.exe

define make-zip-dist
  echo "generating zip file..."
  cd $(TOP_DIR)/dist \
    && zip -q -9 -r $(OCTAVE_DIST_NAME).zip $(OCTAVE_DIST_NAME)
endef

.PHONY: zip-dist
zip-dist: binary-dist-files
	@$(make-zip-dist)

define make-tar-dist
  echo "generating tar file..."
  cd $(TOP_DIR)/dist \
    && tar -c -z -f $(OCTAVE_DIST_NAME).tgz $(OCTAVE_DIST_NAME)
endef

.PHONY: tar-dist
tar-dist: binary-dist-files
	@$(make-tar-dist)
