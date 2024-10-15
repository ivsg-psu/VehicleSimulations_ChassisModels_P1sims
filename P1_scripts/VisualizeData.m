% Script that plots an overhead view of the car trajectory for a given dataset
% Written by R. Hindiyeh, modified by JH
% close all; clc;

% Before you run this code, make sure your data set is loaded in the MATLAB workspace!

% Is GPS position data available? Options are 'yes', 'Sim', or 'no'.  :)
GPSPosAvail = 'no';
tstartplot = round(t(1));
tendplot = t(end);
Ncars = 12;
% Get vehicle CG position
if strcmp(GPSPosAvail,'yes')
    posE = SSest(T,16);
    posN = SSest(T,17);
elseif strcmp(GPSPosAvail,'Sim')
    % do nothing since posE and posN are already available in simulation
else
    % integrate vehicle velocities to get position
    posN = zeros(N,1);
    posE = zeros(N,1);
    for i = 1:N-1
        posN(i+1) = posN(i) + (Vx(i)*cos(psi(i)) - Vy(i)*sin(psi(i)))*ts;
        posE(i+1) = posE(i) - (Vy(i)*cos(psi(i)) + Vx(i)*sin(psi(i)))*ts;
    end
end

% Vehicle Parameters
a = 1.35;
b = 1.15;                   
t_f = 64*2.54/100;
t_r = t_f;
r_w = 0.5;

% Define time intervals for plotting the cars (this requires lots of hand tuning)
if strcmp(GPSPosAvail,'Sim')
    timevec = linspace(tstartplot,tendplot,Ncars);
else
%     timevec = [39.0000   39.5   40.1 40.7  41.4  42   42.5   43.0000   43.6667   44.3333   45.0000]; Ncars = length(timevec);
   timevec = linspace(tstartplot,tendplot,Ncars);
%    timevec = [tstartplot tendplot]; Ncars = 2;
end
% timevec(3) = 40.7; %(for drop throttle maneuver in exp)
% timevec(6) = 42.5;
% timevec(6) = 3.25; % for DT in sim

plotindex = zeros(Ncars,1);
for i = 1:Ncars
    % get index corresponding to timevec
    plotindex(i) = floor((timevec(i)-tstartplot)*500+1);
end

figure;
hold on;
axis equal

for i = 1:Ncars
    PosEplot = posE(plotindex(i));
    PosNplot = posN(plotindex(i));
    Heading = psi(plotindex(i));
    DrawVehicle(PosEplot,PosNplot,Heading,delta(plotindex(i)),a,b,t_f,t_r,r_w);
end
% plot trajectory of vehicle CG
% figure(8); hold on;
plot(posE(plotindex(1):plotindex(end)),posN(plotindex(1):plotindex(end)),'k')

axes_handle = gca;
set(axes_handle, 'FontName', 'Times New Roman', 'FontSize', 14);
title('Vehicle Trajectory Top View','FontSize', 14);
xlabel('East Position (m)', 'FontSize', 14)
ylabel('North Position (m)', 'FontSize', 14)

