#!/usr/bin/python3

import sys
import os
import re
import tempfile
import shutil
import fnmatch
import subprocess
import glob
import calendar;
import time;


class Env:
  verbose = True;
  tmp = "/tmp";
  msysdir = "/tmp/msys3";
  tar = "tar";
  cleanup = False;

def read_options_file(optfile):
  with open(optfile, 'r') as f:
    lines = f.read().splitlines()
    #d = dict(s.split(' = ',1) for s in lines if s.find(' = ') != -1)

    x = {}
    for  s in lines:
      if s.find(' = ') != -1:
        v = s.split(' = ',1)
        if not v[0] in x:
          x[v[0]] = []
        
        x[v[0]].append(v[1])

    return x

def save_list_file(listfile, values, hdr):
  with open(listfile, 'wt') as f:
    if hdr:
      f.write(hdr + "\n")
    for v in values:
      f.write(v + "\n")

pkg= {'license': 'GPL', 'replaces': 'pacman-contrib', 'pkgname': 'pacman', 'builddate': '1532933269', 'pkgdesc': 'A library-based package manager with dependency support (MSYS2 port)', 'checkdepend': 'python2', 'url': 'https://www.archlinux.org/pacman/', 'backup': 'etc/makepkg_mingw64.conf', 'makedepend': 'libunistring-devel', 'depend': 'xz', 'pkgbase': 'pacman', 'optdepend': 'vim', 'provides': 'pacman-contrib', 'group': 'base-devel', 'packager': 'Alexey Pavlov <alexpux@gmail.com>', 'size': '47739904', 'arch': 'i686', 'conflict': 'pacman-contrib', 'pkgver': '5.1.1-2'}

def save_desc_file(descfile, pkginfo):
  with open(descfile, 'wt') as f:

   f.write("%NAME%\n")
   v = pkginfo.get('pkgname',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%VERSION%\n")
   v = pkginfo.get('pkgver',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%DESC%\n")
   v = pkginfo.get('pkgdesc',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%ARCH%\n")
   v = pkginfo.get('arch',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%BUILDDATE%\n")
   v = pkginfo.get('builddate',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   t = calendar.timegm(time.gmtime())
   f.write("%INSTALLDATE%\n")
   f.write(str(t) + "\n\n")

   f.write("%PACKAGER%\n")
   v = pkginfo.get('packager', [])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%SIZE%\n")
   v = pkginfo.get('size',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%GROUPS%\n")
   v = pkginfo.get('group',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%LICENSE%\n")
   v = pkginfo.get('license',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%VALIDATION%\n")
   v = pkginfo.get('validation',['pgp'])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%REPLACES%\n")
   v = pkginfo.get('replaces',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%DEPENDS%\n")
   v = pkginfo.get('depend', [])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%OPTDEPENDS%\n")
   v = pkginfo.get('optdepend',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%CONFLICTS%\n")
   v = pkginfo.get('conflict',[])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

   f.write("%PROVIDES%\n")
   v = pkginfo.get('provides', [])
   for l in v:
     f.write(l+"\n")
   f.write("\n")

def create_msys_dirs(sysdir):
  if os.path.exists(sysdir) == False:
    os.makedirs(sysdir)
  if os.path.exists(sysdir + "/var/lib/pacman/local") == False:
    os.makedirs(sysdir + "/var/lib/pacman/local")
  # db file
  if os.path.exists(sysdir + "/var/lib/pacman/local/ALPM_DB_VERSION") == False:
    with open(sysdir + "/var/lib/pacman/local/ALPM_DB_VERSION", 'wt') as f:
      f.write("9\n")

def uninstall_pkg(pkgname, env):
  pkgpath = env.msysdir + "/var/lib/pacman/local/"
  files=glob.glob(pkgpath + pkgname + "-" + "[r0-9].*")
  for f in files:
    if env.verbose:
      print ("uninstalling " + f)
    shutil.rmtree(f)

def install_pkg(pkg, env):
  pkg = os.path.abspath(pkg)
  currdir = os.getcwd()
  status = 0

  try:
    ## Check that the directory in prefix exist. If it doesn't: create it!
    tmpdir = tempfile.mkdtemp("-pkg","tmp", env.tmp)
    if env.verbose:
      print ("using tempdir ", tmpdir)
    os.chdir(tmpdir)

    # unpack dir
    if env.verbose:
      os.system(env.tar + " xvpf '" + pkg + "'") 
    else:
      os.system(env.tar + " xpf '" + pkg + "'") 

    pkginfo = read_options_file(tmpdir + '/.PKGINFO')

    # uninstall prev versions
    uninstall_pkg(pkginfo.get('pkgname')[0], env)

    # copy files to dest
    filelist = []
    tmplen = len(tmpdir)
    if not tmpdir.endswith('/'):
      tmplen = tmplen + 1

    for root, dirs, files in os.walk(tmpdir):
      for dir in dirs:
          fullpath = os.path.join(root, dir)
          fullpath = fullpath[tmplen:] + "/"
          filelist.append(fullpath)
          if os.path.exists(env.msysdir + "/" + fullpath) == False:
            os.makedirs(env.msysdir + "/" + fullpath)

      for file in files:
        if not file.startswith('.'):
          fullpath = os.path.join(root, file)
          fullpath = fullpath[tmplen:]
          filelist.append(fullpath)
          if env.verbose:
            print ("installing " + fullpath)

          # dele old file fo can copy new with perms (if ld file would allow write)
          if os.path.isfile(env.msysdir + "/" + fullpath):
            os.remove(env.msysdir + "/" + fullpath)

          shutil.copy2(os.path.join(root, file), env.msysdir + "/" + fullpath)

    if env.verbose:
      print ("creating package files")

    # create pkg files needed
    pkg_name_ver = pkginfo.get('pkgname', [''])[0] + "-" + pkginfo.get('pkgver',[''])[0]
    pkg_info_dir = env.msysdir + "/var/lib/pacman/local/" + pkg_name_ver
    if os.path.exists(pkg_info_dir) == False:
      os.makedirs(pkg_info_dir)

    save_list_file (pkg_info_dir + "/files", filelist, "%FILES%")
    save_desc_file (pkg_info_dir + "/desc", pkginfo)
    shutil.copy2(tmpdir + "/.MTREE", pkg_info_dir + "/mtree")

  finally:
    if env.verbose:
      print ("cleaning up")
    os.chdir(currdir)

    if env.cleanup:
      shutil.rmtree(tmpdir)
 
  return status

def install (args):
  env = Env()

  files = []
 
  for a in args:
    print ("{}".format(a))
    c=a.split("=")
    key=c[0]
    if len(c) > 1:
      val=c[1]
    else:
      val=""

    if key == "--verbose":
      env.verbose = True;
    elif key == "-no-cleanup":
      env.cleanup = False;
    elif key == "--msys-dir":
      if val:
        env.msysdir = val;
    elif val == "":
      files.append(key)

  # set up env
  if os.environ.get("TMP") != None:
    env.tmp = os.environ["TMP"]
  os.environ['TMP'] = env.tmp;
  if os.environ.get("TAR") != None:
    env.tar = os.environ["TAR"]

  create_msys_dirs(env.msysdir)

  status = 0
  for a in files:
    status = install_pkg(a, env)
    if status != 0:
      break

  return status

def show_usage():
  print (sys.argv[0], "[options] pkg1 [pkg2]")

if __name__ == "__main__":
  if len(sys.argv) > 1:
    status = install(sys.argv[1:])
    sys.exit(status)
  else:
    show_usage()
