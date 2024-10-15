function [Fy,Mz] = brush_model(alpha, Fz, mu, muRatio, Calpha, a)

% Check sizes


% Calculate intermediate variables
thetay = Calpha./(3*mu.*Fz);
sigmay = tan(alpha);

% Calculate the polynomial model values
Fy = -Calpha.*sigmay + Calpha.^2./(3*mu.*Fz).*(2-muRatio).*abs(sigmay).*sigmay - Calpha.^3./(9*(mu.*Fz).^2).*(1-2/3*muRatio).*sigmay.^3;
Mz = a.*sigmay.*Calpha/3.*(1 - Calpha.*abs(sigmay)./(mu.*Fz).*(2-muRatio) + (Calpha.*sigmay./(mu.*Fz)).^2.*(1-2/3*muRatio) - (Calpha.*abs(sigmay)./(mu.*Fz)).^3.*(4/27 - 1/9*muRatio));

% Check to see if the tire isn't saturated. If so, override the value
satInds = abs(alpha) > 3*mu.*Fz./(Calpha);
if length(mu) > 1
    Fy(satInds) = -sign(alpha(satInds)).*mu(satInds).*muRatio.*Fz(satInds);
else
    Fy(satInds) = -sign(alpha(satInds)).*mu.*muRatio.*Fz;
end
Mz(satInds) = 0;
