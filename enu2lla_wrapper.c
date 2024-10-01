
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
#define u_width 1
#define u_1_width 1
#define u_2_width 1
#define u_3_width 1
#define u_4_width 1
#define u_5_width 1
#define y_width 1
#define y_1_width 1
#define y_2_width 1

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
void enu2lla_Outputs_wrapper(const real_T *u0,
			const real_T *u1,
			const real_T *u2,
			const real_T *u3,
			const real_T *u4,
			const real_T *u5,
			real_T *y0,
			real_T *y1,
			real_T *y2)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
real_T latRef, longRef, heightRef, EVal, NVal, UVal;
    /* Define some intermediate variables */
    real_T N_phi, X, Y, Z, N_phi_ref, Xref, Yref, Zref; // for ECEF coordinates
    real_T esq, p, F, G, c, s, kappa, P, Q, ro, U, V, zo, h, phi, lambda; // for ECEF to LLA coordinates
    /* Define major and minor radii of the Earth from WGS84 ellipsoid model */
    const real_T a = 6378137.0;
    const real_T b = 6356752.314245;
    /* Bring in position inputs and assign to short named variables */
    latRef = u0[0]*M_PI/180;
    longRef = u1[0]*M_PI/180;
    heightRef = u2[0];
    EVal = u3[0];
    NVal = u4[0];
    UVal = u5[0];

    N_phi_ref = a*a/sqrt(a*a*cos(latRef)*cos(latRef) + b*b*sin(latRef)*sin(latRef));
    Xref = (N_phi_ref + heightRef)*cos(latRef)*cos(longRef);
    Yref = (N_phi_ref + heightRef)*cos(latRef)*sin(longRef);
    Zref = ((b*b/a/a)*N_phi_ref + heightRef)*sin(latRef);

    X = Xref - sin(longRef)*EVal - sin(latRef)*cos(longRef)*NVal + cos(latRef)*cos(longRef)*UVal;
    Y = Yref + cos(longRef)*EVal - sin(latRef)*sin(longRef)*NVal + cos(latRef)*sin(longRef)*UVal;
    Z = Zref + cos(latRef)*NVal + sin(latRef)*UVal;

    esq = (a*a - b*b)/(a*a);
    p = sqrt(X*X + Y*Y);
    F = 54.0*b*b*Z*Z;
    G = p*p + (1 - esq)*Z*Z - esq*(a*a - b*b);
    c = esq*esq*F*p*p/G/G/G;
    s = cbrt(1 + c + sqrt(c*c + 2*c));
    kappa = s + 1 + 1/s;
    P = F/(3*kappa*kappa*G*G);
    Q = sqrt(1 + 2*P*esq*esq);
    ro = -P*esq*p/(1+Q) + sqrt(a*a/2*(1+(1/Q)) - P*(1-esq)*Z*Z/Q/(1+Q) - P*p*p/2);
    U = sqrt((p-(esq*ro))*(p-(esq*ro)) + Z*Z);
    V = sqrt((p-(esq*ro))*(p-(esq*ro)) + (1 - esq)*Z*Z);
    zo = b*b*Z/a/V;
    h = U*(1 - (b*b)/(a*V)); // altitude
    phi = atan((Z+zo*(a*a - b*b)/b/b)/p); // latitude
    lambda = atan2(Y,X); // longitude

    y0[0] = phi*180/M_PI;
    y1[0] = lambda*180/M_PI;
    y2[0] = h;
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


