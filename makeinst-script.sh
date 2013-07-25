#! /bin/bash
set -e

if [ $# != 1 ]; then
  echo "Expected octave folder"
  exit
fi

ARG1=$1

TOPDIR=`dirname $ARG1`
OCTAVE_SOURCE=`basename $ARG1`

echo "Generating installer script ... "

cd $TOPDIR

# find icon
ICON=`find $OCTAVE_SOURCE -name octave-logo.ico -printf "%P" | head -1 | sed 's,/,\\\\,g'`

# create installer script
echo "; octave setup script $OCTAVE_SOURCE" > octave.nsi

# installer settings
  cat >> octave.nsi << EOF
!define APP_NAME "GNU Octave"
!define COMP_NAME "GNU Project"
!define WEB_SITE "http://www.octave.org"
!define VERSION "3.7.5.0"
!define OCTAVE_VERSION "3.7.5"
!define COPYRIGHT "Copyright © 2013 John W. Eaton and others."
!define DESCRIPTION "GNU Octave is a high-level programming language, primarily intended for numerical computations."
!define LICENSE_TXT "../gpl-3.0.txt"
!define INSTALLER_NAME "octave-installer.exe"
!define MAIN_APP_EXE "octave.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define PRODUCT_ROOT_KEY "HKLM"
!define PRODUCT_KEY "Software\Octave"

######################################################################

VIProductVersion  "\${VERSION}"
VIAddVersionKey "ProductName"  "\${APP_NAME}"
VIAddVersionKey "CompanyName"  "\${COMP_NAME}"
VIAddVersionKey "LegalCopyright"  "\${COPYRIGHT}"
VIAddVersionKey "FileDescription"  "\${DESCRIPTION}"
VIAddVersionKey "FileVersion"  "\${VERSION}"

######################################################################

SetCompressor /SOLID Lzma
Name "\${APP_NAME}"
Caption "\${APP_NAME}"
OutFile "\${INSTALLER_NAME}"
BrandingText "\${APP_NAME}"
XPStyle on
InstallDir "\$PROGRAMFILES\Octave"
Icon "$OCTAVE_SOURCE\\$ICON"

######################################################################
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING

!insertmacro MUI_PAGE_WELCOME

!ifdef LICENSE_TXT
!define MUI_LICENSEPAGE_TEXT_BOTTOM "The source code for Octave is freely redistributable under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation."
!define MUI_LICENSEPAGE_BUTTON "Next >"
!insertmacro MUI_PAGE_LICENSE "\${LICENSE_TXT}"
!endif

!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN "\$INSTDIR\bin\\\${MAIN_APP_EXE}"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

######################################################################
 
RequestExecutionLevel admin

Function .onInit
  Call CheckPrevVersion
  Call CheckJRE
  InitPluginsDir
FunctionEnd

; file section
Section "MainFiles"

EOF

# insert the files
  IFS=$'\n'
  for f in $(find $OCTAVE_SOURCE -type d -printf "%P\n"); do
    winf=`echo $f | sed 's,/,\\\\,g'`
    echo " CreateDirectory \"\$INSTDIR\\$winf\"" >> octave.nsi
    echo " SetOutPath \"\$INSTDIR\\$winf\"" >> octave.nsi
    find "$OCTAVE_SOURCE/$f" -maxdepth 1 -type f -printf " File \"%p\"\n" >> octave.nsi 
  done

  cat >> octave.nsi << EOF

SectionEnd

Section make_uninstaller
 ; Write the uninstall keys for Windows
 SetOutPath "\$INSTDIR"
 WriteRegStr HKLM "Software\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave" "DisplayName" "Octave"
 WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave" "UninstallString" "\$INSTDIR\uninstall.exe"
 WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave" "NoModify" 1
 WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave" "NoRepair" 1
 WriteUninstaller "uninstall.exe"
SectionEnd

; start menu (currently hardcoded)
Section "Shortcuts"

 CreateDirectory "\$SMPROGRAMS\\Octave"
 CreateShortCut "\$SMPROGRAMS\\Octave\\Uninstall.lnk" "\$INSTDIR\\uninstall.exe" "" "\$INSTDIR\\uninstall.exe" 0
 CreateShortCut "\$SMPROGRAMS\Octave\\Octave.lnk" "\$INSTDIR\\bin\\octave.exe" "" "\$INSTDIR\\$ICON" 0
 CreateShortCut "\$SMPROGRAMS\Octave\\Octave (Experimental GUI).lnk" "\$INSTDIR\\bin\\octave-gui.exe" "" "\$INSTDIR\\$ICON" 0
  
SectionEnd

Section "Uninstall"

 DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Octave"
 DeleteRegKey HKLM "Software\Octave"

 ; Remove shortcuts
 Delete "\$SMPROGRAMS\Octave\*.*"
 RMDir "\$SMPROGRAMS\Octave"

EOF

# insert dir list (backwards order) for uninstall files
  for f in $(find $OCTAVE_SOURCE -depth -type d -printf "%P\n"); do
    winf=`echo $f | sed 's,/,\\\\,g'`
    echo " Delete \"\$INSTDIR\\$winf\\*.*\"" >> octave.nsi
    echo " RmDir \"\$INSTDIR\\$winf\"" >> octave.nsi
  done

# last bit of the uninstaller
  cat >> octave.nsi << EOF
 Delete "\$INSTDIR\*.*"
 RmDir "\$INSTDIR"
SectionEnd

; Function to check any previously installed version of Octave in the system
Function CheckPrevVersion
  Push \$0
  Push \$1
  Push \$2
  IfFileExists "\$INSTDIR\bin\octave-\${OCTAVE_VERSION}.exe" 0 otherver
  MessageBox MB_OK|MB_ICONSTOP "Another Octave installation (with the same version) has been detected. Please uninstall it first."
  Abort
otherver:
  StrCpy \$0 0
  StrCpy \$2 ""
loop:
  EnumRegKey \$1 \${PRODUCT_ROOT_KEY} "\${PRODUCT_KEY}" \$0
  StrCmp \$1 "" loopend
  IntOp \$0 \$0 + 1
  StrCmp \$2 "" 0 +2
  StrCpy \$2 "\$1"
  StrCpy \$2 "\$2, \$1"
  Goto loop
loopend:
  ReadRegStr \$1 \${PRODUCT_ROOT_KEY} "\${PRODUCT_KEY}" "Version"
  IfErrors finalcheck
  StrCmp \$2 "" 0 +2
  StrCpy \$2 "\$1"
  StrCpy \$2 "\$2, \$1"
finalcheck:
  StrCmp \$2 "" done
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "Another Octave installation (version \$2) has been detected. It is recommended to uninstall it if you intend to use the same installation directory. Do you want to proceed with the installation anyway?" IDYES done IDNO 0
  Abort
done:
  ClearErrors
  Pop \$2
  Pop \$1
  Pop \$0
FunctionEnd

; Function to check Java Runtime Environment
Function CheckJRE
;  looks in:
;  1 - JAVA_HOME environment variable
;  2 - the registry

  Push \$R0
  Push \$R1

  ; use javaw.exe to avoid dosbox.
  ; use java.exe to keep stdout/stderr
  !define JAVAEXE "javaw.exe"

  ClearErrors
  ReadEnvStr \$R0 "JAVA_HOME"
  StrCpy \$R0 "\$R0\bin\\\${JAVAEXE}"
  IfErrors 0 continue  ;; 1) found it in JAVA_HOME

  ClearErrors
  ReadRegStr \$R1 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment" "CurrentVersion"
  ReadRegStr \$R0 HKLM "SOFTWARE\JavaSoft\Java Runtime Environment\\\$R1" "JavaHome"
  StrCpy \$R0 "\$R0\bin\\\${JAVAEXE}"

  IfErrors 0 continue  ;; 2) found it in the registry
  IfErrors JRE_Error

 JRE_Error:
  MessageBox MB_ICONEXCLAMATION|MB_YESNO "Octave includes a Java integration component, but it seems Java is not available on this system. This component requires the Java Runtime Environment from Oracle (http://www.java.com) installed on your system. Octave can work without Java available, but the Java integration component will not be functional. Installing those components without Java available might prevent Octave from working correctly. Proceed with installation anyway?" IDYES continue
  Abort
 continue:
FunctionEnd
EOF

echo "Generation Completed"
