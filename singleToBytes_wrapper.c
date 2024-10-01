
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
#include <string.h>
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 1
#define y_width 1
#define y_1_width 1
#define y_2_width 1
#define y_3_width 1

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
void singleToBytes_Outputs_wrapper(const real32_T *u0,
			uint8_T *y0,
			uint8_T *y1,
			uint8_T *y2,
			uint8_T *y3)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
// Create a temporary byte array
uint8_T temp[2];
// This code just copies the bits of the int16 input into the two bytes of the output
// uint8 vector without any casting, shifting, etc.
memcpy(temp,u0,sizeof(real32_T));
y0[0] = temp[0];
y1[0] = temp[1];
y2[0] = temp[2];
y3[0] = temp[3];
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


