@echo off

set OCTAVE_HOME=%~dp0

Rem   Set up PATH. Make sure the octave bin dir
Rem   comes first.

set PATH=%OCTAVE_HOME%bin;%PATH%
set TERM=cygwin

%OCTAVE_HOME%\bin\bash.exe


