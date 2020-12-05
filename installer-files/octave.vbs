' script to run octave in gui/command mode

Set wshShell = CreateObject( "WScript.Shell" )

' get the directory that script resides in
Set fso = CreateObject("Scripting.FileSystemObject")
OctavePath = fso.GetParentFolderName(WScript.ScriptFullName)

' ctavePath is now the root of the install folder, but for msys2,
' OctavePath should be OctavePath/mingw64 or OctavePath/ming32
MSysType = "MSYS"
MSysPath = OctavePath
Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FileExists(OctavePath & "\mingw64\bin\octave-cli.exe") Then
  MSysPath = OctavePath & "\usr"
  MSysType = "MINGW64"
  OctavePath = OctavePath & "\mingw64" 
 ElseIf objFSO.FileExists(OctavePath & "\mingw32\bin\octave-cli.exe") Then
  MSysPath = OctavePath & "\usr"
  MSysType = "MINGW32"
  OctavePath = OctavePath & "\mingw32" 
End If

' get path as a 8.3 path
Set fo = fso.GetFolder(OctavePath)
OctavePath = fo.ShortPath
Set fo = Nothing

' set up path to ensure octave bin comes first
Set wshSystemEnv = wshShell.Environment( "PROCESS" )
if OctavePath <> MSysPath Then
  wshSystemEnv("PATH") = MSysPath  & "\bin;" & wshSystemEnv("PATH")
End If
wshSystemEnv("PATH") = OctavePath & "\bin;" & wshSystemEnv("PATH")

wshSystemEnv("MSYSTEM") = MSysType

' set terminal type
wshSystemEnv("TERM") = "cygwin"
wshSystemEnv("GNUTERM") = "wxt"

wshSystemEnv("GS") = "gs.exe"

If wshShell.ExpandEnvironmentStrings("%HOME%") = "%HOME%" Then
  Home = wshSystemEnv("USERPROFILE")
  Set fo = fso.GetFolder(Home)
  wshSystemEnv("HOME") = fo.ShortPath
  Set fo = Nothing
End If

' set Qt plugin directory and path 
If objFSO.FolderExists(OctavePath & "\qt5\bin") Then
  wshSystemEnv("PATH") = OctavePath & "\qt5\bin;" & wshSystemEnv("PATH")
  wshSystemEnv("QT_PLUGIN_PATH") = OctavePath & "\qt5\plugins"
Else
  wshSystemEnv("QT_PLUGIN_PATH") = OctavePath & "\plugins"
End If

' check args to see if told to run gui or command line
' and build other args to use
GUI_MODE=1
AllArgs = ""
Set wshArgs = WScript.Arguments
For I = 0 to wshArgs.Count - 1
  If wshArgs(I) = "--no-gui" Then GUI_MODE=0
  AllArgs = AllArgs & " " & chr(34) & wshArgs(I) & chr(34)
Next

' start octave-gui, either with console shown or hidden
If GUI_MODE = 1 then
  AllArgs = AllArgs & " " & chr(34) & "--gui" & chr(34)
  wshShell.Run chr(34) & OctavePath & "\bin\octave-gui.exe" & Chr(34) & AllArgs, 0
Else
  wshShell.Run chr(34) & OctavePath & "\bin\octave-gui.exe" & Chr(34) & AllArgs, 1
End If

' free our objects
Set fso = Nothing
Set wshShell = Nothing
Set wshSystemEnv = Nothing
Set wshArgs = Nothing

