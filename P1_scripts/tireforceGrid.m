function Ftire = tireforceGrid(C_alpha, Fz, mu, mu_s, alpha, Fx)
%Compute derating factor
eta = sqrt(mu_s^2*Fz^2 - Fx.^2)./(mu_s*Fz);

%Compute tire force using sideslip angle and input parameters
alpha_sl = atan2(3*eta*mu*Fz,C_alpha);
Ftire = (-C_alpha*tan(alpha) + (C_alpha^2./(3*eta*mu*Fz))*(2-mu_s/mu).*tan(alpha).*abs(tan(alpha)) - ...
    (C_alpha^3./(9*eta.^2*mu^2*Fz^2)).*(tan(alpha)).^3*(1-2*mu_s/(3*mu))).*(abs(alpha) < alpha_sl)...
    + (-eta*mu_s*Fz.*sign(alpha)).*(abs(alpha) >= alpha_sl);
