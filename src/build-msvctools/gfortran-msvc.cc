#include <errno.h>
#include <iostream>
#include <fstream>
#include <io.h>
#include <list>
#include <string>
#include <vector>
#include <stdlib.h>
#include <stdio.h>
#include <utility>
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

using namespace std;

bool verbose = false;

inline bool starts_with(const string& s, const string& prefix)
{
	return (s.length() >= prefix.length() && s.find(prefix) == 0);
}

inline bool ends_with(const string& s, const string& suffix)
{
	return (s.length() >= suffix.length() && s.rfind(suffix) == s.length()-suffix.length());
}

string quote(const string& s)
{
  if (s.find(' ') != string::npos)
    return "\"" + s + "\"";
  else
    return s;
}

int do_system(const string& cmd)
{
  if (verbose)
    cerr << "Running: " << cmd << endl;

  STARTUPINFO info;
  PROCESS_INFORMATION proc;
  DWORD	 result;

  ZeroMemory (&info, sizeof (info));
  info.cb = sizeof (info);
  ZeroMemory (&proc, sizeof (proc));

  if (CreateProcess (NULL, (char*)cmd.c_str (), NULL, NULL, TRUE, 0, NULL, NULL,
		     &info, &proc))
    {
      WaitForSingleObject (proc.hProcess, INFINITE);
      GetExitCodeProcess (proc.hProcess, &result);
      CloseHandle (proc.hProcess);
      CloseHandle (proc.hThread);
    }
  else
    result = (DWORD)-1;

  if (verbose)
    cerr << "Result: " << (int)result << endl;

  return result;
}

int do_system(const list<string>& args)
{
  string cmd;

  for (list<string>::const_iterator it = args.begin(); it != args.end(); ++it)
    {
      if (!cmd.empty())
	cmd += " ";
      cmd += quote(*it);
    }
  return do_system(cmd);
}

string get_env_var(const char *name, const char *defval)
{
	char *result = getenv(name);
	if (!result || result[0] == '\0')
		return string(defval);
	return string(result);
}

inline bool is_source_file (const string& s)
{
  static char* f_ext_list[] = { ".f", ".F", ".f90", ".F90", ".f77", ".F77", 0 };

  for (int i = 0; f_ext_list[i]; i++)
    if (ends_with (s, f_ext_list[i]))
      return true;

  return false;
}

inline string get_object_name (const string& s)
{
  int pos = s.rfind ('.');

  return s.substr (0, pos) + ".o";
}

string get_line(FILE *fp)
{
  static vector<char> buf(100);
  int idx = 0;
  char c;

  while (1)
    {
      c = (char)fgetc(fp);
      if (c == '\n' || c == EOF)
        break;
      if (buf.size() <= idx)
        buf.resize(buf.size() + 100);
      buf[idx++] = c;
    }
  if (idx == 0)
    return string("");
  else
    return string(&buf[0], idx);
}

string de_cygwin_path(const string& s)
{
  string result = s;

  if (starts_with(s, "/cygdrive/"))
    {
      string cmd = "cygpath -m \"" + s + "\"";
      FILE* pout = _popen(cmd.c_str(), "r");

      if (pout != NULL)
        {
          result = get_line(pout);
          _pclose(pout);
        }
    }

  return result;
}

int main (int argc, char **argv)
{
  list<string> args, compiler_opts;
  string compiler, gfortran_exe = "gfortran";
  bool do_link = true, has_files = false;
  list< pair<string, int> > source_files;

  for (int i = 1; i < argc; i++)
    {
      string arg (argv[i]);

      args.push_back (arg);

      if (arg == "-c")
	do_link = false;
      else if (arg == "-v")
	{
	  verbose = true;
	  args.pop_back ();
	}
      else if (starts_with (arg, "--gfortran-exe="))
        {
          gfortran_exe = arg.substr (15);
        }
      else if (! starts_with (arg, "-"))
	{
	  has_files = true;
	  if (is_source_file (arg))
            {
              arg = de_cygwin_path (arg);
              source_files.push_back (pair<string, int> (arg, args.size () - 1));
            }
	}
      else if (starts_with (arg, "-D")
	       || starts_with (arg, "-U")
	       || starts_with (arg, "-O")
	       || starts_with (arg, "-f")
	       || starts_with (arg, "-m"))
	compiler_opts.push_back (arg);
    }

  if (has_files)
    {
      if (do_link)
	{
	  if (! source_files.empty ())
	    {
	      // Because the compiler and the linker are different, we need
	      // to compile the source files separately.

	      for (list< pair<string, int> >::const_iterator it = source_files.begin ();
		   it != source_files.end (); ++it)
		{
		  list<string> cargs (compiler_opts);
		  string obj_name = get_object_name (it->first);

		  cargs.push_front ("-c");
		  cargs.push_front ("-ff2c");
		  cargs.push_front ("-mstackrealign");
		  cargs.push_front ("-mincoming-stack-boundary=2");
		  if (verbose)
		    cargs.push_front ("-v");
		  cargs.push_front (gfortran_exe);
		  cargs.push_back (it->first);
		  cargs.push_back ("-o");
		  cargs.push_back (obj_name);

		  int res = do_system (cargs);

		  if (res == 0)
		    {
		      list<string>::iterator lit = args.begin ();

		      for (int i = it->second; i > 0; i--, lit++)
			/* nothing */;
		      *lit = obj_name;
		    }
		  else
		    return res;
		}
	    }

	  compiler = "cc-msvc";
	  if (verbose)
	    args.push_front ("-d");
	  args.push_back ("-lgfortran-msvc");
	  args.push_back ("-lmingwcompat");
	  args.push_back ("-lmsvcrt");
	  //args.push_back ("-lmsvcrt");
	}
      else
	{
	  args.push_front ("-ff2c");
          args.push_front ("-mstackrealign");
          args.push_front ("-mincoming-stack-boundary=2");
	  if (verbose)
	    args.push_front ("-v");
	}
    }

  if (compiler.empty ())
    compiler = gfortran_exe;

  args.push_front (compiler);

  int retval = do_system (args);

  return retval;
}
