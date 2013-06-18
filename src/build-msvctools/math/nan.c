#include <math.h>
#include <ymath.h>

static __inline double __fast_nan (const char* tagp)
{ return _Nan._Double; }

static __inline double __fast_nanf (const char* tagp)
{ return _FNan._Float; }

static __inline long double __fast_nanl (const char* tagp)
{ return _LNan._Long_double; }

double nan (const char* tagp) { return __fast_nan (tagp); }
float nanf (const char* tagp) { return __fast_nanf (tagp); }
long double nanl (const char* tagp) { return __fast_nanl (tagp); }
