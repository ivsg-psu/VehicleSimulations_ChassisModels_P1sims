%Compute derivatives for longitudinal dynamics and linearize around (ebeta,
%er, eUx) = 0, delta = deltaEq
deltaEq = -12*pi/180;
UyEq = UxEq*tan(betaDes);
alphaEq = atan2(UyEq + a*rEq, UxEq) - deltaEq;
xEq = tan(alphaEq);

%Derivatives of vehicle states wrt error states (zero unless otherwise
%written)
DUyDebeta = UxEq/cos(betaDes)^2;
DUyDeUx = tan(betaDes);

DrDebeta = 0;
DrDer = 1;

DUxDeUx = 1;

%Derivatives of slip angle wrt vehicle states
DalphaDUy = (1/(1+((UyEq+a*rEq)/UxEq)^2))*(1/UxEq);
DalphaDr = (1/(1+((UyEq+a*rEq)/UxEq)^2))*(a/UxEq);
DalphaDUx = (1/(1+((UyEq+a*rEq)/UxEq)^2))*-((UyEq+a*rEq)/UxEq^2);

%Derivatives of x (as defined above) wrt to alpha
DxDalpha = 1/cos(alphaEq)^2;

%Derivative of front lateral force wrt to x
DFyfDx = -Cf - ((2*Cf^2)/(3*mu_s_assumed*Fzf))*xEq - (Cf^3/(9*mu_s_assumed^2*Fzf^2))*xEq^2;

%Derivative of front lateral force wrt to states
DFyfDUy = DFyfDx*DxDalpha*DalphaDUy;
DFyfDr = DFyfDx*DxDalpha*DalphaDr;
DFyfDUx = DFyfDx*DxDalpha*DalphaDUx;

%Derivatives of Uxdot with respect to vehicle states
Df3DUy = -(1/m)*DFyfDUy*sin(deltaEq) + rEq;
Df3Dr = -(1/m)*DFyfDr*sin(deltaEq) + UyEq;
Df3DUx = KUx_Drift/m - (1/m)*DFyfDUx*sin(deltaEq);

%Derivatives of Uxdot with respect to error states
Df3Debeta = Df3DUy*DUyDebeta + Df3Dr*DrDebeta
Df3Der = Df3Dr*DrDer
Df3DeUx = Df3DUy*DUyDeUx + Df3DUx*DUxDeUx



