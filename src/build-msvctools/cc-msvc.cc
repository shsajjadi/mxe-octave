/*
 * cc-msvc
 * This code is a C translation of the cccl script from Geoffrey Wossum
 * (http://cccl.sourceforge.net), with minor modifications and support for
 * additional compilation flags. This tool is primarily intended to compile
 * Octave source code with MSVC compiler.
 *
 * Copyright (C) 2006 Michael Goffioul
 * 
 * cccl
 * Wrapper around MS's cl.exe and link.exe to make them act more like
 * Unix cc and ld
 * 
 * Copyright (C) 2000-2003 Geoffrey Wossum (gwossum@acm.org)
 *
 * =========================================================================
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; If not, see <http://www.gnu.org/licenses/>.
 *
 * =========================================================================
 *
 * Compile this file with "cl -EHs -O2 cc-msvc.cc" and install it into
 * your PATH environment variable.
 * 
 */

#include <iostream>
#include <string>
#include <vector>
#include <list>
#include <algorithm>
#include <io.h>
#include <stdio.h>
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

#ifdef _MSC_VER
#define popen _popen
#define pclose _pclose
#endif

using namespace std;

static string usage_msg = 
"Usage: cc-msvc [OPTIONS]\n"
"\n"
"cc-msvc is a wrapper around Microsoft's cl.exe and link.exe.  It translates\n"
"parameters that Unix cc's and ld's understand to parameters that cl and link\n"
"understand.";
static string version_msg =
"cc-msvc 0.1\n"
"\n"
"Copyright 2006 Michael Goffioul\n"
"This is free software; see the source for copying conditions.  There is NO\n"
"waranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.\n";

inline bool starts_with(const string& s, const string& prefix)
{
	return (s.length() >= prefix.length() && s.find(prefix) == 0);
}

inline bool ends_with(const string& s, const string& suffix)
{
	return (s.length() >= suffix.length() && s.rfind(suffix) == s.length()-suffix.length());
}

static list<string> split(const string& s, char delim)
{
	list<string> result;
	size_t current = 0, pos, len = s.length ();

	while (current < len)
	{
        	pos = s.find (delim, current);
		if (pos == string::npos)
		{
			result.push_back (s.substr (current));
			break;
		}
		else
		{
			result.push_back (s.substr (current, pos - current));
			current = pos + 1;
		}
	}

	return result;
}

static string get_line(FILE *fp)
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

static string process_depend(const string& s)
{
	string result;
	string tmp(s);

	if (tmp.find(' ') != std::string::npos)
	  {
	    std::string sp;
	    int len;

	    sp.resize(tmp.length()+1);
	    len = GetShortPathName(tmp.c_str(), &sp[0], tmp.length()+1);
	    sp.resize(len);
	    tmp = sp;
	  }

	for (int i=0; i<tmp.length(); i++)
	{
		if (tmp[i] == ' ')
			result += "\\ ";
		else if (tmp[i] == '\\' && i < tmp.length()-1 && tmp[i+1] == '\\')
		{
			result.push_back('/');
			i++;
		}
		else
			result.push_back(tmp[i]);
	}
	return result;
}

static string de_cygwin_path(const string& s)
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

static string quote_path(const string& s)
{
	string result = de_cygwin_path(s);

	if (result.find(' ') != string::npos)
		return "\"" + result + "\"";
	return result;
}

static string quote_define(const string& name, const string& value)
{
	if (value[0] == '"')
	{
		string result;

		for (int i=0; i<value.length(); i++)
			switch (value[i])
			{
			case '"':
				result += "\\\"";
				break;
			case '&':
			case '<':
			case '>':
			case '(':
			case ')':
			case '|':
			case '^':
			case '@':
				result.push_back('^');
			default:
				result.push_back(value[i]);
				break;
			}
		return ("\"" + name + "=" + result + "\"");
	}
	else
	{
		if (value.find_first_of("&<>()@^| ") != string::npos)
			return ("\"" + name + "=" + value + "\"");
		else
			return (name + "=" + value);
	}
}

static string quote_quotes(const string& s)
{
	string result;

	if (s.find('"') != string::npos)
	{
		for (int i=0; i<s.length(); i++)
			if (s[i] == '"')
				result += "\\\"";
			else
				result.push_back(s[i]);
	}
	else
		result = s;

	if (result.find_first_of("&<>()@^| ") != string::npos)
		result = "\"" + result + "\"";

#if 0
	if (result.find_first_of("<>") != string::npos)
	{
		/* Could not find a better way to avoid the problem
		 * with those characters. */
		replace(result.begin(), result.end(), '<', '[');
		replace(result.begin(), result.end(), '>', ']');
	}
#endif

	return result;
}

static int do_system(const string& cmd)
{
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

  return result;
}

static bool read_stdin(const char *filename)
{
	char buf[1024];
	int n;
	FILE *fout = fopen(filename, "wb");

	if (fout == NULL)
	{
		cerr << filename << ": cannot open file for writing" << endl;
		return false;
	}
	while ((n = fread(buf, 1, 1024, stdin)) > 0)
		fwrite(buf, 1, n, fout);
	fclose(fout);
	return true;
}

static void replace_option(string& s, const string& opt, const string& val = string())
{
  if (starts_with(s, opt))
    s.erase(0, opt.length()).insert(0, val);
  if (ends_with(s, opt))
    s.erase(s.length()-opt.length()).append(val);

  string look_str = (" " + opt + " ");
  int n = opt.length();
  int pos;

  while ((pos = s.find(look_str)) != string::npos)
    s.replace(pos+1, n, val);
}

static void update_environment (void)
{
  char name_buffer[1024];
  DWORD len = GetModuleFileName (NULL, name_buffer, sizeof (name_buffer));

  if (len == 0 && len >= sizeof (name_buffer))
    return;

  string root (name_buffer);
  size_t pos = root.find_last_of ("\\/");

  if (pos != string::npos)
    root.resize (pos);

  if (root == "bin"
      || ends_with (root, "\\bin")
      || ends_with (root, "/bin"))
    {
      if (root.size () == 3)
        root.clear ();
      else
        root.resize (root.size () - 4);

      char * include_var_s = getenv ("INCLUDE");
      char * lib_var_s = getenv ("LIB");

      string include_var = (include_var_s ? include_var_s : "");
      string lib_var = (lib_var_s ? lib_var_s : "");

      if (include_var.empty ())
        include_var = "INCLUDE=" + root + "\\include";
      else
        include_var = "INCLUDE=" + root + "\\include;" + include_var;

      if (lib_var.empty ())
        lib_var = "LIB=" + root + "\\lib";
      else
        lib_var = "LIB=" + root + "\\lib;" + lib_var;

      putenv (include_var.c_str ());
      putenv (lib_var.c_str ());
    }
}

int main(int argc, char **argv)
{
	string clopt, linkopt, cllinkopt, sourcefile, objectfile, optarg, prog, exefile;
	list<string> Xlinkopt;
	bool gotparam, dodepend, exeoutput, doshared, debug = false, read_from_stdin, gotXlinker;
	bool mt_embed = true;
	bool no_exceptions = false, default_libs = true, incremental_link = false;
        bool cppmode = false;

	prog = "cl";
	// Default target is WinXP SP3
	clopt = "-nologo -MD -DWIN32 -D__CLGCC__ -D_WIN32 -D__WIN32__ -DNTDDI_VERSION=0x05010300 -D_WIN32_WINNT=0x0501";
	linkopt = "-nologo";
	cllinkopt = "";
	sourcefile = "";
	objectfile = "";
	gotparam = false;
	dodepend = false;
	exeoutput = true;
	exefile = "";
	doshared = false;
	read_from_stdin = false;
	gotXlinker = false;

        cppmode = (ends_with (argv[0], "c++-msvc.exe")
                   || ends_with (argv[0], "c++-msvc")
                   || ends_with (argv[0], "clg++.exe")
                   || ends_with (argv[0], "clg++"));
        if (cppmode)
                clopt += " -EHsc";

        update_environment ();

	if (argc == 1)
	{
		cout << usage_msg << endl;
		return 1;
	}

	for (int i=1; i<argc; i++)
	{
		string arg = argv[i];
		size_t pos;

		optarg = "";
		gotparam = true;

		if (gotXlinker)
		{
			Xlinkopt.push_back(arg);
			gotXlinker = false;
			continue;
		}

		if (!starts_with(arg, "-D") && (pos=arg.find('=')) != string::npos)
		{
			optarg = arg.substr(pos+1);
		}

		if (starts_with(arg, "-D"))
		{
			if ((pos=arg.find('=')) != string::npos)
			{
				optarg = arg.substr(pos+1);
				arg.resize(pos);
				arg = quote_define(arg, optarg);
			}
			clopt += " " + arg;
			continue;
		}

		if (arg == "--version" || arg == "-V")
		{
			cout << version_msg << endl;
			return 0;
		}
		else if (arg == "-M")
		{
			dodepend = true;
			if (!exeoutput)
				clopt += " -E";
			else
			{
				exeoutput = false;
				clopt += " -E -c";
			}
		}
		else if (arg == "-P")
		{
			clopt += " -EP";
			exeoutput = false;
		}
                else if (arg == "-E")
		{
			clopt += " -E";
			exeoutput = false;
		}
		else if (arg == "-ansi")
		{
			clopt += " -Za";
		}
		else if (arg == "-c")
		{
			if (!dodepend)
			{
				clopt += " -c";
				exeoutput = false;
			}
		}
		else if (arg == "-g" || (starts_with(arg, "-g") && arg.length() == 3 && arg[2] >= '0' && arg[2] <= '9'))
		{
			clopt += " -Zi";
			linkopt += " -debug";
		}
		else if (arg == "-d")
		{
			debug = true;
		}
		else if (arg == "-shared")
		{
			clopt += " -LD";
			linkopt += " -DLL";
			doshared = true;
		}
		else if (arg == "-mwindows")
		{
			linkopt += " -subsystem:windows";
		}
		else if (arg == "-O2" || arg == "-MD")
		{
			// do not pass those to the linker
			clopt += (" " + arg);
		}
                else if (arg == "-O3")
                {
                        // MSVC does not support -O3, convert to -O2 instead
			clopt += " -O2";
                }
		else if (starts_with(arg, "-I"))
		{
			string path = arg.substr(2);
			clopt += " -I" + quote_path(path);
		}
		else if (arg == "-isystem")
		{
			// Convert -isystem arguments into regular -I flags
			if (i < argc-1)
			{
				arg = argv[++i];
				// sysroot include prefix is not supported!!
				if (arg.length () > 0 && arg[0] == '=')
				{
					cerr << "ERROR: isystem argument starting with '=' is not supported" << endl;
					return 1;
				}
				clopt += " -I" + quote_path(arg);
			}
			else
			{
				cerr << "ERROR: isystem argument missing" << endl;
				return 1;
			}
		}
		else if (arg == "-isysroot"
			 || arg == "--sysroot")
		{
			// Ignore directory specifications (for the time being)
			if (i < argc-1)
				++i;
			else
			{
				cerr << "ERROR: missing argument for " << arg << endl;
				return 1;
			}
		}
		else if (starts_with(arg, "-L"))
		{
			string path = arg.substr(2);
			linkopt += " -LIBPATH:" + quote_path(path);
			cllinkopt += " -LIBPATH:" + quote_path(path);
		}
                else if (arg == "-link")
                {
                        while (++i < argc)
                        {
                                arg = argv[i];
                                cllinkopt += " " + arg;
                                linkopt += " " + arg;
                        }
                }
		else if (starts_with(arg, "-l"))
		{
			string libname = arg.substr(2) + ".lib";
			if (sourcefile.empty())
				clopt += " " + libname;
			else
				cllinkopt += " " + libname;
			linkopt += " " + libname;
		}
		else if (starts_with(arg, "-Wl,"))
		{
                        list<string> flags = split (arg.substr (4), ',');
			Xlinkopt.splice (Xlinkopt.end (), flags);
		}
		else if (arg == "-Xlinker")
		{
			gotXlinker = true;
		}
		else if (arg == "-Werror")
		{
			clopt += " -WX";
		}
		else if (arg == "-Wall")
		{
			//clopt += " -Wall";
		}
		else if (arg == "-fno-rtti")
		{
			clopt += " -GR-";
		}
		else if (arg == "-fno-exceptions")
		{
			no_exceptions = true;
		}
		else if (arg == "-m386" || arg == "-m486" || arg == "-mpentium" ||
			 arg == "-mpentiumpro" || arg == "-pedantic" || starts_with(arg, "-W") ||
			 arg == "-fPIC" || arg == "-nostdlib" || arg == "--export-all-symbols" ||
                         starts_with(arg, "-march=") || arg == "-fomit-frame-pointer")
		{
			// ignore
		}
                else if (arg == "--output-def")
                {
                        if (i < argc-1)
                                ++i;
                        else
                        {
				cerr << "ERROR: argument missing for " << arg << endl;
				return 1;
                        }
                }
		else if (arg == "-noembed")
		{
			mt_embed = false;
		}
		else if (arg == "-nodefaultlibs")
		{
			default_libs = false;
		}
		else if (arg == "-incremental-link")
		{
			incremental_link = true;
		}
		else if (arg == "-o")
		{
			if (i < argc-1)
			{
				arg = argv[++i];
				if (ends_with(arg, ".o") || ends_with(arg, ".obj"))
				{
					clopt += " -Fo" + quote_path(arg);
					objectfile = arg;
				}
				else if (ends_with(arg, ".exe") || ends_with(arg, ".dll") || ends_with(arg, ".oct")
					 || ends_with(arg, ".mex"))
				{
					clopt += " -Fe" + quote_path(arg);
					linkopt += " -out:" + quote_path(arg);
					exefile = arg;
				}
				else
				{
					cerr << "WARNING: unrecognized output file type " << arg << ", assuming executable" << endl;
					arg += ".exe";
					clopt += " -Fe" + quote_path(arg);
					linkopt += " -out:" + quote_path(arg);
					exefile = arg;
				}
			}
			else
			{
				cerr << "ERROR: output file name missing" << endl;
				return 1;
			}
		}
		else if (ends_with(arg, ".cc") || ends_with(arg, ".cxx") || ends_with(arg, ".C"))
		{
			clopt += " -Tp" + quote_path(arg);
			sourcefile = arg;
		}
		else if (ends_with(arg, ".o") || ends_with(arg, ".obj") || ends_with(arg, ".a") ||
			 ends_with(arg, ".lib") || ends_with(arg, ".so"))
		{
			if (ends_with(arg, ".a"))
			{
				if (_access(arg.c_str(), 00) != 0)
				{
					string libarg;
					int pos1 = arg.rfind('/');

					if (pos1 != string::npos)
						libarg = arg.substr(pos1+1);
					else
						libarg = arg;
					if (starts_with(libarg, "lib"))
						libarg = libarg.substr(3);
					libarg = arg.substr(0, pos1+1) + libarg.substr(0, libarg.length()-1) + "lib";
					if (_access(libarg.c_str(), 00) == 0)
					{
						cerr << "WARNING: Converting " << arg << " into " << libarg << endl;
						arg = libarg;
					}
				}
			}

			if (sourcefile.empty())
			{
				linkopt += " " + quote_path(arg);
				prog = "link";
			}
			else
			{
				cllinkopt += " " + quote_path(arg);
			}
		}
		else if (ends_with(arg, ".c") || ends_with(arg, ".cpp"))
		{
			clopt += " " + quote_path(arg);
			sourcefile = arg;
		}
		else if (ends_with(arg, ".dll"))
		{
			// trying to link against a DLL: convert to .lib file, keeping the same basename
			string libarg = (" " + arg.substr(0, arg.length()-4) + ".lib");
			clopt += libarg;
			linkopt += libarg;
		}
		else if (ends_with (arg, ".def"))
		{
			cllinkopt += " -DEF:" + arg;
			linkopt += " -DEF:" + arg;
		}
		else if (arg == "-")
		{
			// read source file from stdin
			read_from_stdin = true;
		}
		else
		{
			clopt += " " + quote_quotes(arg);
			linkopt += " " + quote_quotes(arg);
			if (!optarg.empty())
			{
				clopt += "=" + quote_quotes(optarg);
				linkopt += "=" + quote_quotes(optarg);
			}
		}
	}

	for (list<string>::const_iterator it = Xlinkopt.begin(); it != Xlinkopt.end(); ++it)
	{
		string arg = *it;

		if (arg == "--out-implib"
		    || starts_with (arg, "--out-implib="))
		{
			string implib;

			if (arg == "--out-implib")
			{
				++it;
				if (it != Xlinkopt.end ())
					implib = *it;
				else
				{
					cerr << "WARNING: missing import library name, ignored" << endl;
					continue;
				}
			}
			else
				implib = arg.substr (13);

			cllinkopt += " -IMPLIB:" + implib;
			linkopt += " -IMPLIB:" + implib;
		}
		else if (arg == "--enable-auto-import"
			 || arg == "--enable-auto-image-base"
			 || arg == "--whole-archive"
			 || arg == "--no-whole-archive"
			 || arg == "-Bsymbolic"
			 || arg == "-s")
		{
			// Ignore these.
		}
		else if (arg == "--output-def")
		{
			++it;
			if (it == Xlinkopt.end ())
				break;
		}
		else if (arg == "--image-base"
			 || starts_with(arg, "--image-base="))
		{
			string base_addr;

			if (arg == "--image-base")
			{
				++it;
				if (it != Xlinkopt.end ())
					base_addr = *it;
				else
				{
					cerr << "WARNING: missing base address, ignored" << endl;
					continue;
				}
			}
			else
				base_addr = arg.substr (13);

			cllinkopt += " -BASE:" + base_addr;
			linkopt += " -BASE:" + base_addr;
		}
		else
		{
			cllinkopt += " " + arg;
			linkopt += " " + arg;
		}
	}

	if (! incremental_link)
	{
                std::string arg ("-incremental:no");

		cllinkopt += " " + arg;
		linkopt += " " + arg;
	}

	if (no_exceptions)
	{
		replace_option(clopt, "-EHsc");
		replace_option(clopt, "-EHcs");
		replace_option(clopt, "-EHs");
		replace_option(clopt, "-EHc");
		replace_option(clopt, "-EHa");
		replace_option(clopt, "-GX-");
		replace_option(clopt, "-GX");
	}

	if (dodepend && prog != "cl")
	{
		cerr << "ERROR: dependency generation only possible for source file" << endl;
		return 1;
	}

	if (read_from_stdin)
	{
		sourcefile = "cc-msvc-tmp.c";
		if (!read_stdin(sourcefile.c_str()))
		{
			unlink(sourcefile.c_str());
			return 1;
		}
		clopt += (" " + sourcefile);
	}

	if (exeoutput && sourcefile.empty())
	{
		// It's possible all object files and libraries have been
		// pushed into @-files, so "prog" would still be set to "cl".
		// If there's no source file specified on the command line,
		// it's probably safe to assume we're calling the linker.

		prog = "link";
	}

	if (!exeoutput && !sourcefile.empty() && objectfile.empty())
	{
		// use .o suffix by default
		int pos = sourcefile.rfind('.');
		if (pos == string::npos)
			objectfile = sourcefile + ".o";
		else
			objectfile = sourcefile.substr(0, pos) + ".o";
		pos = objectfile.rfind('/');
		if (pos != string::npos)
			objectfile = objectfile.substr(pos+1);
		clopt += " -Fo" + objectfile;
	}

        if (exeoutput && exefile.empty())
        {
                if (doshared)
                        exefile = "a.dll";
                else
                        exefile = "a.exe";
                clopt += " -Fe" + exefile;
                linkopt += " -out:" + exefile;
        }

	if (exeoutput &&
            (ends_with(exefile, ".dll") || ends_with(exefile, ".DLL"))
            && ! doshared)
	{
		// Maybe "-shared" was missing on the command line.
		// Compensate for it!

		clopt += " -LD";
		linkopt += " -DLL";
	}

	if (exeoutput && default_libs)
	{
		cllinkopt += " posixcompat.lib msvcmath.lib shell32.lib advapi32.lib user32.lib kernel32.lib";
		linkopt += " posixcompat.lib msvcmath.lib shell32.lib advapi32.lib user32.lib kernel32.lib";
	}

	string opts;
	if (prog == "cl")
	{
		opts = clopt;
		if (!cllinkopt.empty())
			opts += " -link " + cllinkopt;
	}
	else
		opts = linkopt;

	if (dodepend)
	{
		FILE *fd;
		string cmd = prog + " " + opts, line;
		list<string> depend_list;

		if (objectfile.empty())
		{
			cerr << "ERROR: object file name missing and cannot be determined" << endl;
			return 1;
		}
		cout << objectfile << ":";

		fd = popen(cmd.c_str(), "r");
		if (fd == NULL)
		{
			cerr << "ERROR: cannot execute " << cmd << endl;
			return 1;
		}
		while (!feof(fd))
		{
			line = get_line(fd);
			if (starts_with(line, "#line"))
			{
				int pos1 = line.find('"'), pos2 = line.find('"', pos1+1);
				depend_list.push_back(process_depend(line.substr(pos1+1, pos2-pos1-1)));
			}
		}
		pclose(fd);

		depend_list.sort();
		depend_list.unique();
		for (list<string>::const_iterator it=depend_list.begin(); it!=depend_list.end(); ++it)
			cout << " \\" << endl << "  " << *it;
		cout << endl;
		return 0;
	}
	else
	{
		string cmd = prog + " " + opts;
		int cmdresult;

		if (debug)
			cout << cmd << endl;
		if ((cmdresult=do_system(cmd)) == 0 && exeoutput)
		{
			// auto-embed the manifest, if any
			if (exefile.empty())
			{
				if (!sourcefile.empty())
				{
					if (doshared)
						exefile = sourcefile + ".dll";
					else
						exefile = sourcefile + ".exe";
				}
				else
				{
					cerr << "ERROR: cannot determine the output executable file" << endl;
					return 1;
				}
			}

			if (_access((exefile + ".manifest").c_str(), 00) == 0)
			{
				// Do not auto-embed for conftest.exe (temporary executable generated
				// by configure scripts): this avoids wrong test results when an AV
				// software is scanning the executable while mt.exe tries to update it
				// (results in "mt.exe:general error c101008d:..."
				//
				// This should be harmless for common situations (can only be a problem
				// if the target application uses conftest.exe as executable name; but
				// I don't know any).

				if (mt_embed && exefile != "conftest.exe")
				{
					cmd = "mt -nologo -outputresource:" + exefile
					      + (doshared ? ";2" : ";1") + " -manifest " + exefile + ".manifest";

					if (debug)
						cout << cmd << endl;

					cmdresult = do_system(cmd);

					if (cmdresult == 0)
						_unlink((exefile + ".manifest").c_str());
				}
			}
		}

		if (read_from_stdin)
			unlink(sourcefile.c_str());

		return cmdresult;
	}
}
