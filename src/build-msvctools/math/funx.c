/*
 * This file is part of msvcmath library.
 * Author: Michael Goffioul.
 */
#include "msvcmath.h"

#define FUNC_IMPL_1(FUNC, RETTYPE, TYPE, SUFFIX) \
RETTYPE FUNC ## SUFFIX (TYPE x) { return (RETTYPE) FUNC (x); }
#define FUNC_IMPL_2(FUNC, TYPE, SUFFIX) FUNC_IMPL_1(FUNC, TYPE, TYPE, SUFFIX)
#define FUNC_IMPL_F(FUNC) FUNC_IMPL_2(FUNC, float, f)
#define FUNC_IMPL_L(FUNC) FUNC_IMPL_2(FUNC, long double, l)

#define FUNC_IMPL2_2(FUNC, TYPE, TYPE1, TYPE2, SUFFIX) \
TYPE FUNC ## SUFFIX (TYPE1 x, TYPE2 y) \
  { return (TYPE) FUNC (x, y); }
#define FUNC_IMPL2_1(FUNC, TYPE, SUFFIX) \
  FUNC_IMPL2_2(FUNC, TYPE, TYPE, TYPE, SUFFIX)
#define FUNC_IMPL2_F(FUNC) FUNC_IMPL2_1(FUNC, float, f)
#define FUNC_IMPL2_L(FUNC) FUNC_IMPL2_1(FUNC, long double, l)

FUNC_IMPL2_2(frexp, float, float, int*, f)

#ifndef _M_IA64

FUNC_IMPL2_2(ldexp, float, float, int, f)
FUNC_IMPL_F(fabs)

# ifndef _M_AMD64

FUNC_IMPL_F(acos)
FUNC_IMPL_F(asin)
FUNC_IMPL_F(atan)
FUNC_IMPL_F(ceil)
FUNC_IMPL_F(cos)
FUNC_IMPL_F(cosh)
FUNC_IMPL_F(exp)
FUNC_IMPL_F(floor)
FUNC_IMPL_F(log)
FUNC_IMPL_F(log10)
FUNC_IMPL_F(sin)
FUNC_IMPL_F(sinh)
FUNC_IMPL_F(sqrt)
FUNC_IMPL_F(tan)
FUNC_IMPL_F(tanh)

FUNC_IMPL2_F(atan2)
FUNC_IMPL2_F(fmod)
FUNC_IMPL2_F(pow)

# endif /* ! _M_AMD64 */

#endif /* ! _M_IA64 */

FUNC_IMPL_L(acos)
FUNC_IMPL_L(asin)
FUNC_IMPL_L(atan)
FUNC_IMPL_L(ceil)
FUNC_IMPL_L(cos)
FUNC_IMPL_L(cosh)
FUNC_IMPL_L(exp)
FUNC_IMPL_L(floor)
FUNC_IMPL_L(log)
FUNC_IMPL_L(log10)
FUNC_IMPL_L(sin)
FUNC_IMPL_L(sinh)
FUNC_IMPL_L(sqrt)
FUNC_IMPL_L(tan)
FUNC_IMPL_L(tanh)

FUNC_IMPL2_L(atan2)
FUNC_IMPL2_L(fmod)
FUNC_IMPL2_L(pow)

FUNC_IMPL2_2(ldexp, long double, long double, int, l)
FUNC_IMPL2_2(frexp, long double, long double, int*, l)

FUNC_IMPL_L(cbrt)
FUNC_IMPL_L(exp2)
FUNC_IMPL_L(expm1)
FUNC_IMPL_L(fabs)
FUNC_IMPL_1(finite, int, long double, l)
FUNC_IMPL_1(ilogb, int, long double, l)
FUNC_IMPL_1(isinf, int, long double, l)
FUNC_IMPL_1(isnan, int, long double, l)
FUNC_IMPL_L(log1p)
FUNC_IMPL_L(log2)
FUNC_IMPL_L(logb)
FUNC_IMPL_1(llrint, long long int, long double, l)
FUNC_IMPL_1(lrint, long int, long double, l)
FUNC_IMPL_1(lround, long int, long double, l)
FUNC_IMPL_L(nearbyint)
FUNC_IMPL2_L(nextafter)
FUNC_IMPL2_L(remainder)
FUNC_IMPL_L(rint)
FUNC_IMPL_L(round)
FUNC_IMPL2_2(scalbn, long double, long double, int, l)
FUNC_IMPL_L(trunc)

long double fmal (long double x, long double y, long double z)
{ return (long double) fma (x, y, z); }

long double modfl (long double x, long double *iptr)
{
  double d, ret;

  ret = modf (x, &d);
  *iptr = d;

  return (long double) ret;
}
