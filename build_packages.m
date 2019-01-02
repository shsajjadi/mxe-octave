 attempt to compile and install the octave packages

orig_echo = echo_executing_commands ();
orig_more = page_screen_output();

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

unwind_protect

  more ("off");
  echo ("on");

  % cd to script directory as the packages files are in the same place
  [packagedir] = fileparts(mfilename("fullpathext"));
  if length(packagedir) > 0
    cd(packagedir);
  endif

  % install the packages
  try_install general-2.1.0.tar.gz
  try_install miscellaneous-1.2.1.tar.gz
  try_install struct-1.0.15.tar.gz
  try_install optim-1.5.3.tar.gz
  try_install control-3.1.0.tar.gz
  try_install signal-1.4.0.tar.gz
  try_install communications-1.2.1.tar.gz
  try_install image-2.10.0.tar.gz
  try_install io-2.4.12.tar.gz
  try_install statistics-1.4.0.tar.gz
  try_install geometry-3.0.0.tar.gz
  try_install windows-1.3.0.tar.gz
  try_install odepkg-0.8.5.tar.gz
  try_install linear-algebra-2.2.2.tar.gz
  try_install sockets-1.2.0.tar.gz
  try_install data-smoothing-1.3.0.tar.gz
  try_install fuzzy-logic-toolkit-0.4.5.tar.gz
  try_install quaternion-2.4.0.tar.gz
  try_install fits-1.0.7.tar.gz
  try_install tsa-4.4.5.tar.gz
  try_install dicom-0.2.1.tar.gz
  try_install netcdf-1.0.12.tar.gz
  try_install ltfat-2.2.0.tar.gz
  try_install database-2.4.3.tar.gz
  try_install instrument-control-0.3.1.tar.gz
  try_install generate_html-0.3.1.tar.gz
  try_install financial-0.5.3.tar.gz
  try_install stk-2.5.1.tar.gz
  try_install splines-1.3.2.tar.gz
  try_install dataframe-1.2.0.tar.gz
  try_install lssa-0.1.3.tar.gz
  try_install queueing-1.2.6.tar.gz
  try_install nurbs-1.3.13.tar.gz
  try_install strings-1.2.0.tar.gz
  try_install ga-0.10.0.tar.gz
  try_install interval-3.2.0.tar.gz
  try_install nan-3.1.4.tar.gz
  try_install ocs-0.1.5.tar.gz
  try_install mapping-1.2.1.tar.gz
  try_install tisean-0.2.3.tar.gz
  try_install sparsersb-1.0.6.tar.gz
  try_install video-1.2.4.tar.gz
  try_install zeromq-1.3.0.tar.gz
  try_install gsl-2.1.1.tar.gz
  try_install optiminterp-0.3.5.tar.gz

unwind_protect_cleanup
  echo_executing_commands (orig_echo);
  page_screen_output(orig_more);
  clear ("orig_echo", "orig_more");
end_unwind_protect  
