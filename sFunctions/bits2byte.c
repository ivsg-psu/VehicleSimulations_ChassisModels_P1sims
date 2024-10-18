/*
 * File: bits2byte.c
 *
 *
 *  -------------------------------------------------------------------------
 * | See matlabroot/simulink/src/sfuntmpl_doc.c for a more detailed template |
 *  -------------------------------------------------------------------------
 *
 * Created: Fri Oct 18 11:35:11 2024
 */

#define S_FUNCTION_LEVEL               2
#define S_FUNCTION_NAME                bits2byte

/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
/* %%%-SFUNWIZ_defines_Changes_BEGIN --- EDIT HERE TO _END */
#define NUM_INPUTS                     1

/* Input Port  0 */
#define IN_PORT_0_NAME                 u0
#define INPUT_0_DIMS_ND                {8,1}
#define INPUT_0_NUM_ELEMS              8
#define INPUT_0_WIDTH                  8
#define INPUT_DIMS_0_COL               1
#define INPUT_0_DTYPE                  uint8_T
#define INPUT_0_COMPLEX                COMPLEX_NO
#define INPUT_0_UNIT                   ""
#define IN_0_BUS_BASED                 0
#define IN_0_BUS_NAME
#define IN_0_DIMS                      2-D
#define INPUT_0_FEEDTHROUGH            1
#define IN_0_ISSIGNED                  0
#define IN_0_WORDLENGTH                8
#define IN_0_FIXPOINTSCALING           1
#define IN_0_FRACTIONLENGTH            9
#define IN_0_BIAS                      0
#define IN_0_SLOPE                     0.125
#define NUM_OUTPUTS                    1

/* Output Port  0 */
#define OUT_PORT_0_NAME                y0
#define OUTPUT_0_DIMS_ND               {1,1}
#define OUTPUT_0_NUM_ELEMS             1
#define OUTPUT_0_WIDTH                 1
#define OUTPUT_DIMS_0_COL              1
#define OUTPUT_0_DTYPE                 uint8_T
#define OUTPUT_0_COMPLEX               COMPLEX_NO
#define OUTPUT_0_UNIT                  ""
#define OUT_0_BUS_BASED                0
#define OUT_0_BUS_NAME
#define OUT_0_DIMS                     1-D
#define OUT_0_ISSIGNED                 1
#define OUT_0_WORDLENGTH               8
#define OUT_0_FIXPOINTSCALING          1
#define OUT_0_FRACTIONLENGTH           3
#define OUT_0_BIAS                     0
#define OUT_0_SLOPE                    0.125
#define NPARAMS                        0
#define SAMPLE_TIME_0                  INHERITED_SAMPLE_TIME
#define NUM_DISC_STATES                0
#define DISC_STATES_IC                 [0]
#define NUM_CONT_STATES                0
#define CONT_STATES_IC                 [0]
#define SFUNWIZ_GENERATE_TLC           0
#define SOURCEFILES                    "__SFB__"
#define PANELINDEX                     N/A
#define USE_SIMSTRUCT                  0
#define SHOW_COMPILE_STEPS             0
#define CREATE_DEBUG_MEXFILE           0
#define SAVE_CODE_ONLY                 0
#define SFUNWIZ_REVISION               3.0

/* %%%-SFUNWIZ_defines_Changes_END --- EDIT HERE TO _BEGIN */
/*<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<*/
#include "simstruc.h"

// extern void bits2byte_Outputs_wrapper(const uint8_T *u0,
//   uint8_T *y0);

/*====================*
 * S-function methods *
 *====================*/
/* Function: mdlInitializeSizes ===============================================
 * Abstract:
 *   Setup sizes of the various vectors.
 */
static void mdlInitializeSizes(SimStruct *S)
{
  DECL_AND_INIT_DIMSINFO(inputDimsInfo);
  ssSetNumSFcnParams(S, NPARAMS);
  if (ssGetNumSFcnParams(S) != ssGetSFcnParamsCount(S)) {
    return;                            /* Parameter mismatch will be reported by Simulink */
  }

  ssSetArrayLayoutForCodeGen(S, SS_COLUMN_MAJOR);
  ssSetOperatingPointCompliance(S, USE_DEFAULT_OPERATING_POINT);
  ssSetNumContStates(S, NUM_CONT_STATES);
  ssSetNumDiscStates(S, NUM_DISC_STATES);
  if (!ssSetNumInputPorts(S, NUM_INPUTS))
    return;

  /* Input Port 0 */
  ssAllowSignalsWithMoreThan2D(S);
  inputDimsInfo.numDims = 2;
  inputDimsInfo.width = INPUT_0_NUM_ELEMS;
  int_T in0Dims[] = INPUT_0_DIMS_ND;
  inputDimsInfo.dims = in0Dims;
  ssSetInputPortDimensionInfo(S, 0, &inputDimsInfo);
  ssSetInputPortDataType(S, 0, SS_UINT8);
  ssSetInputPortComplexSignal(S, 0, INPUT_0_COMPLEX);
  ssSetInputPortDirectFeedThrough(S, 0, INPUT_0_FEEDTHROUGH);
  ssSetInputPortRequiredContiguous(S, 0, 1);/*direct input signal access*/

  /*
   * Configure the Units for Input Ports
   */
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {

#if defined(MATLAB_MEX_FILE)

    UnitId inUnitIdReg;
    ssRegisterUnitFromExpr(S, INPUT_0_UNIT, &inUnitIdReg);
    if (inUnitIdReg != INVALID_UNIT_ID) {
      ssSetInputPortUnit(S, 0, inUnitIdReg);
    } else {
      ssSetLocalErrorStatus(S,
                            "Invalid Unit provided for input port u0 of S-Function bits2byte");
      return;
    }

#endif

  }

  if (!ssSetNumOutputPorts(S, NUM_OUTPUTS))
    return;

  /* Output Port 0 */
  ssSetOutputPortWidth(S, 0, OUTPUT_0_NUM_ELEMS);
  ssSetOutputPortDataType(S, 0, SS_UINT8);
  ssSetOutputPortComplexSignal(S, 0, OUTPUT_0_COMPLEX);

  /*
   * Configure the Units for Output Ports
   */
  if (ssGetSimMode(S) != SS_SIMMODE_SIZES_CALL_ONLY) {

#if defined(MATLAB_MEX_FILE)

    UnitId outUnitIdReg;
    ssRegisterUnitFromExpr(S, OUTPUT_0_UNIT, &outUnitIdReg);
    if (outUnitIdReg != INVALID_UNIT_ID) {
      ssSetOutputPortUnit(S, 0, outUnitIdReg);
    } else {
      ssSetLocalErrorStatus(S,
                            "Invalid Unit provided for output port y0 of S-Function bits2byte");
      return;
    }

#endif

  }

  ssSetNumPWork(S, 0);
  ssSetNumSampleTimes(S, 1);
  ssSetNumRWork(S, 0);
  ssSetNumIWork(S, 0);
  ssSetNumModes(S, 0);
  ssSetNumNonsampledZCs(S, 0);
  ssSetSimulinkVersionGeneratedIn(S, "24.1");

  /* Take care when specifying exception free code - see sfuntmpl_doc.c */
  ssSetRuntimeThreadSafetyCompliance(S, RUNTIME_THREAD_SAFETY_COMPLIANCE_FALSE);
  ssSetOptions(S, (SS_OPTION_EXCEPTION_FREE_CODE |
                   SS_OPTION_WORKS_WITH_CODE_REUSE));
}

#if defined(MATLAB_MEX_FILE)
#define MDL_SET_INPUT_PORT_DIMENSION_INFO

static void mdlSetInputPortDimensionInfo(SimStruct *S,
  int_T port,
  const DimsInfo_T *dimsInfo)
{
  if (!ssSetInputPortDimensionInfo(S, port, dimsInfo))
    return;
}

#endif

#define MDL_SET_OUTPUT_PORT_DIMENSION_INFO
#if defined(MDL_SET_OUTPUT_PORT_DIMENSION_INFO)

static void mdlSetOutputPortDimensionInfo(SimStruct *S,
  int_T port,
  const DimsInfo_T *dimsInfo)
{
  if (!ssSetOutputPortDimensionInfo(S, port, dimsInfo))
    return;
}

#endif

#define MDL_SET_DEFAULT_PORT_DIMENSION_INFO

static void mdlSetDefaultPortDimensionInfo(SimStruct *S)
{
  DECL_AND_INIT_DIMSINFO(portDimsInfo);
  int_T dims[2];

  /* Setting default dimensions for input port 0 */
  portDimsInfo.width = INPUT_0_NUM_ELEMS;
  dims[0] = INPUT_0_NUM_ELEMS;
  dims[1] = 1;
  portDimsInfo.dims = dims;
  portDimsInfo.numDims = 2;
  if (ssGetInputPortWidth(S, 0) == DYNAMICALLY_SIZED) {
    ssSetInputPortMatrixDimensions(S, 0, 1 , 1);
  }

  return;
}

/* Function: mdlInitializeSampleTimes =========================================
 * Abstract:
 *    Specifiy  the sample time.
 */
static void mdlInitializeSampleTimes(SimStruct *S)
{
  ssSetSampleTime(S, 0, SAMPLE_TIME_0);
  ssSetModelReferenceSampleTimeDefaultInheritance(S);
  ssSetOffsetTime(S, 0, 0.0);
}

#define MDL_SET_INPUT_PORT_DATA_TYPE

static void mdlSetInputPortDataType(SimStruct *S, int port, DTypeId dType)
{
  ssSetInputPortDataType(S, 0, dType);
}

#define MDL_SET_OUTPUT_PORT_DATA_TYPE

static void mdlSetOutputPortDataType(SimStruct *S, int port, DTypeId dType)
{
  ssSetOutputPortDataType(S, 0, dType);
}

#define MDL_SET_DEFAULT_PORT_DATA_TYPES

static void mdlSetDefaultPortDataTypes(SimStruct *S)
{
  ssSetInputPortDataType(S, 0, SS_DOUBLE);
  ssSetOutputPortDataType(S, 0, SS_DOUBLE);
}

#define MDL_START                                                /* Change to #undef to remove function */
#if defined(MDL_START)

/* Function: mdlStart =======================================================
 * Abstract:
 *    This function is called once at start of model execution. If you
 *    have states that should be initialized once, this is the place
 *    to do it.
 */
static void mdlStart(SimStruct *S)
{
}

#endif                                 /*  MDL_START */

/* Function: mdlOutputs =======================================================
 *
 */
static void mdlOutputs(SimStruct *S, int_T tid)
{
    const uint8_T *u0 = (uint8_T *) ssGetInputPortRealSignal(S, 0);
    uint8_T *y0 = (uint8_T *) ssGetOutputPortRealSignal(S, 0);
    y0[0] = 0;
    y0[0] += (0 == u0[0]) ? 0 : 1;
    y0[0] += (0 == u0[1]) ? 0 : 2;
    y0[0] += (0 == u0[2]) ? 0 : 4;
    y0[0] += (0 == u0[3]) ? 0 : 8;
    y0[0] += (0 == u0[4]) ? 0 : 16;
    y0[0] += (0 == u0[5]) ? 0 : 32;
    y0[0] += (0 == u0[6]) ? 0 : 64;
    y0[0] += (0 == u0[7]) ? 0 : 128;

}

/* Function: mdlTerminate =====================================================
 * Abstract:
 *    In this function, you should perform any actions that are necessary
 *    at the termination of a simulation.  For example, if memory was
 *    allocated in mdlStart, this is the place to free it.
 */
static void mdlTerminate(SimStruct *S)
{
}

#ifdef MATLAB_MEX_FILE                 /* Is this file being compiled as a MEX-file? */
#include "simulink.c"                  /* MEX-file interface mechanism */
#else
#include "cg_sfun.h"                   /* Code generation registration function */
#endif
