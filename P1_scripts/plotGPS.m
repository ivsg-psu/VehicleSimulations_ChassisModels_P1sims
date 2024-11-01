% GPS plots only

% This addresses the GPS data figure, if it exists. If not, it
% creates a new one.
if ~exist('handleGPSDataFig','var') || 0 == isvalid(handleGPSDataFig)
    handleGPSDataFig = figure('Name','GPS Data','NumberTitle','off','WindowStyle','docked');
    %handleGPSDataFig.Position(3) = 560;  % Cannot be used when docked
    %handleGPSDataFig.Position(4) = 720;  % Cannot be used when docked
else
    figure(handleGPSDataFig);
end

% If
if(~exist('noDiffInds'))
    noDiffInds = [];
    diffInds = 1:length(rt_tout);
end

subplot(5,3,1)
ax = gca;
cla
plot(rt_tout(noDiffInds),GPS.Mode(noDiffInds),'--','linewidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(rt_tout(diffInds),GPS.Mode(diffInds),'-','linewidth',2)
ylim([-0.3 4.3])
grid on
set(ax,'ytick',[0 1 2 3 4 5 6],'yticklabel',{'No Fix','2D no diff',...
    '3D no diff','2D with diff','3D with diff','RTK float','RTK int fixed'})
title('Receiver Mode')

subplot(5,3,2)
ax = gca;
cla
plot(rt_tout(noDiffInds),GPS.AttStat(noDiffInds,:),'--','linewidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(rt_tout(diffInds),GPS.AttStat(diffInds,:),'-','linewidth',2)
grid on
ylim([-0.3 3.3])
set(ax,'ytick',[0 1 2 3],'yticklabel',{'Invalid','GNSS','Inertial','Magnetic'})
title('Attitude Status')
legend('Yaw','Pitch','Roll','location','best')

subplot(5,3,3)
ax = gca;
cla
plot(rt_tout(noDiffInds),GPS.Sats(noDiffInds),'--','linewidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(rt_tout(diffInds),GPS.Sats(diffInds),'-','linewidth',2)
grid on
title('Sats Used')

subplot(5,1,2)
ax = gca;
cla
plot(rt_tout(noDiffInds),[GPS.HorSpd(noDiffInds) GPS.VrtSpd(noDiffInds)],'--','linewidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(rt_tout(diffInds),[GPS.HorSpd(diffInds) GPS.VrtSpd(diffInds)],'-','linewidth',2)
ylabel('Speed (m/s)')
legend('Horizontal','Vertical')
grid on

subplot(5,1,3)
ax = gca;
cla
plot(rt_tout(noDiffInds),[GPS.CoG(noDiffInds) GPS.Hdg(noDiffInds)],'--','linewidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(rt_tout(diffInds),[GPS.CoG(diffInds) GPS.Hdg(diffInds)],'-','linewidth',2)
ylabel('Angle (deg)')
title('Heading')
legend('CoG','Heading')
grid on

subplot(5,1,4)
ax = gca;
cla
plot(rt_tout(noDiffInds),GPS.CoG(noDiffInds)-GPS.Hdg(noDiffInds),'--','linewidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(rt_tout(diffInds),GPS.CoG(diffInds)-GPS.Hdg(diffInds),'-','linewidth',2)
ylabel('Angle (deg)')
ylim([-12 12])
title('Sideslip Angle')
grid on

subplot(5,1,5)
ax = gca;
cla
plot(rt_tout(noDiffInds),GPS.Roll(noDiffInds),'--','linewidth',2)
hold on
set(gca,'ColorOrderIndex',1)
plot(rt_tout(diffInds),GPS.Roll(diffInds),'-','linewidth',2)
ylabel('Angle (deg)')
title('Roll Angle')
grid on

% This addresses the GPS Lat-Long figure, if it exists. If not, it
% creates a new one.
if ~exist('handleGPSLatLongFig','var') || 0 == isvalid(handleGPSLatLongFig)
    handleGPSLatLongFig = figure('Name','Vehicle Lat-Long Plot','NumberTitle','off','WindowStyle','docked');
else
    figure(handleGPSLatLongFig);
end
clf
cla
geoplot(GPS.Lat(allGNSSInds),GPS.Long(allGNSSInds),'-','linewidth',6,'color',[0.8 0.8 0.8])
hold on
geoplot(GPS.Lat(noDiffInds),GPS.Long(noDiffInds),'--','linewidth',2,'color',[0.8 0.3 0.6])
geoplot(GPS.Lat(diffInds),GPS.Long(diffInds),'-','linewidth',2,'color',[0.8 0.3 0.6])
geobasemap satellite
grid on
title('Location')
