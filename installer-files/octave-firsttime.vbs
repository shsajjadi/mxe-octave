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

' set Qt plugin directory
wshSystemEnv("QT_PLUGIN_PATH") = OctavePath & "\plugins"

' set directory to users
startpath = wshShell.ExpandEnvironmentStrings("%UserProfile%")
wshShell.CurrentDirectory = startpath

wshShell.Run chr(34) & OctavePath & "\bin\octave-gui.exe" & Chr(34), 0

' free our objects
Set wshShell = Nothing
Set wshSystemEnv = Nothing
Set wshArgs = Nothing

