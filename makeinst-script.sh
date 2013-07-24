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
!define COPYRIGHT "Copyright © 2013 John W. Eaton and others."
!define DESCRIPTION "GNU Octave is a high-level programming language, primarily intended for numerical computations."
!define INSTALLER_NAME "octave-installer.exe"
!define MAIN_APP_EXE "octave.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define CLASSPATH ".;lib;lib\myJar"
!define CLASS "org.me.myProgram"

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
EOF

echo "Generation Completed"
