%clear all
close all
% calculates slip angles and tire forces
%load craig_2010-09-09_ai
names;

%Define start and stop times for data set
tStart = 1;
tEnd = 100;

indices = find(t >= tStart);
indexStart = indices(1);
indices = find(t <= tEnd);
indexEnd = indices(end);
% get data
lateral_velocity=SSest(indexStart:indexEnd,12);       % [m/s]
yaw_rate=SSest(indexStart:indexEnd,4);                % [rad/s]
longitudinal_velocity=SSest(indexStart:indexEnd,9);   % [m/s]
delta_road=PostProc(indexStart:indexEnd,3);           % [rad at roadwheels]
lateral_accel=SSest(indexStart:indexEnd,14);          % [m/s^2]

% car parameters/gravel
m=1724;             % [kg]
Iz=1300;            % [kg*m^2]
a=1.35;             % [m]
b=1.15;             % [m]
% CFaxle=2*52000*1.08*.55;     % [N/rad]
% CRaxle=2*69000*1.08*.55;     % [N/rad]
% CFaxle=60000;     % [N/rad]
% CRaxle=85000;     % [N/rad]
CFaxle=75000;     % [N/rad]
CRaxle=135000;     % [N/rad]
%Static normal loads
Fnf= 9.81*m*b/(a+b); % for one front tire 
Fnr=m*9.81-Fnf;

% calculate some stuff

% % slip angles at tires
alphaF=(atan2(lateral_velocity+a*yaw_rate,longitudinal_velocity)-delta_road).*(longitudinal_velocity > 4);     
  % [rad]
alphaR=atan2(lateral_velocity-b*yaw_rate,longitudinal_velocity).*(longitudinal_velocity > 4);        
          % [rad]

% calculate tire force from Judy's If_alpha_observer.m % steady-state force from banked ay 
FyF=(Fnf*lateral_accel/9.81).*(longitudinal_velocity > 4); 
FyR=(Fnr*lateral_accel/9.81).*(longitudinal_velocity > 4);

plot(alphaF*(180/pi), FyF, 'b.')
hold on;
xlabel('\alpha_F (deg)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('F_{yF} (N)', 'FontName', 'Times New Roman', 'FontSize', 14);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)
figure;
plot(alphaR*(180/pi), FyR, 'b.')
hold on;
xlabel('\alpha_R (deg)', 'FontName', 'Times New Roman', 'FontSize', 14);
ylabel('F_{yR} (N)', 'FontName', 'Times New Roman', 'FontSize', 14);
set(gca, 'FontName', 'Times New Roman', 'FontSize', 14)

%Compute front tire force estimate using front tire paramters
C_alpha = CFaxle;
Fz = Fnf;
mu = 0.55;
mu_s = mu;
offset = 0.5;
alpha = (0:-0.05:-15)*(pi/180);
alpha_sl = atan2(3*mu*Fz,C_alpha);
Ftire = (-C_alpha*tan(alpha) + (C_alpha^2/(3*mu*Fz))*(2-mu_s/mu)*tan(alpha).*abs(tan(alpha)) - ...
    (C_alpha^3/(9*mu^2*Fz^2))*(tan(alpha)).^3*(1-2*mu_s/(3*mu))).*(abs(alpha) < alpha_sl) + -mu_s*Fz*sign(alpha).*(abs(alpha) >= alpha_sl);;
figure(1);
plot(alpha*(180/pi)+offset, Ftire, 'r', 'LineWidth', 2)
hold on;


%Compute rear tire force estimate using rear tire paramters
C_alpha = CRaxle;
Fz = Fnr;
mu = 0.55;
mu_s = mu;
alpha = (0:-0.05:-10)*(pi/180);
offset = 0.05;
alpha_sl = atan2(3*mu*Fz,C_alpha);
Ftire = (-C_alpha*tan(alpha) + (C_alpha^2/(3*mu*Fz))*(2-mu_s/mu)*tan(alpha).*abs(tan(alpha)) - ...
    (C_alpha^3/(9*mu^2*Fz^2))*(tan(alpha)).^3*(1-2*mu_s/(3*mu))).*(abs(alpha) < alpha_sl) + -mu_s*Fz*sign(alpha).*(abs(alpha) >= alpha_sl);
figure(2);
plot(alpha*(180/pi)+offset, Ftire, 'r', 'LineWidth', 2)


% axis([0 25 0 8000])


% figure;
% plot(t, alphaR)
% figure;
% plot(t, FyR)
% figure;
% plot(t, alphaF)
% figure;
% plot(t, FyF)
% figure;
% plot(t, abs(FyF-FyR))

% note that alpha is garbage at the beginning and end of tests, and
% sometimes in the middle too.  consequently, if you plot them you'll get an ugly tire curve 
% only plot alpha/force for values of alpha you believe 
% i normally plot alpha vs. -force