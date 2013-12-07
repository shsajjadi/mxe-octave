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

# initial installer settings
  cat >> octave.nsi << EOF

; installer settings
Name "Octave"
OutFile "Octave-Installer.exe"
InstallDir "c:\\$OCTAVE_SOURCE"
Icon "$OCTAVE_SOURCE\\$ICON"
ShowInstDetails show
ShowUnInstDetails show

Page directory
Page instfiles

UninstPage uninstConfirm
Uninstpage instfiles

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
 CreateShortCut "\$SMPROGRAMS\Octave\\Octave (No GUI).lnk" "\$INSTDIR\\bin\\octave-cli.exe" "" "\$INSTDIR\\$ICON" 0
  
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

