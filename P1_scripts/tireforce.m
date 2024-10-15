% JH 4/17/08
% Tireforce returns the longitudinal and lateral forces acting on a tire.

function [Fx, Fy] = tireforce(Cx, Ca, Fz, mu_peak, mu_slide, alpha, k)

mu_ratio = mu_slide/mu_peak;
% calculate vector combined deformation
f = sqrt(Cx^2*(k/(1+k))^2 + Ca^2*(tan(alpha)/(1+k))^2);
if f <= 3*mu_peak*Fz
    % before full sliding
    F = f - 1/(3*mu_peak*Fz)*(2-mu_ratio)*f^2 + 1/(3*mu_peak*Fz)^2*(1-2/3*mu_ratio)*f^3;
else
    % after full sliding
    F = mu_slide*Fz;
end

% Split force into lateral and lognitudinal components:
if f == 0
    Fx = 0;
    Fy = 0;
else
    Fx = (Cx*(k/(1+k))/f)*F;
    Fy = -(Ca*(tan(alpha)/(1+k))/f)*F;
end
