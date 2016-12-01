@echo off

set ROOT_DIR=%~dp0
echo "Updating fc-cache (may take a file) ..."
%ROOT_DIR%\bin\fc-cache.exe -v
echo "Done."

