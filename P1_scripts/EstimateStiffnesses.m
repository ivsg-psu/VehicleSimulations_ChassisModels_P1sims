% Script to estimate the cornering stiffnesses from a ramp steer
clear all
% close all

% Load P1 data
%[filename, pathname] = uigetfile('*.mat', 'Pick a MATLAB data file','~/Google Drive/P1_Testing_2015-07-20/craig_2015-07-20_ac.mat');
%load([pathname filename]);
load 8-04-2015_Data/craig_2015-08-04_ag
p1_params

% Break up the vectors
names;
N = length(t);
r = SSest(:,4);
Ux = SSest(:,9);
Uy = SSest(:,12);
ay = SSest(:,14);
deltaFL = PostProc(:,1);
deltaFR = PostProc(:,2);
deltaF = PostProc(:,3);

% Calculate slip angles
alphaFL = (Uy + r.*param.a)./(Ux - r.*param.c) - deltaFL;
alphaFR = (Uy + r.*param.a)./(Ux + r.*param.c) - deltaFR;
alphaF = (Uy + r.*param.a)./Ux - deltaF;
alphaR = (Uy - r.*param.b)./Ux;

% Calculate static normal forces
FzF = param.b/(param.a + param.b)*param.m*9.81;
FzR = param.a/(param.a + param.b)*param.m*9.81;

%% Make some useful plots
% Steering angle vs ay
figure(1);
plot(abs(ay),abs(deltaF),'.')
xlabel('Lateral Accel (m/s^2)');
ylabel('Steering Angle (rad)')
hold on
delta_ack = (param.a + param.b)/(30.48+param.c+0.5); % Ackerman angle for 100' circle
h = axis;
Kg = 0.001; % understeer gradient (rads/m/s/s)
plot([0 10],2.5/10^2*[0 10],'k','linewidth',3); % neutral steer line for constant speed test at 10 m/s
%plot([0 10],[delta_ack delta_ack + Kg*10])
hold off

figure(2)
subplot(511)
plot(t,ay);
ylabel('Lateral Acceleration (m/s^2)')
h(1) = gca;
subplot(512)
plot(t,deltaF*180/pi);
ylabel('Steering Angle (deg)')
h(2) = gca;
subplot(513)
plot(t,SSest(:,4))
ylabel('Yaw Rate (deg/s)')
h(3) = gca;
subplot(514)
plot(t,SSest(:,15)*180/pi);
ylabel('Sideslip Angle (deg)')
h(4) = gca;
subplot(515)
plot(t,SSest(:,9))
ylabel('Longitudinal Speed (m/s)')
h(5) = gca;
linkaxes(h,'x')

figure(3)
plot(Ux,ay)
xlabel('Longitudinal Velocity (m/s)')
ylabel('Lateral Acceleration (m/s^2)')



%% Estimate tire properties
% Determine the subset of data to use for tire modeling
figure(2); drawnow;
[tPoints,~] = ginput(2);
tstart = round(500*tPoints(1)); tend = round(500*tPoints(2));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimate from speed ramp, constant radius    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Calpha2 = zeros(2,tend-tstart);
for i = tstart:tend
    Ac = [-alphaF(i)/param.m -alphaR(i)/param.m;
        -alphaF(i)*param.a/param.Iz alphaR(i)*param.b/param.Iz];
    bc = [r(i)*Ux(i); 0];
    Calpha2(:,i+1-tstart) = Ac\bc;
end
% Throw away really bogus cornering stiffness estimates from noise
Calpha2(find(Calpha2<0)) = NaN;
Calpha2(find(Calpha2>250000)) = NaN;

% Plot a histogram of the remaining cornering stiffness estimates
figure(6); hist(Calpha2(1,:),75); drawnow;
[CalphaF,~] = ginput(1);
figure(7); hist(Calpha2(2,:),75); drawnow;
[CalphaR,~] = ginput(1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Check with tire curve plot  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculate the total lateral force on the front and rear
A = [param.a -param.b; 1 1];
B = [0; 0]; % Since the maneuver is at steady state, B(1) should be 0

for i = 1:N
    B(2) = param.m*Ux(i).*r(i);%ay(i);%
    x = A\B;
    FyF(i) = x(1);
    FyR(i) = x(2);
end

offsetAlphaF = 0.00;
offsetAlphaR = 0.00;

figure(4)
subplot(211)
plot(alphaF+offsetAlphaF,abs(FyF),'.',alphaF(tstart:tend)+offsetAlphaF,abs(FyF(tstart:tend)),'.')
axis([-10*pi/180 10*pi/180 0 FzF])
ylabel('Front Axle')
subplot(212)
plot(alphaR+offsetAlphaR,abs(FyR),'.',alphaR(tstart:tend)+offsetAlphaR,abs(FyR(tstart:tend)),'.')
axis([-10*pi/180 10*pi/180 0 FzR])
ylabel('Rear Axle')

% Try to plot a brush model over the top of the point clouds
alphaRange = (0:0.05:8)'*pi/180*sign(mean(alphaF(tstart:tend)+offsetAlphaF));
mu = 0.85;
%CalphaF = 80000;
%CalphaR = 90000;

FyFTest = -CalphaF*tan(alphaRange) + CalphaF^2./(3*mu*FzF).*tan(alphaRange).*abs(tan(alphaRange)) - CalphaF^3./(27*(mu*FzF).^2).*tan(alphaRange).^3;
FyRTest = -CalphaR*tan(alphaRange) + CalphaR^2./(3*mu*FzR).*tan(alphaRange).*abs(tan(alphaRange)) - CalphaR^3./(27*(mu*FzR).^2).*tan(alphaRange).^3;

figure(4)
subplot(211)
hold on
plot(alphaRange,abs(FyFTest),'k','linewidth',2)
hold off
xlabel('Slip Angle (rad)')
ylabel('Front Lateral Force (N)')
text(-0.15,7100,['Slip angle data shifted ' num2str(offsetAlphaF) ' rad, Stiffness ' num2str(round(CalphaF)) ' N/rad']);
subplot(212)
hold on
plot(alphaRange,abs(FyRTest),'k','linewidth',2)
hold off
xlabel('Slip Angle (rad)')
ylabel('Rear Lateral Force (N)')
text(-0.15,8100,['Slip angle data shifted ' num2str(offsetAlphaR) ' rad, Stiffness ' num2str(round(CalphaR)) ' N/rad']);
