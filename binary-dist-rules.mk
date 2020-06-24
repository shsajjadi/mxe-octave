
ifeq ($(MXE_WINDOWS_BUILD),yes)
  ifeq ($(ENABLE_WINDOWS_64),yes)
    ifeq ($(ENABLE_FORTRAN_INT64),yes)
      OCTAVE_PLATFORM_SUFFIX := -w64-64
    else
      OCTAVE_PLATFORM_SUFFIX := -w64
    endif
  else
      OCTAVE_PLATFORM_SUFFIX := -w32
  endif
endif

ifeq ($(OCTAVE_TARGET),release-octave)
  OCTAVE_DIST_NAME := octave-$($(OCTAVE_TARGET)_VERSION)$(OCTAVE_PLATFORM_SUFFIX)
else
  OCTAVE_DIST_NAME := octave-$(DATE)$(OCTAVE_PLATFORM_SUFFIX)
endif

OCTAVE_DIST_DIR := $(TOP_BUILD_DIR)/dist/$(OCTAVE_DIST_NAME)

OCTAVE_NSI_FILE := $(TOP_BUILD_DIR)/dist/octave.nsi

OCTAVE_ADD_PATH := /
ifeq ($(MXE_WINDOWS_BUILD),yes)
  TAR_H_OPTION := -h
  WINDOWS_BINARY_DIST_DEPS := \
    win7appid blas_switch

  ifeq ($(USE_MSYS2),yes)
    WINDOWS_BINARY_DIST_DEPS += \
      msys2 \
      msys2-sources

    ifeq ($(ENABLE_WINDOWS_64),yes)
      OCTAVE_ADD_PATH := /mingw64
    else
      OCTAVE_ADD_PATH := /mingw32
    endif
  else
    WINDOWS_BINARY_DIST_DEPS += \
      msys-base \
      msys-base-sources
  endif

  ifeq ($(MXE_NATIVE_BUILD),no)
    WINDOWS_BINARY_DIST_DEPS += \
      native-binutils \
      native-gcc \
      npp
  endif

  # other packages we want to include
  WINDOWS_BINARY_DIST_DEPS += \
    libbiosig
endif

BINARY_DIST_DEPS := \
  $(OCTAVE_TARGET) \
  blas-packages \
  octave-forge-packages \
  devel-packages \
  units \
  transfig \
  $(WINDOWS_BINARY_DIST_DEPS)

define delete-dist-directory
  echo "deleting previous dist directory..."
  rm -rf $(TOP_BUILD_DIR)/dist
endef

define make-dist-directory
  echo "creating dist directory..."
  mkdir -p $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)
endef

define copy-dist-files
  echo "copying files..."
  echo "  octave and dependencies..."
  cd $(HOST_PREFIX) \
    && tar -c $(TAR_H_OPTION) -f - . | ( cd $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH) ; tar xpf - )
  echo "  octaverc file..."
  cp $(TOP_DIR)/octaverc $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/share/octave/site/m/startup/octaverc
  if [ $(ENABLE_BINARY_PACKAGES) = no ]; then \
    echo "  build_packages.m..."; \
    cp $(TOP_DIR)/build_packages.m $(OCTAVE_DIST_DIR)/src; \
  fi
endef

ifeq ($(MXE_WINDOWS_BUILD),yes)
  ifeq ($(MXE_NATIVE_BUILD),no)
    define copy-windows-dist-files
      echo "  DLL files..."
      cp $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/*.dll $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin
      cp $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/*.dll $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin
      cp $(BUILD_TOOLS_PREFIX)/lib/gcc/$(TARGET)/$(build-gcc_VERSION)/*.dll $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin
      if [ "$(USE_MSYS2)" = "yes" ]; then \
        echo "  msys2 files..."; \
        cd $(TOP_BUILD_DIR)/msys2 \
          && tar -c $(TAR_H_OPTION) -f - . | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - ); \
      else \
        echo "  msys base files..."; \
        cd $(TOP_BUILD_DIR)/msys-base \
          && tar -c $(TAR_H_OPTION) -f - . | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - ); \
        echo "  msys extension files..."; \
        cd $(TOP_BUILD_DIR)/msys-extension \
          && tar -c $(TAR_H_OPTION) -f - . | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - ); \
      fi
      echo "  notepad++..."
      cd $(TOP_BUILD_DIR) \
          && tar -c $(TAR_H_OPTION) -f - notepad++ | ( cd $(OCTAVE_DIST_DIR) ; tar xpf - )
      echo "  README.html..."
      cp $(TOP_DIR)/installer-files/README.html $(OCTAVE_DIST_DIR)/
      echo "  refblas..."
      cp $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin/libblas.dll $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin/librefblas.dll
      echo "  octave.vbs..."
      cp $(TOP_DIR)/installer-files/octave.vbs $(OCTAVE_DIST_DIR)/
      cp $(TOP_DIR)/installer-files/octave-firsttime.vbs $(OCTAVE_DIST_DIR)/
      cp $(TOP_DIR)/installer-files/fc_update.bat $(OCTAVE_DIST_DIR)/
      cp $(TOP_DIR)/installer-files/post-install.bat $(OCTAVE_DIST_DIR)/
      cp $(TOP_BUILD_DIR)/HG-ID $(OCTAVE_DIST_DIR)/
      echo "  updating octave .exe to script files..."
      rm -f $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin/octave.exe
      rm -f $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin/octave-$($(OCTAVE_TARGET)_VERSION).exe
      cp $(TOP_DIR)/installer-files/octave.bat $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin/octave.bat
      cp $(TOP_DIR)/installer-files/octave.bat $(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin/octave-$($(OCTAVE_TARGET)_VERSION).bat
      echo "  updating libtool references..."
      find '$(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/' -type f -name "*.la" \
        -exec $(SED) -i 's|$(HOST_PREFIX)|/usr|g;s|$(BUILD_TOOLS_PREFIX)|/usr|g' {} \; ;
      echo "  updating pkg-config .pc references..."
      find '$(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/lib/pkgconfig' -type f -name "*.pc" \
        -exec $(SED) -i 's|$(HOST_PREFIX)|/usr|g;s|$(BUILD_TOOLS_PREFIX)|/usr|g' {} \; ;
      if [ "$(ENABLE_DEVEL_TOOLS)" = "yes" ]; then \
        cp $(TOP_DIR)/installer-files/cmdshell.bat $(OCTAVE_DIST_DIR)/; \
      fi
      echo "  updating script tool references..."
      #find '$(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin' -type f ! -name "*.*" \
      #  -exec $(SED) -i 's|$(HOST_PREFIX)|/$(OCTAVE_ADD_PATH)|g;s|$(BUILD_TOOLS_PREFIX)|/$(OCTAVE_ADD_PATH)|g' {} \; ;
      find '$(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin' -type f ! -name "*.*" \
        -exec sh -c 'test `head -c2 {}` = "#!" && $(SED) -i "s|$(HOST_PREFIX)|$(OCTAVE_ADD_PATH)|g;s|$(BUILD_TOOLS_PREFIX)|$(OCTAVE_ADD_PATH)|g" {}' \; ;
      # some additional script files to fix
      $(SED) -i "s|datadir = '/usr/share'|datadir = '$(OCTAVE_ADD_PATH)/share'|g" '$(OCTAVE_DIST_DIR)$(OCTAVE_ADD_PATH)/bin/makeinfo'

    endef
  else
    define copy-windows-dist-files
      echo "  DLL files..."
      cp /mingw/bin/*.dll $(OCTAVE_DIST_DIR)/bin
      echo "  README.html..."
      cp $(TOP_DIR)/installer-files/README.html $(OCTAVE_DIST_DIR)/
      echo "  refblas..."
      cp $(OCTAVE_DIST_DIR)/bin/libblas.dll $(OCTAVE_DIST_DIR)/bin/librefblas.dll
      echo "  octave.vbs..."
      cp $(TOP_DIR)/installer-files/octave.vbs $(OCTAVE_DIST_DIR)/
      cp $(TOP_DIR)/installer-files/octave-firsttime.vbs $(OCTAVE_DIST_DIR)/
      cp $(TOP_DIR)/installer-files/fc_update.bat $(OCTAVE_DIST_DIR)/
      cp $(TOP_DIR)/installer-files/post-install.bat $(OCTAVE_DIST_DIR)/
      echo "  updating octave .exe to script files..."
      rm -f $(OCTAVE_DIST_DIR)/bin/octave.exe
      rm -f $(OCTAVE_DIST_DIR)/bin/octave-$($(OCTAVE_TARGET)_VERSION).exe
      cp $(TOP_DIR)/installer-files/octave.bat $(OCTAVE_DIST_DIR)/bin/octave.bat
      cp $(TOP_DIR)/installer-files/octave.bat $(OCTAVE_DIST_DIR)/bin/octave-$($(OCTAVE_TARGET)_VERSION).bat
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
      for f in `find $(OCTAVE_DIST_DIR) -name '*.dll' -o -name '*.exe' -o -name '*.oct' | $(GREP) -v "notepad++" | $(GREP) -v "msys-2.0.dll"`; do \
        if [ "$$(head -n1 $$f | cut -c1-2)" != "#!" ]; then \
          $(MXE_STRIP) $$f; \
        fi; \
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
      $(SED) < $(TOP_DIR)/octave-wrapper.in \
	-e "s|@GCC_VERSION@|$(native-gcc_VERSION)|" \
	-e "s|@GCC_ARCH@|$(TARGET)|" \
	-e "s|@OCTAVE_VERSION@|$($(OCTAVE_TARGET)_VERSION)|" \
	-e "s|@GNUPLOT_MAJOR_MINOR_VERSION@|$(shell echo $(gnuplot_VERSION) | $(SED) -e 's/\(^[0-9][0-9]*\.[0-9][0-9]*\)\..*/\1/')|" \
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
  $(TOP_BUILD_DIR)/tools/makeinst-script.sh $(OCTAVE_DIST_DIR) $(OCTAVE_DIST_NAME)-installer.exe $(OCTAVE_NSI_FILE)
  echo "generating installer..."
  $(TARGET)-makensis $(OCTAVE_NSI_FILE) > $(TOP_BUILD_DIR)/dist/nsis.log
endef

$(OCTAVE_DIST_NAME)-installer.exe: nsis binary-dist-files
	@$(make-installer-file)

.PHONY: nsis-installer
nsis-installer: $(OCTAVE_DIST_NAME)-installer.exe

define make-7z-dist
  echo "generating 7z file..."
  cd $(TOP_BUILD_DIR)/dist && p7zip -k $(OCTAVE_DIST_NAME)
endef

.PHONY: 7z-dist
7z-dist: binary-dist-files
	@$(make-7z-dist)

define make-zip-dist
  echo "generating zip file..."
  cd $(TOP_BUILD_DIR)/dist \
    && zip -q -9 -r $(OCTAVE_DIST_NAME).zip $(OCTAVE_DIST_NAME)
endef

.PHONY: zip-dist
zip-dist: binary-dist-files
	@$(make-zip-dist)

define make-tar-dist
  echo "generating tar file..."
  cd $(TOP_BUILD_DIR)/dist \
    && tar -c -z -f $(OCTAVE_DIST_NAME).tgz $(OCTAVE_DIST_NAME)
endef

.PHONY: tar-dist
tar-dist: binary-dist-files
	@$(make-tar-dist)
