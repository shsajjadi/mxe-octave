#ifdef _WIN64
#error "this file is not ported to Win64 yet"
#endif

#define __STDC__ 1

#include <stdio.h>
#include <stdlib.h>
#include <stdarg.h>

int __mingw_vfprintf (FILE *stream, const char *fmt, va_list argptr)
{
  return vfprintf (stream, fmt, argptr);
}

int __mingw_vprintf (const char *fmt, va_list argptr)
{
  return vprintf (fmt, argptr);
}

int __mingw_vsprintf (char *buf, const char *fmt, va_list argptr)
{
  return vsprintf (buf, fmt, argptr);
}

int snprintf (char *buffer, size_t count, const char *fmt, ...)
{
  va_list av;
  int result;

  va_start (av, fmt);
  result = vsnprintf (buffer, count, fmt, av);
  va_end (av);

  return result;
}

int __mingw_snprintf (char *buffer, size_t count, const char *fmt, ...)
{
  va_list av;
  int result;

  va_start (av, fmt);
  result = vsnprintf (buffer, count, fmt, av);
  va_end (av);

  return result;
}

long long int strtoll (const char *nptr, char **endptr, int base)
{
  return _strtoi64 (nptr, endptr, base);
}

__int64 __divdi3 (__int64 num, __int64 den)
{
  return (num / den);
}

__int64 __moddi3 (__int64 num, __int64 den)
{
  return (num % den);
}

unsigned __int64 __udivdi3 (unsigned __int64 num, unsigned __int64 den)
{
  return (num / den);
}

unsigned __int64 __umoddi3 (unsigned __int64 num, unsigned __int64 den)
{
  return (num % den);
}

void __main (void)
{
  /* In GCC, this function calls _do_global_ctors.
   */
}

__declspec(naked)
void __chkstk_ms (void)
{
  __asm {
    push ecx
    push eax
    cmp eax,1000h
    lea ecx,dword ptr [esp+12]
    jb label_2

    label_1:
    sub ecx,1000h
    or dword ptr [ecx],0h
    sub eax,1000h
    cmp eax,1000h
    ja label_1

    label_2:
    sub ecx,eax
    or dword ptr [ecx],0h

    pop eax
    pop ecx
    ret
  }
}

int _CRT_MT = 1;

double __strtod (const char *nptr, char **endptr)
{
  return strtod (nptr, endptr);
}

float __strtof (const char *nptr, char **endptr)
{
  return strtod (nptr, endptr);
}
