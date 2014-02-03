more ("off");
echo ("on");
% cd to script directory as the packages files are in the same place
[packagedir] = fileparts(mfilename("fullpathext"));
if length(packagedir) > 0
  cd(packagedir);
endif
% install the packages
pkg install general-1.3.2.tar.gz
pkg install miscellaneous-1.2.0.tar.gz
pkg install struct-1.0.10.tar.gz
pkg install optim-1.2.2.tar.gz
pkg install specfun-1.1.0.tar.gz
pkg install control-2.6.1.tar.gz
pkg install signal-1.3.0.tar.gz
pkg install communications-1.2.0.tar.gz
pkg install image-2.2.0.tar.gz
pkg install io-2.0.2.tar.gz
pkg install statistics-1.2.3.tar.gz
pkg install geometry-1.7.0.tar.gz
pkg install windows-1.2.1.tar.gz
pkg install odepkg-0.8.4.tar.gz
pkg install linear-algebra-2.2.0.tar.gz
pkg install sockets-1.0.8.tar.gz
pkg install zenity-0.5.7.tar.gz
pkg install actuarial-1.1.0.tar.gz
pkg install data-smoothing-1.3.0.tar.gz
pkg install fuzzy-logic-toolkit-0.4.2.tar.gz
pkg install quaternion-2.2.0.tar.gz
pkg install fits-1.0.3.tar.gz
pkg install fl-core-1.0.0.tar.gz
pkg install tsa-4.2.7.tar.gz
pkg install dicom-0.1.1.tar.gz

