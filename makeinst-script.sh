#! /bin/bash
set -e

if [ $# != 2 ]; then
  echo "usage: makeinst-script.sh dist-dir output-script-name" 1>&2
  exit 1
fi

OUTFILE="$2"
TOPDIR=`dirname $1`
OCTAVE_SOURCE=`basename $1`

cd $TOPDIR
MXEDIR=`cd ..; pwd`

if [ -e $OCTAVE_SOURCE/bin/libopenblas.dll ]; then
  DEFAULT_BLAS="OpenBLAS"
else
  DEFAULT_BLAS="Reference BLAS"
fi


# find octave shortcut icon
ICON=`find $OCTAVE_SOURCE -name octave-logo.ico -printf "%P" | head -1 | sed 's,/,\\\\,g'`

# extract version number
OCTAVE_VERSION=`head -1 $MXEDIR/octave/octave-version`
VERSION=`echo $OCTAVE_VERSION | sed -n 's,\([0-9\.]*\).*,\1,p'`

# create installer script
echo "; octave setup script $OCTAVE_SOURCE" > $OUTFILE

# installer settings
  cat >> $OUTFILE << EOF
!define APP_NAME "GNU Octave"
!define COMP_NAME "GNU Project"
!define WEB_SITE "http://www.octave.org"
!define VERSION "$VERSION.0"
!define OCTAVE_VERSION "$OCTAVE_VERSION"
!define COPYRIGHT "Copyright © 2013 John W. Eaton and others."
!define DESCRIPTION "GNU Octave is a high-level programming language, primarily intended for numerical computations."
!define INSTALLER_FILES "../installer-files"
!define INSTALLER_NAME "octave-$OCTAVE_VERSION-installer.exe"
!define MAIN_APP_EXE "octave-gui.exe"
!define INSTALL_TYPE "SetShellVarContext current"
!define PRODUCT_ROOT_KEY "HKLM"
!define PRODUCT_KEY "Software\\Octave-$VERSION"

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
InstallDir "C:\\Octave\\Octave-\${OCTAVE_VERSION}"
Icon "\${INSTALLER_FILES}/octave-logo.ico"

######################################################################
; StrFunc usage
!include "StrFunc.nsh"
\${StrRep}
######################################################################
; MUI settings
!include "MUI.nsh"

; custom dialogs
!include nsDialogs.nsh
!macro __DropList_GetCurSel CONTROL VAR
        SendMessage \${CONTROL} \${CB_GETCURSEL} 0 0 \${VAR}
!macroend

!define DropList_GetCurSel \`!insertmacro __DropList_GetCurSel\`

; additional logic
!include LogicLib.nsh


!define MUI_ABORTWARNING
!define MUI_UNABORTWARNING
!define MUI_HEADERIMAGE

; Theme
!define MUI_ICON "\${INSTALLER_FILES}/octave-logo.ico"
!define MUI_UNICON "./${OCTAVE_SOURCE}/share/nsis/Contrib/Graphics/Icons/orange-uninstall.ico"
!define MUI_HEADERIMAGE_BITMAP "\${INSTALLER_FILES}/octave-hdr.bmp"
!define MUI_WELCOMEFINISHPAGE_BITMAP "\${INSTALLER_FILES}/octave.bmp"
 
!insertmacro MUI_PAGE_WELCOME

!define MUI_LICENSEPAGE_TEXT_BOTTOM "The source code for Octave is freely redistributable under the terms of the GNU General Public License (GPL) as published by the Free Software Foundation."
!define MUI_LICENSEPAGE_BUTTON "Next >"
!insertmacro MUI_PAGE_LICENSE "\${INSTALLER_FILES}/gpl-3.0.txt"

Page custom octaveOptionsPage octaveOptionsLeave

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE CheckPrevInstall
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!define MUI_FINISHPAGE_RUN "\$INSTDIR\\bin\\\${MAIN_APP_EXE}"
!define MUI_FINISHPAGE_SHOWREADME "\$INSTDIR\\README.html"
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM

!insertmacro MUI_UNPAGE_INSTFILES

!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

######################################################################
 
RequestExecutionLevel admin

######################################################################
; Win 8 detection
Var IsWin8

; custom options page functions

Var InstallAllUsers
Var InstallAllUsersCtrl
Var InstallShortcuts
Var InstallShortcutsCtrl
Var RegisterOctaveFileType
Var RegisterOctaveFileTypeCtrl
Var InstallBlasLibCtrl
Var InstallBlasLib

Function octaveOptionsPage 
  Push \$0
  nsDialogs::Create 1018
  Pop \$0

  \${If} \$0 == error
    Abort
  \${EndIf} 

  \${NSD_CreateCheckBox} 0 0 100% 12u "Install for all users"
  Pop \$InstallAllUsersCtrl
  \${NSD_SetState} \$InstallAllUsersCtrl \${BST_CHECKED}

  \${NSD_CreateCheckBox} 0 20 100% 12u "Create desktop shortcuts"
  Pop \$InstallShortcutsCtrl
  \${NSD_SetState} \$InstallShortcutsCtrl \${BST_CHECKED}

  \${NSD_CreateCheckBox} 0 40 100% 12u "Register .m file type with Octave"
  Pop \$RegisterOctaveFileTypeCtrl
  \${NSD_SetState} \$RegisterOctaveFileTypeCtrl \${BST_CHECKED}

  \${NSD_CreateLabel} 0 70 110u 12u "BLAS library implementation:"
  Pop \$0

  \${NSD_CreateDropList} 120u 70 100u 80u ""
  Pop \$InstallBlasLibCtrl
EOF
   # add option to install libopenblas if we have the dll present
   if [ -e $OCTAVE_SOURCE/bin/libopenblas.dll ]; then
     cat >> $OUTFILE << EOF
  \${NSD_CB_AddString} \$InstallBlasLibCtrl "OpenBLAS"
EOF
  fi
  cat >> $OUTFILE << EOF
  \${NSD_CB_AddString} \$InstallBlasLibCtrl "Reference BLAS"
EOF

  cat >> $OUTFILE << EOF
  \${NSD_CB_SelectString} \$InstallBlasLibCtrl "$DEFAULT_BLAS"

  !insertmacro MUI_HEADER_TEXT "Install Options" "Choose options for installing"
  nsDialogs::Show  
  Pop \$0
FunctionEnd

Function octaveOptionsLeave
  \${NSD_GetState} \$InstallAllUsersCtrl \$InstallAllUsers
  \${NSD_GetState} \$InstallShortcutsCtrl \$InstallShortcuts
  \${NSD_GetState} \$RegisterOctaveFileTypeCtrl \$RegisterOctaveFileType
  \${DropList_GetCurSel} \$InstallBlasLibCtrl \$InstallBlasLib
FunctionEnd

######################################################################

Function .onInit
  Call DetectWinVer
  Call CheckCurrVersion
  Call CheckJRE
  InitPluginsDir
FunctionEnd

; file section
Section "MainFiles"

  ; set context based on whether installing for user or all
  \${If} \$InstallAllUsers == \${BST_CHECKED}
    SetShellVarContext all
  \${Else}
    SetShellVarContext current
  \${Endif}

  ; include the README
  SetOutPath "\$INSTDIR" 
  File "$OCTAVE_SOURCE/README.html"

  ; distro files
EOF

# insert the files
  IFS=$'\n'
  for f in $(find $OCTAVE_SOURCE -type d -printf "%P\n"); do
    winf=`echo $f | sed 's,/,\\\\,g'`
    echo " CreateDirectory \"\$INSTDIR\\$winf\"" >> $OUTFILE
    echo " SetOutPath \"\$INSTDIR\\$winf\"" >> $OUTFILE
    find "$OCTAVE_SOURCE/$f" -maxdepth 1 -type f -printf " File \"%p\"\n" >> $OUTFILE 
  done

  cat >> $OUTFILE << EOF

 ; add qt.conf
 Push \$0
 \${StrRep} '\$0' '\$INSTDIR' '\\' '/'
 WriteINIStr "\$INSTDIR\\bin\\qt.conf" "Paths" "Prefix" "\$0"
 WriteINIStr "\$INSTDIR\\bin\\qt.conf" "Paths" "Translations" "translations"
 Pop \$0
SectionEnd

Section make_uninstaller
 ; Write the uninstall keys for Windows
 SetOutPath "\$INSTDIR"
 WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "DisplayName" "Octave"
 WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "DisplayVersion" "$VERSION"
 WriteRegStr HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "UninstallString" "\$INSTDIR\\uninstall.exe"
 WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "NoModify" 1
 WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "NoRepair" 1
 \${If} \$InstallAllUsers == \${BST_CHECKED}
   WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "AllUsers" 1
 \${EndIf}
 WriteUninstaller "uninstall.exe"
SectionEnd

; start menu (currently hardcoded)
Section "Shortcuts"

 CreateDirectory "\$SMPROGRAMS\\Octave-$VERSION"
 CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Uninstall.lnk" "\$INSTDIR\\uninstall.exe" "" "\$INSTDIR\\uninstall.exe" 0
 SetOutPath "%USERPROFILE%"
 \${If} \$IsWin8 == 1
   CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Octave (Command Line).lnk" "\$INSTDIR\\bin\\octave-cli.exe" "-i --line-editing" "\$INSTDIR\\$ICON" 0
   CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Octave (Experimental GUI).lnk" "\$INSTDIR\\bin\\octave-gui.exe" "-i --line-editing" "\$INSTDIR\\$ICON" 0
 \${Else}
   CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Octave (Command Line).lnk" "\$INSTDIR\\bin\\octave-cli.exe" "" "\$INSTDIR\\$ICON" 0
   CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Octave (Experimental GUI).lnk" "\$INSTDIR\\bin\\octave-gui.exe" "" "\$INSTDIR\\$ICON" 0
 \${EndIf}
 SetOutPath "\$INSTDIR"
EOF
  # if we have documentation files, create shortcuts
  if [ -d $OCTAVE_SOURCE/share/doc/octave ]; then
    cat >> $OUTFILE << EOF
    CreateDirectory "\$SMPROGRAMS\\Octave-$VERSION\\Documentation"
    CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Documentation\\Octave C++ Classes (PDF).lnk" "\$INSTDIR\\share\\doc\\octave\\liboctave.pdf" "" "" 0
    CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Documentation\\Octave C++ Classes (HTML).lnk" "\$INSTDIR\\share\\doc\\octave\\liboctave.html\\index.html" "" "" 0
    CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Documentation\\Octave (PDF).lnk" "\$INSTDIR\\share\\doc\\octave\\octave.pdf" "" "" 0
    CreateShortCut "\$SMPROGRAMS\\Octave-$VERSION\\Documentation\\Octave (HTML).lnk" "\$INSTDIR\\share\\doc\\octave\\octave.html\\index.html" "" "" 0
EOF
  fi
 
  cat >> $OUTFILE << EOF

  \${If} \$InstallShortcuts == \${BST_CHECKED}
    SetOutPath "%USERPROFILE%"
    \${If} \$IsWin8 == 1
       CreateShortCut "\$desktop\\Octave-$VERSION (Command Line).lnk" "\$INSTDIR\\bin\\octave-cli.exe" "-i --line-editing" "\$INSTDIR\\$ICON" 0
       CreateShortCut "\$desktop\\Octave-$VERSION (Experimental GUI).lnk" "\$INSTDIR\\bin\\octave-gui.exe" "-i --line-editing" "\$INSTDIR\\$ICON" 0
    \${Else}
       CreateShortCut "\$desktop\\Octave-$VERSION (Command Line).lnk" "\$INSTDIR\\bin\\octave-cli.exe" "" "\$INSTDIR\\$ICON" 0
       CreateShortCut "\$desktop\\Octave-$VERSION (Experimental GUI).lnk" "\$INSTDIR\\bin\\octave-gui.exe" "" "\$INSTDIR\\$ICON" 0
    \${EndIf}
  \${Endif}

  ; BLAS set up
  \${If} \$InstallBlasLib == 1
    ; Reference BLAS
    CopyFiles /SILENT "\$INSTDIR\\bin\\librefblas.dll" "\$INSTDIR\\bin\\libblas.dll"
  \${Else}
    ; OpenBLAS
    CopyFiles /SILENT "\$INSTDIR\\bin\\libopenblas.dll" "\$INSTDIR\\bin\\libblas.dll"
  \${EndIf}

SectionEnd

Section "FileTypeRego"
  ; Octave document
  WriteRegStr HKCR "Octave.Document.$VERSION" "" "GNU Octave Script"
  WriteRegStr HKCR "Octave.Document.$VERSION\\DefaultIcon" "" "\$INSTDIR\\$ICON"
  ; document actions
  WriteRegStr HKCR "Octave.Document.$VERSION\\shell\\open\\command" "" '"\$INSTDIR\\bin\\octave-gui.exe" --force-gui --persist --eval "edit '%1'"'

  \${If} \$RegisterOctaveFileType == \${BST_CHECKED}
    ReadRegStr \$0 HKCR ".m" ""
    StrCmp "\$0" "" no_back_type
    WriteRegStr HKCR ".m" "backup_val" "\$0"  
no_back_type:
    WriteRegStr HKCR ".m" "" "Octave.Document.$VERSION"
    WriteRegDWORD HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "RegisteredFileType" 1
  \${EndIf}
SectionEnd

Section "Uninstall"

  ReadRegDWORD \$0 HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "AllUsers"
  IfErrors not_all_users

  SetShellVarContext all

not_all_users:
  ReadRegDWORD \$0 HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "RegisteredFileType"
  IfErrors not_registered_file

  ReadRegStr \$0 HKCR ".m" "backup_val"
  IfErrors not_backup_file

  # retore backup
  WriteRegStr HKCR ".m" "" "\$0"

  DeleteRegValue HKCR ".m" "backup_val"

  ; dont delete .m if just restored backup
  Goto not_registered_file
not_backup_file:
  DeleteRegKey HKCR ".m"

not_registered_file:
 ; delete file type
 DeleteRegKey HKCR "Octave.Document.$VERSION"

 DeleteRegKey HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION"
 DeleteRegKey HKLM "Software\\Octave-$VERSION"

 ; Remove shortcuts
 Delete "\$SMPROGRAMS\\Octave-$VERSION\\Documentation\\*.*"
 RMDir "\$SMPROGRAMS\\Octave-$VERSION\\Documentation"

 Delete "\$SMPROGRAMS\\Octave-$VERSION\\*.*"
 RMDir "\$SMPROGRAMS\\Octave-$VERSION"

 Delete "\$desktop\\Octave-$VERSION (Command Line).lnk" 
 Delete "\$desktop\\Octave-$VERSION (Experimental GUI).lnk" 

 ; delete generated qt.conf file
 Delete "\$INSTDIR\\bin\\qt.conf"
EOF

# insert dir list (backwards order) for uninstall files
  for f in $(find $OCTAVE_SOURCE -depth -type d -printf "%P\n"); do
    winf=`echo $f | sed 's,/,\\\\,g'`
    echo " Delete \"\$INSTDIR\\$winf\\*.*\"" >> $OUTFILE
    echo " RmDir \"\$INSTDIR\\$winf\"" >> $OUTFILE
  done

# last bit of the uninstaller
  cat >> $OUTFILE << EOF
 Delete "\$INSTDIR\\*.*"
 RmDir "\$INSTDIR"
SectionEnd

; Function to detect Windows version and abort if Octave is unsupported in the current platform
Function DetectWinVer
  Push \$0
  Push \$1

  StrCpy \$IsWin8 0

  ReadRegStr \$0 HKLM "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion" CurrentVersion
  IfErrors is_error is_winnt
is_winnt:
  StrCpy \$1 \$0 1
  StrCmp \$1 4 is_error ; Aborting installation for Windows versions older than Windows 2000
  StrCmp \$0 "5.0" is_error ; Removing Windows 2000 as supported Windows version
  StrCmp \$0 "5.1" is_winnt_XP
  StrCmp \$0 "5.2" is_winnt_2003
  StrCmp \$0 "6.0" is_winnt_vista
  StrCmp \$0 "6.1" is_winnt_7
  StrCmp \$0 "6.2" is_winnt_8
  StrCmp \$1 6 is_winnt_8 ; Checking for future versions of Windows 8
  Goto is_error

is_winnt_8:
  StrCpy \$IsWin8 1

  MessageBox MB_YESNO|MB_ICONEXCLAMATION "Setup has detected Windows 8 installed on your system. Octave is currently not fully supported on Windows 8. If you choose to continue with the installation, you might not be able to access Octave GUI. Do you want to proceed with the installation anyway?" IDYES done IDNO 0
  Abort
is_winnt_XP:
is_winnt_2003:
is_winnt_vista:
is_winnt_7:
  Goto done
is_error:
  StrCpy \$1 \$0
  ReadRegStr \$0 HKLM "SOFTWARE\\Microsoft\\Windows NT\\CurrentVersion" ProductName
  IfErrors 0 +4
  ReadRegStr \$0 HKLM "SOFTWARE\\Microsoft\\Windows\\CurrentVersion" Version
  IfErrors 0 +2
  StrCpy \$0 "Unknown"
  MessageBox MB_ICONSTOP|MB_OK "This version of Octave cannot be installed on this system. Octave is supported only on Windows NT systems. Current system: \$0 (version: \$1)"
  Abort
done:
  Pop \$1
  Pop \$0
FunctionEnd

; Function to check whether already installed this version
Function CheckCurrVersion
  Push \$0
  ClearErrors
  ReadRegStr \$0 HKLM "Software\\Microsoft\\Windows\\CurrentVersion\\Uninstall\\Octave-$VERSION" "DisplayName"
  IfErrors curr_check_ok
  MessageBox MB_OK|MB_ICONSTOP "Another Octave installation (with the same version) has been detected. Please uninstall it first."
  Abort
curr_check_ok:
  Pop \$0
FunctionEnd

; Check whether prev install is here
Function CheckPrevInstall 
  IfFileExists "\$INSTDIR\\bin\\octave.exe" inst_exists  inst_none
inst_exists:
  MessageBox MB_YESNO|MB_ICONEXCLAMATION "Another Octave installation has been detected at that destination. It is recommended to uninstall it if you intend to use the same installation directory. Do you want to proceed with the installation anyway?" IDYES inst_none IDNO 0
  Abort 
inst_none:
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
  StrCpy \$R0 "\$R0\\bin\\\${JAVAEXE}"
  IfErrors 0 continue  ;; 1) found it in JAVA_HOME

  ClearErrors
  ReadRegStr \$R1 HKLM "SOFTWARE\\JavaSoft\\Java Runtime Environment" "CurrentVersion"
  ReadRegStr \$R0 HKLM "SOFTWARE\\JavaSoft\\Java Runtime Environment\\\$R1" "JavaHome"
  StrCpy \$R0 "\$R0\\bin\\\${JAVAEXE}"

  IfErrors 0 continue  ;; 2) found it in the registry
  IfErrors JRE_Error

 JRE_Error:
  MessageBox MB_ICONEXCLAMATION|MB_YESNO "Octave includes a Java integration component, but it seems Java is not available on this system. This component requires the Java Runtime Environment from Oracle (http://www.java.com) installed on your system. Octave can work without Java available, but the Java integration component will not be functional. Installing those components without Java available might prevent Octave from working correctly. Proceed with installation anyway?" IDYES continue
  Abort
 continue:
  Pop \$R1
  Pop \$R0
FunctionEnd
EOF
