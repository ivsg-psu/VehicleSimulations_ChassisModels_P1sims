
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#define SIMPLIFIED_RTWTYPES_COMPATIBILITY
#include "rtwtypes.h"
#undef SIMPLIFIED_RTWTYPES_COMPATIBILITY
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include <math.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 8
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
/* extern double func(double a); */
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output function
 *
 */
void bits2byte_Outputs_wrapper(const uint8_T *u0,
			uint8_T *y0)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
y0[0] = 0;
y0[0] += (0 == u0[0]) ? 0 : 1;
y0[0] += (0 == u0[1]) ? 0 : 2;
y0[0] += (0 == u0[2]) ? 0 : 4;
y0[0] += (0 == u0[3]) ? 0 : 8;
y0[0] += (0 == u0[4]) ? 0 : 16;
y0[0] += (0 == u0[5]) ? 0 : 32;
y0[0] += (0 == u0[6]) ? 0 : 64;    
y0[0] += (0 == u0[7]) ? 0 : 128;
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


