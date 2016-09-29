@echo off
Rem   Find Octave's install directory through cmd.exe variables.
Rem   This batch file should reside in Octaves installation subdir!
Rem
Rem   This trick finds the location where the batch file resides.
Rem   Note: the result ends with a backslash
set OCT_HOME=%~dp0

Rem   Set up PATH. Make sure the octave bin dir
Rem   comes first.

set PATH=%OCT_HOME%qt5\bin;%OCT_HOME%bin;%PATH%

Rem   Set up any environment vars we may need

set TERM=cygwin
set GNUTERM=windows
set GS=gs.exe

Rem   Check for args to see if we are told to start GUI
Rem   with the --force-gui option or not (--no-gui)
Rem   Otherwise assume starting as command line
set GUI_MODE=1
:checkargs
if -%1-==-- goto noargs
  if NOT %1==--force-gui goto notguiarg
    set GUI_MODE=1
:notguiarg
  if NOT %1==--no-gui goto notnoguiarg
    set GUI_MODE=0
:notnoguiarg
  shift
  goto  checkargs
:noargs

Rem   Start Octave (this detaches and immediately returns):
if %GUI_MODE%==1 (
start octave-gui.exe %*
) else (
start octave-cli.exe %*
)

Rem   Close the batch file's cmd.exe window
exit
