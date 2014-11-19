#include <stdlib.h>
#include <stdio.h>
#define WIN32_LEAN_AND_MEAN
#include <windows.h>

extern void _gfortrani_init_variables (void);
extern void _gfortrani_init_units (void);
extern void _gfortrani_close_units (void);
extern void _gfortrani_set_fpu (void);
extern void _gfortrani_init_compile_options (void);
extern void _gfortran_random_seed_i4 (void *a, void *b, void *c);
extern int _gfortrani_big_endian;

extern void __msvc_free_exe_path (void);

static void __cdecl __msvc_init (void)
{
  _gfortrani_big_endian = 0;
  _gfortrani_init_variables ();
  _gfortrani_init_units ();
  _gfortrani_set_fpu ();
  _gfortrani_init_compile_options ();
  _gfortran_random_seed_i4 (NULL, NULL, NULL);
}

static void __cdecl __msvc_cleanup (void)
{
  _gfortrani_close_units ();
  __msvc_free_exe_path ();
}

BOOL WINAPI DllMain (HINSTANCE hinstDLL, DWORD fdwreason, LPVOID lpvReserved)
{
  switch (fdwreason)
    {
    case DLL_PROCESS_ATTACH:
      __msvc_init ();
      break;
    case DLL_PROCESS_DETACH:
      __msvc_cleanup ();
      break;
    default:
      break;
    }

  return TRUE;
}
