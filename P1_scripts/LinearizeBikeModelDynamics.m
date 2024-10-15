alphafEq = atan2(UyEq + a*rEq, UxEq) - deltaEq;
alphasl_f = atan2(3*mu*Fzf, Cf);
if (abs(alphafEq) <= alphasl_f)
    saturated_f = 0;
else
    saturated_f = 1;
end

alpharEq = atan2(UyEq - b*rEq, UxEq);
etaEq = sqrt((mu*Fzr)^2-FxrEq^2)/(mu*Fzr);
alphasl_r = atan2(3*etaEq*mu*Fzr,Cr);
if (abs(alpharEq) <= alphasl_r)
    saturated_r = 0;
else
    saturated_r = 1;
end
xfEq = tan(alphafEq);
xrEq = tan(alpharEq);

%Derivatives of front slip angle wrt vehicle states
DalphafDUy = (1/(1+((UyEq+a*rEq)/UxEq)^2))*(1/UxEq);
DalphafDr = (1/(1+((UyEq+a*rEq)/UxEq)^2))*(a/UxEq);
DalphafDUx = (1/(1+((UyEq+a*rEq)/UxEq)^2))*-((UyEq+a*rEq)/UxEq^2);

%Derivative of front slip angle wrt inputs
DalphafDdelta = -1;

%Derivatives of rear slip angle wrt vehicle states
DalpharDUy = (1/(1+((UyEq-b*rEq)/UxEq)^2))*(1/UxEq);
DalpharDr = (1/(1+((UyEq-b*rEq)/UxEq)^2))*-(b/UxEq);
DalpharDUx = (1/(1+((UyEq-b*rEq)/UxEq)^2))*-((UyEq-b*rEq)/UxEq^2);

%Derivatives of xf (as defined above) wrt to front slip angle
DxfDalphaf = 1/cos(alphafEq)^2;

%Derivatives of xr (as defined above) wrt to rear slip angle
DxrDalphar = 1/cos(alpharEq)^2;

%Derivative of eta wrt rear longitudinal force
DetaDFxr = -1*FxrEq/(mu*Fzr*sqrt((mu*Fzr)^2-FxrEq^2));

%Derivative of front lateral force wrt to xf
if (saturated_f == 0)
    DFyfDxf = -Cf - ((2*Cf^2)/(3*mu*Fzf))*xfEq - (Cf^3/(9*mu^2*Fzf^2))*xfEq^2;
else
    DFyfDxf = 0;
end

if (saturated_r == 0)
    %Derivative of rear lateral force wrt to xr
    DFyrDxr = -Cr - ((2*Cr^2)/(3*etaEq*mu*Fzr))*xrEq - (Cr^3/(9*etaEq^2*mu^2*Fzr^2))*xrEq^2;
    %Derivative of rear lateral force wrt to eta
    DFyrDeta = Cr^2*xrEq^2/(3*etaEq^2*mu*Fzr) + 2*Cr^3*xrEq^3/(27*etaEq^3*mu^2*Fzr^2);
else
    DFyrDxr = 0;
    DFyrDeta = mu*Fzr;
end
 
%Derivative of front lateral force wrt to states
DFyfDUy = DFyfDxf*DxfDalphaf*DalphafDUy;
DFyfDr = DFyfDxf*DxfDalphaf*DalphafDr;
DFyfDUx = DFyfDxf*DxfDalphaf*DalphafDUx;

%Derivative of front lateral force wrt to inputs
DFyfDdelta = DFyfDxf*DxfDalphaf*DalphafDdelta;

%Derivative of rear lateral force wrt to states
DFyrDUy = DFyrDxr*DxrDalphar*DalpharDUy;
DFyrDr = DFyrDxr*DxrDalphar*DalpharDr;
DFyrDUx = DFyrDxr*DxrDalphar*DalpharDUx;

%Derivative of rear lateral force wrt to inputs
DFyrDFxr = DFyrDeta*DetaDFxr;

%Derivatives of Uydot with respect to vehicle states
Df1DUy = (1/m)*(DFyfDUy*cos(deltaEq) + DFyrDUy);
Df1Dr = (1/m)*(DFyfDr*cos(deltaEq) + DFyrDr) - UxEq;
Df1DUx = (1/m)*(DFyfDUx*cos(deltaEq) + DFyrDUx) - rEq;

%Derivatives of Uydot with respect to inputs
Df1Ddelta = (1/m)*(-FyfEq*sin(deltaEq) + DFyfDdelta*cos(deltaEq));
Df1DFxr = (1/m)*DFyrDFxr;

%Derivatives of rdot with respect to vehicle states
Df2DUy = (1/Iz)*(a*DFyfDUy*cos(deltaEq) - b*DFyrDUy);
Df2Dr = (1/Iz)*(a*DFyfDr*cos(deltaEq) - b*DFyrDr);
Df2DUx = (1/Iz)*(a*DFyfDUx*cos(deltaEq) - b*DFyrDUx);

%Derivatives of rdot with respect to inputs
Df2Ddelta = (a/Iz)*(-FyfEq*sin(deltaEq) + DFyfDdelta*cos(deltaEq));
Df2DFxr = -(b/Iz)*DFyrDFxr;

%Derivatives of Uxdot with respect to vehicle states
Df3DUy = -(1/m)*DFyfDUy*sin(deltaEq) + rEq;
Df3Dr = -(1/m)*DFyfDr*sin(deltaEq) + UyEq;
Df3DUx = -(1/m)*DFyfDUx*sin(deltaEq);

%Derivatives of Uxdot with respect to inputs
Df3Ddelta = (1/m)*(-FyfEq*cos(deltaEq) - DFyfDdelta*sin(deltaEq));
Df3DFxr = 1/m;

Alin = [Df1DUy Df1Dr Df1DUx; Df2DUy Df2Dr Df2DUx; Df3DUy Df3Dr Df3DUx];
Blin = [Df1Ddelta Df1DFxr; Df2Ddelta Df2DFxr; Df3Ddelta Df3DFxr];




