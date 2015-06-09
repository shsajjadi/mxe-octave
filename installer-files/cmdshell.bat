@echo off

set OCT_HOME=%~dp0

Rem   Set up PATH. Make sure the octave bin dir
Rem   comes first.

set PATH=%OCT_HOME%bin;%PATH%
set TERM=cygwin

%OCT_HOME%\bin\bash.exe


