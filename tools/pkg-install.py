#!/usr/bin/python3
import sys
import os
import re
import tempfile
import shutil
import fnmatch
import subprocess
import glob

class Env:
  mkoctfile = "mkoctfile";
  octave_config = "octave-config";
  make = "make"
  verbose = True;
  prefix = "";
  pkg = "";
  use_pkg_prefix = True;
  arch = "";
  tmp = "/tmp";
  bin_dir = "";
  m_dir = "";
  arch_dir = "";
  cleanup = False;

def show_usage():
  print (sys.argv[0], "[options] pkg1 [pkg2]")

def verify_directory(dirname):
  for f in [ "COPYING", "DESCRIPTION" ]:
    if os.path.isfile(dirname + "/" + f) == False:
      raise Exception("package is missing file " + f)

def get_description(descfile):
  with open(descfile, 'rt', encoding='latin-1') as f:
    lines = f.read().splitlines()
    pat_match = re.compile("(?P<name>[-\w]+):\s*(?P<value>\w.*)")
    lineval = ""
    d={}
    for l in lines:
      if len(l) > 0:
        if (l[0] == ' ' or l[0] == '\t'):
          lineval = lineval + l
        else:
          lineval = l

        e = pat_match.match(lineval)
        if e:
          d[e.group("name")] = e.group("value")

    return d

def extract_pkg(filename, nm):
  pkg = []
  with open(filename, 'rt', encoding='latin-1') as f:
    lines = f.read().splitlines()
    for l in lines:
      so = re.search(nm, l, re.M|re.S)
      if so:
        pkg.append(str(so.group(1)))
  return pkg 

def extract_test_code(filename):
  body = []
  if not os.path.isfile(filename):
    return body
  with open(filename, 'rt', encoding='latin-1') as f:
    lines = f.read().splitlines()
    for l in lines:
      if l.startswith("%!"):
        body.append(l)
  if not body:
    return body
  return "\n".join(body)

def write_index_file(env, desc, index_nm):

  with open(index_nm, 'wt', encoding='latin-1') as f:
    files = os.listdir(env.m_dir)
    classes = fnmatch.filter(files, "@*")

    # check classes
    for c in classes:
      class_name = c
      class_path = env.m_dir + "/" + c;
      if os.path.isdir(class_path) == True:
        class_files = list(class_name + "/" + a for a in os.listdir(class_path))
        files += class_files
   
    # arch dependant 
    if os.path.exists(env.arch_dir) == True:
      archfiles = os.listdir(env.arch_dir)
      files += archfiles

    functions = []
    for a in files:
      if a.endswith(".m"):
        functions.append( str(a[0:len(a)-2]) )
      elif a.endswith(".oct"):
        functions.append( str(a[0:len(a)-4]) )
       
    f.write(env.pkg + " >> " + desc['Title'] +  "\n");
    f.write(desc['Categories'].replace(",", " ") + "\n")
    for a in functions:
      f.write("  " + a + "\n")

def finish_installation(env, packdir):
  # octave would run post_install.m here - instead we will copy the post_install.m 
  # somewhere and then on initial startup, run the post_install
  if os.path.isfile(packdir + "/post_install.m") == True:
    if env.verbose:
      print ("Copying .. post_install.m")
    destdir = env.prefix + "/share/octave/site/m/once_only"
    if os.path.exists(destdir) == False:
      os.makedirs(destdir)
    shutil.copy2(packdir + "/post_install.m", destdir + "/" + env.pkg + "-post_install.m")

def create_pkgadddel (env, packdir, nm):
  if env.verbose:
    print ("Creating...", nm)

  instfid = open(env.m_dir + "/" + nm, "a")
  if os.path.exists(env.arch_dir) == True:
    archfid = open(env.arch_dir + "/" + nm, "w")
  else:
    archfid = instfid

  # search inst .m files for PKG_ commands
  instdir = packdir + "/inst"
  files = list(instdir + "/" + a for a in os.listdir(instdir))
  m_files = fnmatch.filter(files, "*.m")
  for f in m_files:
    for a in extract_pkg(f, '^[#%][#%]* *' + nm + ': *(.*)$'):
      instfid.write("%s\n" % str(a))

  # search src .cc files for PKG_ commands
  if os.path.exists(packdir + "/src") == True:
    srcdir = packdir + "/src"
    files = list(srcdir + "/" + a for a in os.listdir(srcdir))
    cc_files = fnmatch.filter(files, "*.cc")
    cpp_files = fnmatch.filter(files, "*.cpp")
    cxx_files = fnmatch.filter(files, "*.cxx")
    for f in cc_files + cpp_files + cxx_files:
      for a in extract_pkg(f, '^//* *' + nm + ': *(.*)$'):
        archfid.write("%s\n" % str(a))
      for a in extract_pkg(f, '^/\** *' + nm + ': *(.*) *\*/$'):
        archfid.write("%s\n" % a)

  # add PKG_XXX from packdir if exists
  if os.path.isfile(packdir + "/" + nm) == True:
    with open(packdir + "/" + nm, 'rt', encoding='latin-1') as f:
      lines = f.read().splitlines()
      for a in lines:
        archfid.write("%s\n" % a)

  # close files
  if archfid != instfid:
    archfid.close()
    if os.stat(env.arch_dir + "/" + nm).st_size == 0:
      os.remove(env.arch_dir + "/" + nm)
  instfid.close()
  if os.stat(env.m_dir + "/" + nm).st_size == 0:
    os.remove(env.m_dir + "/" + nm)

def generate_lookfor_cache (env):
  # TODO create doc-cache
  pass

def copyfile(files, destdir, verbose=False):
  if os.path.exists(destdir) == False:
    os.mkdir(destdir)
  for a in files:
    if os.path.isfile(a):
      if verbose:
        print ("copy " + a + " to " + destdir + "/")
      shutil.copy2(a, destdir)
    if os.path.isdir(a):
      name= os.path.basename(a)
      morefiles=(a + "/" + b for b in os.listdir(a))
      copyfile(morefiles, destdir + "/" + name, verbose)

def copy_files(env, pkgdir):
  if os.path.exists(env.m_dir) == False:
    os.makedirs(env.m_dir)
  instdir = pkgdir + "/inst"

  if env.verbose:
    print ("Copying m files ...")

  files = list(instdir + "/" + a for a in os.listdir(instdir))
  # filter for arch folder
  if os.path.exists(instdir + "/" + env.arch) == True:
    files.remove(instdir + "/" + env.arch)
  
  copyfile(files, env.m_dir)

  if os.path.exists(instdir + "/" + env.arch) == True:
    if env.verbose:
      print ("Copying arch files ...")
    files = list(instdir + "/" + env.arch + "/" + a for a in os.listdir(instdir + "/" + env.arch))
    if len(files) > 0:
      if os.path.exists(env.arch_dir) == False:
        os.makedirs(env.arch_dir)
      copyfile(files, env.arch_dir)
      shutil.rmtree(instdir + "/" + env.arch)

  # packinfo
  if env.verbose:
    print ("Copying packinfo files ...")
  if os.path.exists(env.m_dir + "/packinfo") == False:
    os.makedirs(env.m_dir + "/packinfo")
  copyfile([pkgdir + "/DESCRIPTION"], env.m_dir + "/packinfo")
  copyfile([pkgdir + "/COPYING"], env.m_dir + "/packinfo")
  copyfile([pkgdir + "/CITATION"], env.m_dir + "/packinfo")
  copyfile([pkgdir + "/NEWS"], env.m_dir + "/packinfo")
  copyfile([pkgdir + "/ONEWS"], env.m_dir + "/packinfo")
  copyfile([pkgdir + "/ChangeLog"], env.m_dir + "/packinfo")

  # index file
  if env.verbose:
    print ("Copying/creating INDEX ...")
  if os.path.isfile(pkgdir + "/INDEX") == True:
    copyfile([pkgdir + "/INDEX"], env.m_dir + "/packinfo")
  else:
    desc = get_description(pkgdir + "/DESCRIPTION")
    write_index_file(env, desc, env.m_dir + "/packinfo/INDEX")

  copyfile([pkgdir + "on_uninstall.m"], env.m_dir + "/packinfo")

  # doc dir ?
  docdir = pkgdir + "/doc"
  if os.path.exists(docdir) == True:
    if env.verbose:
      print ("Copying doc files ...")
    files = (docdir + "/" + a for a in os.listdir(docdir))
    copyfile(files, env.m_dir + "/doc")

   # bin dir ?
  bindir = pkgdir + "/bin"
  if os.path.exists(bindir) == True:
    if env.verbose:
      print ("Copying bin files ...")
    files = (bindir + "/" + a for a in os.listdir(bindir))
    copyfile(files, env.m_dir + "/bin")

def configure_make(env, packdir):
  if os.path.isdir(packdir + "/inst") == False:
    os.mkdir(packdir + "/inst")

  if os.path.isdir(packdir + "/src") == True:
    src = packdir + "/src"
    os.chdir(src)

    if os.path.isfile(src + "/configure") == True:
      if env.verbose:
        print ("running ./configure " + env.config_opts)

      if os.system("./configure " + env.config_opts + "") != 0:
        raise Exception("configure failed - stopping install")

    if os.path.isfile(src + "/Makefile") == True:
      if env.verbose:
        print ("running make ...")
      if os.system(env.make + " --directory '" + src + "'" ) != 0:
        raise Exception("make failed during build - stopping install")

    # extract any tests
    if env.verbose:
      print ("checking for src BIST tests")

    files = os.listdir(src)
    srcfiles = fnmatch.filter(files, "*.cc") + fnmatch.filter(files,"*.cpp") + fnmatch.filter(files, "*.cxx") + fnmatch.filter(files, "*.c")
    for sf in srcfiles:
      tst = extract_test_code(sf)
      if tst:
        with open(sf + "-tst", "wt", encoding='latin-1') as f:
          f.write("## DO NOT EDIT! Generated from " + sf + "\n")
          f.write(tst + "\n")

    # copy files to inst and inst arch
    files = src + "/FILES"
    instdir = packdir + "/inst"
    archdir = instdir + "/" + env.arch

    if os.path.isfile(files) == True:
      raise Exception("make using FILES not supported yet")
      pass # TODO yet
    else:
      # get .m, .oct and .mex files
      files = os.listdir(src)
      m_files = fnmatch.filter(files, "*.m")
      tst_files = fnmatch.filter(files, "*-tst")
      mex_files = fnmatch.filter(files, "*.mex")
      oct_files = fnmatch.filter(files, "*.oct")
      files = m_files + mex_files + oct_files + tst_files
      files = list(src + "/" + s for s in files)

    # split files into arch and non arch files
    archdependant = fnmatch.filter(files, "*.mex") + fnmatch.filter(files,"*.oct") + fnmatch.filter(files, "*-tst")
    archindependant = list( x for x in files if x not in archdependant )

    # copy the files
    copyfile(archindependant, instdir)
    copyfile(archdependant, archdir)

def add_package_list(env, desc):
  #pkglist = env.prefix + "/share/octave/octave_packages"
  #with open(pkglist, 'rt', encoding='latin-1') as f:
  #  lines = f.read().splitlines()
  # currently doing nothing for adding, will let installer do
  pass
  
def uninstall_pkg(pkg,env):
  # uninstall existing directories
  if env.verbose:
     print ("Uninstalling " + env.pkg)

  files=glob.glob(env.prefix + "/share/octave/packages/" + env.pkg + "-" + "*")
  for f in files:
    if env.verbose:
      print ("removing dir " + f)
    shutil.rmtree(f)

  files=glob.glob(env.prefix + "/lib/octave/packages/" + env.pkg + "-" + "*")
  for f in files:
    if env.verbose:
      print ("removing dir " + f)
    shutil.rmtree(f)

  pass

def install_pkg(pkg, env):
  pkg = os.path.abspath(pkg)
  currdir = os.getcwd()

  if env.verbose:
     print ("Installing " + pkg)

  try:
    ## Check that the directory in prefix exist. If it doesn't: create it!
    tmpdir = tempfile.mkdtemp("-pkg","tmp", env.tmp)
    os.chdir(tmpdir)

    # unpack dir
    if env.verbose:
      os.system("tar xzvf '" + pkg + "'") 
    else:
      os.system("tar xzf '" + pkg + "'") 

    # get list for files creates
    files=os.listdir(tmpdir)
    if len(files) != 1:
      print ("Expected to unpack to only one directory")

    packdir = os.path.abspath(files[0])

    # verify have expected min files
    verify_directory(packdir)

    # read the description file
    desc = get_description(packdir + "/DESCRIPTION")

    # make the path names
    env.pkg = desc['Name'].lower()
    env.m_dir = env.prefix + "/share/octave/packages/" + env.pkg + "-" + desc['Version'];
    env.arch_dir = env.prefix + "/lib/octave/packages/" + env.pkg + "-" + desc['Version'] + "/" + env.arch

    configure_make (env, packdir)

    # uninstall old packages
    uninstall_pkg(pkg, env)

    # install package files
    copy_files(env, packdir)
    create_pkgadddel (env, packdir, "PKG_ADD");
    create_pkgadddel (env, packdir, "PKG_DEL");
    finish_installation(env, packdir)
    generate_lookfor_cache (env);

    # update package list
    add_package_list(env, desc)
  finally:
    if env.verbose:
      print ("cleaning up")
    os.chdir(currdir)

    if env.cleanup:
      shutil.rmtree(tmpdir)

def fix_depends(deps):
  deplist = [s.strip() for s in deps.split(",") if len(s.strip()) > 0]
  deppat = re.compile('\s*(?P<name>[-\w]+)\s*(\(\s*(?P<op>[<>=]+)\s*(?P<ver>\d+\.\d+(\.\d+)*)\s*\))*\s*')
  deps = []
  for d in deplist:
    e = deppat.match(d)
    name = e.group("name")
    ver = e.group("ver")

    if ver:
      op = e.group("op")
    else:
      op = ">="
      ver = "0.0.0"

    deps.append({"package": name, "operator": op, "version": ver})

  return deps 

def rebuild_pkg(env):
  currdir = os.getcwd()

  if env.verbose:
    print ("Rebuilding package")

  try:
    oct_dir = env.prefix + "/share/octave"
    pkg_dir = oct_dir + "/packages"
    arch_dir = env.prefix + "/lib/octave/packages"

    pkg_list_file = oct_dir + "/octave_packages"

    descs=glob.glob(pkg_dir + "/*/packinfo/DESCRIPTION")

    if env.verbose:
      print ("Rebuilding pkg list {}".format(pkg_list_file))

    with open(pkg_list_file, "wt", encoding='latin-1') as f:
      f.write("# Created by pkg-install.py\n")
      f.write("# name: global_packages\n")
      f.write("# type: cell\n");
      f.write("# rows: 1\n")
      f.write("# columns: {}\n".format(len(descs)))

      for d in descs:
        pkg = d[len(pkg_dir):-len("/packinfo/DESCRIPTION")]
        desc = get_description(d)
        desc["Name"] = desc["Name"].lower()
        desc["Depends"] = fix_depends(desc.get("Depends",""))

        f.write("# name: <cell-element>\n");
        f.write("# type: scalar struct\n");
        f.write("# ndims: 2\n");
        f.write(" 1 1\n");
        f.write("# length: 13\n");

        pkg_fields = [ "Name", "Version", "Date", "Author", "Maintainer", \
          "Title", "Description", "Depends", "Autoload", "License" ]
        for field in pkg_fields:
          name = field.lower()
          value = desc.get(field, None)
          if value is None:
            if name == "autoload":
              value = "no"
            else:
              value = "not set"

          f.write("# name: {}\n".format(name))
          if name == "depends":
            f.write("# type: cell\n")
            f.write("# rows: 1\n")
            f.write("# columns: {}\n".format(len(value)))
            dep_fields = [ "package", "operator", "version" ]
            for dep in value:
              f.write("# name: <cell-element>\n")
              f.write("# type: scalar struct\n")
              f.write("# ndims: 2\n")
              f.write(" 1 1\n");
              f.write("# length: 3\n");

              for df in dep_fields:
                val = dep.get(df)
                f.write("# name: {}\n".format(df))
                f.write("# type: sq_string\n")
                f.write("# elements: 1\n")
                f.write("# length: {}\n".format(len(str(val))))
                f.write("{}\n".format(str(val)))
                f.write("\n\n");

            f.write("\n\n");
          else:
            f.write("# type: sq_string\n")
            f.write("# elements: 1\n")
            f.write("# length: {}\n".format(len(str(value))))
            f.write("{}\n".format(str(value)))

          f.write("\n\n");

        f.write("# name: loaded\n")
        f.write("# type: bool\n")
        f.write("0\n")
        f.write("\n\n");

        name = "dir"
        if env.use_pkg_prefix:
          value = "__OH__/share/octave/packages" + pkg
        else:
          value = pkg_dir + pkg

        f.write("# name: {}\n".format(name))
        f.write("# type: sq_string\n")
        f.write("# elements: 1\n")
        f.write("# length: {}\n".format(len(str(value))))
        f.write("{}\n".format(str(value)))
        f.write("\n\n");

        name = "archprefix"
        if env.use_pkg_prefix:
          value = "__OH__/lib/octave/packages" + pkg
        else:
          value = arch_dir + pkg
        f.write("# name: {}\n".format(name))
        f.write("# type: sq_string\n")
        f.write("# elements: 1\n")
        f.write("# length: {}\n".format(len(str(value))))
        f.write("{}\n".format(str(value)))
        f.write("\n\n");
  finally:
    os.chdir(currdir)


def pkg (args):
  arch = ''
  operation = "install"

  env = Env()

  files = []

  operation = args[0]
  if operation != "install" and operation != "rebuild":
    raise Exception("Expected pkg operation 'install' or 'rebuild'")


  args = args[1:]
 
  for a in args:
    c=a.split("=")
    key=c[0]
    if len(c) > 1:
      val=c[1]
    else:
      val=""

    if key == "-verbose":
      env.verbose = True;
    elif key == "--verbose":
      env.verbose = True;
    elif key == "--no-pkg-prefix":
      env.use_pkg_prefix = False;
    elif key == "-no-cleanup":
      env.cleanup = False;
    elif val == "":
      files.append(key)


  if os.environ.get("OCTAVE_CONFIG") != None:
    env.octave_config = os.environ["OCTAVE_CONFIG"]
  if os.environ.get("MAKE") != None:
    env.make = os.environ["MAKE"]
  if os.environ.get("MKOCTFILE") != None:
    env.mkoctfile = os.environ["MKOCTFILE"]
  if os.environ.get("TMP") != None:
    env.tmp = os.environ["TMP"]

  if env.verbose:
    env.mkoctfile = env.mkoctfile + " --verbose"

  # make sure we have these set up in env
  os.environ['OCTAVE_CONFIG'] = env.octave_config;
  os.environ['MAKE'] = env.make;
  os.environ['MKOCTFILE'] = env.mkoctfile;
  os.environ['TMP'] = env.tmp;
  os.environ['OCTAVE'] = 'echo';

  if os.environ.get("CC") == None:
    os.environ['CC'] = os.popen(env.mkoctfile + " -p CC").read().rstrip("\r\n")
  if os.environ.get("CXX") == None:
    os.environ['CXX'] = os.popen(env.mkoctfile + " -p CXX").read().rstrip("\r\n")
  if os.environ.get("AR") == None:
    os.environ['AR'] = os.popen(env.mkoctfile + " -p AR").read().rstrip("\r\n")
  if os.environ.get("RANLIB") == None:
    os.environ['RANLIB'] = os.popen(env.mkoctfile + " -p RANLIB").read().rstrip("\r\n")
  
  if os.environ.get("CONFIGURE_OPTIONS") != None:
    env.config_opts = os.environ['CONFIGURE_OPTIONS']

  # work out what arch is etc from mkoctfile/config
  if env.prefix == "":
    env.prefix = os.popen(env.octave_config + " -p OCTAVE_HOME").read().rstrip("\r\n")
  if env.prefix == "":
    env.prefix = os.popen(env.octave_config + " -p PREFIX").read().rstrip("\r\n")

  arch = os.popen(env.octave_config + " -p CANONICAL_HOST_TYPE").read().rstrip("\r\n")
  apiver = os.popen(env.octave_config + " -p API_VERSION").read().rstrip("\r\n")
  env.arch = arch + "-" + apiver

  env.bindir = os.popen(env.octave_config + " -p BINDIR").read().rstrip("\r\n")

  if env.verbose:
    print ("operation=", operation)
    print ("mkoctfile=", env.mkoctfile)
    print ("arch=", env.arch)
    print ("prefix=", env.prefix)
    print ("files=", files)
    print ("verbose=", env.verbose)

  if operation == "install":
    for a in files:
      install_pkg(a, env)
      # rebuild pkg list afterwards
      rebuild_pkg(env)
  else:
      rebuild_pkg(env)
  return 0

if __name__ == "__main__":
  if len(sys.argv) > 1:
    pkg(sys.argv[1:])
  else:
    show_usage()
