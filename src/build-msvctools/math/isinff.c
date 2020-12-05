#define __STDC__ 1

#include <math.h>
#include <float.h>

int isinff (float x)
{
  int c = (_fpclass (x) & (_FPCLASS_PINF | _FPCLASS_NINF));

  return (c == _FPCLASS_PINF ? 1
          : c == _FPCLASS_NINF ? -1 : 0);
}
