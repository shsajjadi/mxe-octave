@echo off

set ROOT_DIR=%~dp0
if EXIST %ROOT_DIR%\mingw32\bin\octave-cli.exe set ROOT_DIR=%ROOT_DIR%\mingw32
if EXIST %ROOT_DIR%\mingw64\bin\octave-cli.exe set ROOT_DIR=%ROOT_DIR%\mingw64
echo "Updating fc-cache (may take a while) ..."
%ROOT_DIR%\bin\fc-cache.exe -v
echo "Done."

