more ("off");
echo ("on");
% cd to script directory as the packages files are in the same place
[packagedir] = fileparts(mfilename("fullpathext"));
if length(packagedir) > 0
  cd(packagedir);
endif

% helper function to try install a package, and recover
function try_install (pkgname)
  currdir = pwd ();
 
  try
    pkg ('install', pkgname, '-noauto')
  catch err
    warning (err.identifier, err.message);
  end_try_catch

  cd (currdir);
endfunction

% install the packages
try_install general-1.3.4.tar.gz
try_install miscellaneous-1.2.1.tar.gz
try_install struct-1.0.11.tar.gz
try_install optim-1.4.1.tar.gz
try_install specfun-1.1.0.tar.gz
try_install control-2.6.6.tar.gz
try_install signal-1.3.0.tar.gz
try_install communications-1.2.0.tar.gz
try_install image-2.2.2.tar.gz
try_install io-2.2.7.tar.gz
try_install statistics-1.2.4.tar.gz
try_install geometry-1.7.0.tar.gz
try_install windows-1.2.1.tar.gz
try_install odepkg-0.8.4.tar.gz
try_install linear-algebra-2.2.0.tar.gz
try_install sockets-1.2.0.tar.gz
try_install zenity-0.5.7.tar.gz
try_install actuarial-1.1.0.tar.gz
try_install data-smoothing-1.3.0.tar.gz
try_install fuzzy-logic-toolkit-0.4.5.tar.gz
try_install quaternion-2.2.2.tar.gz
try_install fits-1.0.5.tar.gz
try_install fl-core-1.0.0.tar.gz
try_install tsa-4.2.7.tar.gz
try_install dicom-0.1.1.tar.gz
try_install netcdf-1.0.6.tar.gz
try_install ltfat-2.0.1.tar.gz

