' script to run octave in gui/command mode

Set wshShell = CreateObject( "WScript.Shell" )

' get the directory that script resides in
Set fso = CreateObject("Scripting.FileSystemObject")
OctavePath = fso.GetParentFolderName(WScript.ScriptFullName)
Set fso = Nothing

' set up path to ensure octave bin comes first
Set wshSystemEnv = wshShell.Environment( "PROCESS" )
wshSystemEnv("PATH") = OctavePath & ";" & wshSystemEnv("PATH")

' set terminal type
wshSystemEnv("TERM") = "cygwin"

' check args to see if told to run gui or command line
' and build other args to use
GUI_MODE=1
AllArgs = ""
Set wshArgs = WScript.Arguments
For I = 0 to wshArgs.Count - 1
  if wshArgs(I) = "--force-gui" then GUI_MODE=1
  if wshArgs(I) = "--no-gui" then GUI_MODE=0
  AllArgs = AllArgs & " " & chr(34) & wshArgs(I) & chr(34)
Next

' start whatever octave we no want to run
If GUI_MODE = 1 then
  wshShell.Run chr(34) & OctavePath & "\bin\octave-gui.exe" & Chr(34) & AllArgs, 0
Else
  wshShell.Run chr(34) & OctavePath & "\bin\octave-cli.exe" & Chr(34) & AllArgs, 1
End If

' free our objects
Set wshShell = Nothing
Set wshSystemEnv = Nothing
Set wshArgs = Nothing

