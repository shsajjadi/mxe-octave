' script to run octave in gui/command mode

Set wshShell = CreateObject( "WScript.Shell" )

' get the directory that script resides in
Set fso = CreateObject("Scripting.FileSystemObject")
OctavePath = fso.GetParentFolderName(WScript.ScriptFullName)
Set fso = Nothing

' set up path to ensure octave bin comes first
Set wshSystemEnv = wshShell.Environment( "PROCESS" )
wshSystemEnv("PATH") = OctavePath & "\bin;" & wshSystemEnv("PATH")

' set terminal type
wshSystemEnv("TERM") = "cygwin"
wshSystemEnv("GNUTERM") = "windows"

wshSystemEnv("GS") = "gs.exe"

' set Qt plugin directory and path 
Set objFSO = CreateObject("Scripting.FileSystemObject")
If objFSO.FolderExists(OctavePath & "\qt5\bin") Then
  wshSystemEnv("PATH") = OctavePath & "\qt5\bin;" & wshSystemEnv("PATH")
  wshSystemEnv("QT_PLUGIN_PATH") = OctavePath & "\qt5\plugins"
Else
  wshSystemEnv("QT_PLUGIN_PATH") = OctavePath & "\plugins"
End If

' set directory to users
startpath = wshShell.ExpandEnvironmentStrings("%UserProfile%")
wshShell.CurrentDirectory = startpath

wshShell.Run chr(34) & OctavePath & "\bin\octave-gui.exe" & Chr(34), 0

' free our objects
Set wshShell = Nothing
Set wshSystemEnv = Nothing
Set wshArgs = Nothing

