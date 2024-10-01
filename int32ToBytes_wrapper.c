
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
void int32ToBytes_Outputs_wrapper(const int32_T *u0,
			uint8_T *y0,
			uint8_T *y1,
			uint8_T *y2,
			uint8_T *y3)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
// Create a temporary byte array
uint8_T temp[4];
// This code just copies the bits of the int32 input into the four bytes of the temporary
// uint8 vector without any casting, shifting, etc.
memcpy(temp,u0,sizeof(int32_T));
// Once the memory has been copied into the temp vector, they can be segmented to the output
// without any additional casting, shifting, etc.
y0[0] = temp[0];
y1[0] = temp[1];
y2[0] = temp[2];
y3[0] = temp[3];
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


