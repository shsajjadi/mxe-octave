#include <stdlib.h>
#include <stdio.h>

extern void _gfortrani_init_variables (void);
extern void _gfortrani_init_units (void);
extern void _gfortrani_close_units (void);
extern void _gfortrani_set_fpu (void);
extern void _gfortrani_init_compile_options (void);
extern void _gfortran_random_seed_i4 (void *a, void *b, void *c);
extern int _gfortrani_big_endian;

extern void __msvc_free_exe_path (void);

#pragma section(".CRT$XCU", read)
static void __cdecl __msvc_init (void);
static void __cdecl __msvc_cleanup (void);
__declspec(allocate(".CRT$XCU")) void (__cdecl *__msvc_init_) (void) = __msvc_init;

static void __cdecl __msvc_init (void)
{
  _gfortrani_big_endian = 0;
  _gfortrani_init_variables ();
  _gfortrani_init_units ();
  _gfortrani_set_fpu ();
  _gfortrani_init_compile_options ();
  _gfortran_random_seed_i4 (NULL, NULL, NULL);

  atexit (__msvc_cleanup);
}

static void __cdecl __msvc_cleanup (void)
{
  _gfortrani_close_units ();
  __msvc_free_exe_path ();
}

void __msvc_stupid_function_name_for_static_linking (void)
{
  return;
}
