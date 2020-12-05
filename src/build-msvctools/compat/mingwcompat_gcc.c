#ifdef __MINGW64__
#error "this file is not ported to MinGW-64 yet"
#endif

/*
 * Code mainly copied from libgcc2.c.
 */

typedef 	float SFtype	__attribute__ ((mode (SF)));
typedef		float DFtype	__attribute__ ((mode (DF)));
typedef		float XFtype	__attribute__ ((mode (XF)));
typedef		float TFtype	__attribute__ ((mode (TF)));

#define W_TYPE_SIZE 32
#define UDWtype unsigned long long
#define UWtype unsigned long
#define Wtype_MAXp1_F 0x1p32f

#define __fixunsdfDI __fixunsdfdi
#define __fixunsxfDI __fixunsxfdi

UDWtype
__fixunsdfDI (DFtype a)
{
  /* Get high part of result.  The division here will just moves the radix
     point and will not cause any rounding.  Then the conversion to integral
     type chops result as desired.  */
  const UWtype hi = a / Wtype_MAXp1_F;

  /* Get low part of result.  Convert `hi' to floating type and scale it back,
     then subtract this from the number being converted.  This leaves the low
     part.  Convert that to integral type.  */
  const UWtype lo = a - (DFtype) hi * Wtype_MAXp1_F;

  /* Assemble result from the two parts.  */
  return ((UDWtype) hi << W_TYPE_SIZE) | lo;
}

UDWtype
__fixunsxfDI (XFtype a)
{
  if (a < 0)
    return 0;

  /* Compute high word of result, as a flonum.  */
  const XFtype b = (a / Wtype_MAXp1_F);
  /* Convert that to fixed (but not to DWtype!),
     and shift it into the high word.  */
  UDWtype v = (UWtype) b;
  v <<= W_TYPE_SIZE;
  /* Remove high part from the XFtype, leaving the low part as flonum.  */
  a -= (XFtype)v;
  /* Convert that to fixed (but not to DWtype!) and add it in.
     Sometimes A comes out negative.  This is significant, since
     A has more bits than a long int does.  */
  if (a < 0)
    v -= (UWtype) (- a);
  else
    v += (UWtype) a;
  return v;
}

#define POWIF_IMPL(NAME, TYPE) \
TYPE \
NAME (TYPE x, int m) \
{ \
  unsigned int n = m < 0 ? -m : m; \
  TYPE y = n % 2 ? x : 1; \
  while (n >>= 1) \
    { \
      x = x * x; \
      if (n % 2) \
	y = y * x; \
    } \
  return m < 0 ? 1/y : y; \
}

POWIF_IMPL(__powisf2, SFtype)
POWIF_IMPL(__powidf2, DFtype)
POWIF_IMPL(__powixf2, XFtype)

long double __strtold (const char *nptr, char **endptr)
{
  return strtod (nptr, endptr);
}
