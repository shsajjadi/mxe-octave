/* Emulation of stdbool.h for Visual C++. */

#ifndef __stdbool_h__
#define __stdbool_h__ 1

#ifndef __cplusplus

#define __bool_true_false_are_defined 1

#define false 0
#define true 1

#define bool _Bool
typedef unsigned char _Bool;

#endif /* __cplusplus */

#endif /* __stdbool_h__ */
