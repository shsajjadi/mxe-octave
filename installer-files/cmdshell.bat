@echo off

set OCTAVE_HOME=%~dp0

Rem   Set up PATH. Make sure the octave bin dir
Rem   comes first.

set PATH=%OCTAVE_HOME%qt5\bin;%OCTAVE_HOME%bin;%PATH%
set TERM=cygwin
set GS=gs.exe
set GNUTERM=windows

%OCTAVE_HOME%\bin\bash.exe


