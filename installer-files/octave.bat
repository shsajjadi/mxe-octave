@echo off
Rem   Find Octave's install directory through cmd.exe variables.
Rem   This batch file should reside in Octaves installation subdir!
Rem
Rem   This trick finds the location where the batch file resides.
Rem   Note: the result ends with a backslash.
set OCT_HOME=%~dp0
Rem Convert to 8.3 format so we don't have to worry about spaces.
for %%I in ("%OCT_HOME%") do set OCT_HOME=%%~sI

Rem   Set up PATH.  Make sure the octave bin dir comes first.

set PATH=%OCT_HOME%qt5\bin;%OCT_HOME%bin;%PATH%

Rem   Set up any environment vars we may need.

set TERM=cygwin
set GNUTERM=wxt
set GS=gs.exe
 
Rem QT_PLUGIN_PATH must be set to avoid segfault (bug #53419).
IF EXIST "%OCT_HOME%\qt5\bin\" (
  set QT_PLUGIN_PATH=%OCT_HOME%\qt5\plugins
) ELSE (
  set QT_PLUGIN_PATH=%OCT_HOME%\plugins
)

Rem set home if not already set
if "%HOME%"=="" set HOME=%USERPROFILE%
if "%HOME%"=="" set HOME=%HOMEDRIVE%%HOMEPATH%
Rem set HOME to 8.3 format
for %%I in ("%HOME%") do set HOME=%%~sI

Rem   Check for args to see if we are told to start GUI (--gui, --force-gui)
Rem   or not (--no-gui).
Rem   If nothing is specified, start the GUI.
set GUI_MODE=1
:checkargs
if -%1-==-- goto args_done

if %1==--gui (
  set GUI_MODE=1
) else (
if %1==--force-gui (
  set GUI_MODE=1
) else (
if %1==--no-gui (
  set GUI_MODE=0
)))

Rem move to next argument and continue processing
shift
goto checkargs

:args_done

Rem   Start Octave (this detaches and immediately returns):
if %GUI_MODE%==1 (
  start octave-gui.exe --gui %*
) else (
  start octave-cli.exe %*
)

Rem   Close the batch file's cmd.exe window
exit
