% Plotting code for data with new VS330 GPS and Michigan Scientific Wheel
% Force Transducers

clear all
close all

% Load in a file if it's not already loaded
if(~exist('fname','var'))
    [fname, pathname] = uigetfile('*.mat','Choose data file to open');
    load([pathname fname])
    loadP1data
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Data plotting section
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Plot the vehicle states
if ~exist('fHand1','var') 
    fHand1 = figure('Name','Vehicle States','NumberTitle','off');
else
    figure(fHand1) 
end
plot(t,[beta r Vx]);
linkHands(1) = gca;
xlabel('Time (s)')
ylim([-10 20])
title('Vehicle States (not Kalman Filtered)')
legend('Sideslip Angle (deg)','Yaw Rate (rad/s)','Longitudinal Velocity (m/s)')

% CEB: this does not seem to work with the KF data (coordinate system issue?)
% figure('Name','Vehicle Position','NumberTitle','off')
% %idx = find(GPS(:,15) == 4);
% plot(SSest(:,16),SSest(:,17))
% axis equal;
% xlabel('East (m)')
% ylabel('North (m)')
% %overheadPlot() % CEB: swap this in later

if ~exist('fHand2','var') 
    fHand2 = figure('Name','Accelerations','NumberTitle','off');
else
    figure(fHand2) 
end
plot(t,SSest(:,[11 14])/9.81);
linkHands(2) = gca;
xlabel('Time (s)')
ylabel('Acceleration (g)')
legend('CG ax','CG ay')


if ~exist('fHand3','var') 
    fHand3 = figure('Name','Fy/Fz Forces','NumberTitle','off');
else
    figure(fHand3) 
end
hold off;
hl(3) = plot(t,Fz_LF,'color',[0.6784 0.7373 1]);
hold on;
hl(4) = plot(t,Fz_RF,'color',[0.7294 0.9373 0.6]);
plot(t,-Fz_LF,'color',[0.6784 0.7373 1]);
plot(t,-Fz_RF,'color',[0.7294 0.9373 0.6]);
hl(1) = plot(t,Fy_LF,'color',[0 0 0.8]);
hl(2) = plot(t,Fy_RF,'color',[0 0.4 0]);
%hl(3) = plot(t,Mz_LF,'r');
%hl(4) = plot(t,Mz_RF,'c');
linkHands(3) = gca;
xlabel('Time (s)')
ylabel('Forces/Moments (N/Nm)')
legend(hl,'Fy LF','Fy RF','Fz LF','Fz RF')
%legend(hl,'Fy LF','Fy RF','Mz LF','Mz RF','Fz LF','Fz RF')

if ~exist('fHand4','var') 
    fHand4 = figure('Name','Mz Moments','NumberTitle','off');
else
    figure(fHand4) 
end
hold off
plot(t,Mz_LF,'color',[0 0 0.8]);
hold on
plot(t,Mz_RF,'color',[0 0.4 0]);
xlabel('Time (s)')
ylabel('Moments (Nm)')
legend('Mz LF','Mz RF')

if ~exist('fHand5','var') 
    fHand5 = figure('Name','Trail Calculations','NumberTitle','off');
else
    figure(fHand5) 
end
%%%%%%%%%%%%%%%%%%%% DETERMINED FROM PLOTS %%%%%%%%%%%%%%%%%%%%%%%%%%%
%tml = 0;%.058;        % (m) mechanical trail of left wheel
%tmr = 0;%.073;        % (m) mechanical trail of right wheel
offset_Fy_LF = 0; offset_Fy_RF = 0;
offset_Mz_LF = 0; offset_Mz_RF = 0;
plot(t,[(-(Mz_LF - offset_Mz_LF)./(Fy_LF - offset_Fy_LF)).*(abs(Fy_LF) > 100) (-(Mz_RF - offset_Mz_RF)./(Fy_RF - offset_Fy_RF)).*(abs(Fy_RF) > 100)]);
linkHands(4) = gca;
xlabel('Time (s)')
ylabel('Pneumatic Trail (m)')
legend('LF','RF')

if ~exist('fHand6','var') 
    fHand6 = figure('Name','Longitudinal Force/Rolling Moment','NumberTitle','off');
else
    figure(fHand6) 
end
plot(t,[Fx_LF Fx_RF My_LF My_RF]);
linkHands(5) = gca;
xlabel('Time (s)')
ylabel('Forces/Moments (N/Nm) - (+) indicates braking force')
legend('Fx LF','Fx RF','My LF','My RF')

if ~exist('fHand7','var') 
    fHand7 = figure('Name','Slip/Steering Angles','NumberTitle','off');
else
    figure(fHand7) 
end
plot(t,180/pi*[alphafl alphafr delta_LF delta_RF]);
linkHands(6) = gca;
ylim([max(-45,min([alphafl; alphafr; delta_LF; delta_RF])*180/pi) min(45,max([alphafl; alphafr; delta_LF; delta_RF])*180/pi)])
xlabel('Time (s)')
ylabel('Slip Angle (deg)')
legend('\alpha_{FL}','\alpha_{FR}','\delta_{FL}','\delta_{FR}')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   Model matching section
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Calculate a brush tire model
brush_tire_params; % load the brush tire parameters
alphaModel = (-25:0.5:25)'*pi/180;
FzModel = linspace(1600,6200,25);
[alphaModel,FzModel] = meshgrid(alphaModel,FzModel);
Calpha = brush.CaVal*sin(brush.CaSinVal*atan(brush.CaTanVal*FzModel*brush.CaSlope));   % from Chris' notes (see adaption from Pacejka using variable a with c_{px} instead of C_\alpha)
mup = brush.muVal - brush.muSlope*FzModel;                    % from Chris' notes
mus = brush.muVal*brush.muRatio - brush.muSlope*FzModel;                  % from Chris' notes
thetay = Calpha./(3*mup.*FzModel);
sigmay = tan(alphaModel);
asq = brush.aVal*(FzModel*brush.aSlope).^(brush.aExp); % half contact patch length
FyModel = -Calpha.*sigmay + Calpha.^2./(3*mup.*FzModel).*(2-mus./mup).*abs(sigmay).*sigmay - Calpha.^3./(9*(mup.*FzModel).^2).*(1-2/3*mus./mup).*sigmay.^3;
MzModel = asq.*sigmay.*Calpha/3.*(1 - Calpha.*abs(sigmay)./(mup.*FzModel).*(2-mus./mup) + (Calpha.*sigmay./(mup.*FzModel)).^2.*(1-2/3*mus./mup) - (Calpha.*abs(sigmay)./(mup.*FzModel)).^3.*(4/27 - 1/9*mus./mup));
satInds = abs(alphaModel) > 3*mup.*FzModel./(Calpha);
FyModel(satInds) = -sign(alphaModel(satInds)).*mus(satInds).*FzModel(satInds);
MzModel(satInds) = 0;


% Subset the data before making the surface plots
tInds = t > 0; % & t < 450;
dirInds = logical(tInds .* GPS(:,10)>0.5);

if ~exist('fHand8','var') 
    fHand8 = figure('Name','Tire Force Curves','NumberTitle','off');
else
    figure(fHand8) 
end
hold off
plot3(alphafl(dirInds,1)*180/pi,Fz_LF(dirInds),Fy_LF(dirInds)-offset_Fy_LF,'b.');
set(gca,'FontName', 'Times New Roman','fontsize',14)
hold on
dirInds = logical(tInds .* GPS(:,10)>0.5);
plot3(alphafr(dirInds,1)*180/pi,Fz_RF(dirInds),Fy_RF(dirInds)-offset_Fy_RF,'.','color',[0 0.5 0]);
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Lateral Force (N)')
xlim([-25 25])
%ylim([1300 6200])
hold on;
hsurf = surf(alphaModel*180/pi,FzModel,FyModel,1.8*ones(size(FyModel)),'facecolor',[1 0.8 0.8],'edgealpha',1);
%set(hsurf,'cdata',1.8*ones(size(FyModel)));
view([6 -8])
hDummyL = plot(NaN,NaN,'.');
set(hDummyL,'markersize',16,'color','b'); 
hDummyR = plot(NaN,NaN,'.');
set(hDummyR,'markersize',16,'color',[0 0.5 0]); 
legend([hDummyL hDummyR hsurf],'Left','Right','Model Fit','location','best')
 
if ~exist('fHand9','var') 
    fHand9 = figure('Name','Tire Moment Curves','NumberTitle','off');
else
    figure(fHand9) 
end
dirInds = logical(tInds .* SSest(:,9) > 0.5);
hold off
plot3(alphafl(dirInds)*180/pi,Fz_LF(dirInds),Mz_LF(dirInds)-offset_Mz_LF,'b.');
set(gca,'FontName', 'Times New Roman','fontsize',14)
hold on
plot3(alphafr(dirInds)*180/pi,Fz_RF(dirInds),Mz_RF(dirInds)-offset_Mz_RF,'.','color',[0 0.5 0]);
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Steering Moment (Nm)')
xlim([-25 25])
%ylim([1300 6200])
zlim([-300 300])
hold on;
hsurf = surf(alphaModel*180/pi,FzModel,MzModel,1.8*ones(size(MzModel)),'facecolor',[1 0.8 0.8],'edgealpha',1);
%set(hsurf,'cdata',1.8*ones(size(MzModel)));
view([6 -8])
hDummyL = plot(NaN,NaN,'.');
set(hDummyL,'markersize',16,'color','b'); 
hDummyR = plot(NaN,NaN,'.');
set(hDummyR,'markersize',16,'color',[0 0.5 0]); 
legend([hDummyL hDummyR hsurf],'Left','Right','Model Fit','location','best')

if ~exist('fHand10','var') 
    fHand10 = figure('Name','Trail Curves','NumberTitle','off');
else
    figure(fHand10) 
end
hold off
plot3(alphafl(dirInds)*180/pi,Fz_LF(dirInds),-(Mz_LF(dirInds) - offset_Mz_LF)./(Fy_LF(dirInds)-offset_Fy_LF),'b.')
set(gca,'FontName', 'Times New Roman','fontsize',14)
hold on
plot3(alphafr(dirInds)*180/pi,Fz_RF(dirInds),-(Mz_RF(dirInds) - offset_Mz_RF)./(Fy_RF(dirInds)-offset_Fy_RF),'.','color',[0 0.5 0])
hsurf = surf(alphaModel*180/pi,FzModel,-MzModel./FyModel,1.8*ones(size(MzModel)),'facecolor',[1 0.8 0.8],'edgealpha',0.5);
xlabel('Slip Angle (deg)')
ylabel('Vertical Load (N)')
zlabel('Pneumatic Trail (m)')
xlim([-15 15])
%ylim([1600 6200])
zlim([-0.05 0.15]);
view([-6 1])
hDummyL = plot(NaN,NaN,'.');
set(hDummyL,'markersize',16,'color','b'); 
hDummyR = plot(NaN,NaN,'.');
set(hDummyR,'markersize',16,'color',[0 0.5 0]); 
legend([hDummyL hDummyR hsurf],'Left','Right','Model Fit','location','best')

% plot the time-based model fit
Calpha_LF = brush.lf.CaVal*sin(brush.lf.CaSinVal*atan(brush.lf.CaTanVal*Fz_LF*brush.lf.CaSlope));   % from Chris' notes (see adaption from Pacejka using variable a with c_{px} instead of C_\alpha)
mup_LF = brush.lf.muVal - brush.lf.muSlope*Fz_LF;                    % from Chris' notes
mus_LF = brush.lf.muVal*brush.lf.muRatio - brush.lf.muSlope*Fz_LF;                  % from Chris' notes
thetay_LF = Calpha_LF./(3*mup_LF.*Fz_LF);
sigmay_LF = tan(alphafl);
asq_LF = brush.lf.aVal + (Fz_LF*brush.lf.aSlope).^(brush.lf.aExp); % half contact patch length
FyFit_LF = -Calpha_LF.*sigmay_LF + Calpha_LF.^2./(3*mup_LF.*Fz_LF).*(2-mus_LF./mup_LF).*abs(sigmay_LF).*sigmay_LF - Calpha_LF.^3./(9*(mup_LF.*Fz_LF).^2).*(1-2/3*mus_LF./mup_LF).*sigmay_LF.^3;
MzFit_LF = asq_LF.*sigmay_LF.*Calpha_LF/3.*(1 - Calpha_LF.*abs(sigmay_LF)./(mup_LF.*Fz_LF).*(2-mus_LF./mup_LF) + (Calpha_LF.*sigmay_LF./(mup_LF.*Fz_LF)).^2.*(1-2/3*mus_LF./mup_LF) - (Calpha_LF.*abs(sigmay_LF)./(mup_LF.*Fz_LF)).^3.*(4/27 - 1/9*mus_LF./mup_LF));
satInds = abs(alphafl) > 3*mup_LF.*Fz_LF./(Calpha_LF);
FyFit_LF(satInds) = -sign(alphafl(satInds)).*mus_LF(satInds).*Fz_LF(satInds);
MzFit_LF(satInds) = 0;
Calpha_RF = brush.rf.CaVal*sin(brush.rf.CaSinVal*atan(brush.rf.CaTanVal*Fz_RF*brush.rf.CaSlope));   % from Chris' notes (see adaption from Pacejka using variable a with c_{px} instead of C_\alpha)
mup_RF = brush.rf.muVal - brush.rf.muSlope*Fz_RF;                    % from Chris' notes
mus_RF = brush.rf.muVal*brush.rf.muRatio - brush.rf.muSlope*Fz_RF;                  % from Chris' notes
thetay_RF = Calpha_RF./(3*mup_RF.*Fz_RF);
sigmay_RF = tan(alphafr);
asq_RF = brush.rf.aVal + (Fz_RF*brush.rf.aSlope).^(brush.rf.aExp); % half contact patch length
FyFit_RF = -Calpha_RF.*sigmay_RF + Calpha_RF.^2./(3*mup_RF.*Fz_RF).*(2-mus_RF./mup_RF).*abs(sigmay_RF).*sigmay_RF - Calpha_RF.^3./(9*(mup_RF.*Fz_RF).^2).*(1-2/3*mus_RF./mup_RF).*sigmay_RF.^3;
MzFit_RF = asq_RF.*sigmay_RF.*Calpha_RF/3.*(1 - Calpha_RF.*abs(sigmay_RF)./(mup_RF.*Fz_RF).*(2-mus_RF./mup_RF) + (Calpha_RF.*sigmay_RF./(mup_RF.*Fz_RF)).^2.*(1-2/3*mus_RF./mup_RF) - (Calpha_RF.*abs(sigmay_RF)./(mup_RF.*Fz_RF)).^3.*(4/27 - 1/9*mus_RF./mup_RF));
satInds = abs(alphafr) > 3*mup_RF.*Fz_RF./(Calpha_RF);
FyFit_RF(satInds) = -sign(alphafr(satInds)).*mus_RF(satInds).*Fz_RF(satInds);
MzFit_RF(satInds) = 0;


if ~exist('fHand11','var') 
    fHand11 = figure('Name','Force Fit','NumberTitle','off');
else
    figure(fHand11) 
end
subplot(211)
cla reset
plot(t,Fy_LF)
%shadedTimeSeries(t,Fy_LF,Switches(:,1))
hold on
plot(t,FyFit_LF)
axis tight
legend('Data','Fit')
subplot(212)
cla reset
plot(t,Fy_RF)
%shadedTimeSeries(t,Fy_RF,Switches(:,1))
hold on
plot(t,FyFit_RF)
axis tight
ylabel('Lateral Force')
xlabel('Time (s)')

if ~exist('fHand12','var') 
    fHand12 = figure('Name','Moment Fit','NumberTitle','off');
else
    figure(fHand12) 
end
subplot(211)
cla reset
plot(t,Mz_LF)
%shadedTimeSeries(t,Mz_LF,Switches(:,1))
hold on
plot(t,MzFit_LF)
axis tight
legend('Data','Fit')
subplot(212)
cla reset
plot(t,Mz_RF)
%shadedTimeSeries(t,Mz_RF,Switches(:,1))
hold on
plot(t,MzFit_RF)
axis tight
ylabel('Aligning Moment')
xlabel('Time (s)')


% Link the x-axes of each of the time-based plots
linkaxes(linkHands,'x')