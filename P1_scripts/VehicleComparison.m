%% Code for comparing model to experimental data

% clear; 

%% parameters

load('p1_MPU_2022-07-19_17-06-59.mat')

% Enumerate the wheels (this should appear in all your files)
ff = 1; rr = 2;
%size = sum(length(ff),length(rr));

% First load the parameters for the vehicle you are going to use
vehicle.m = 1900; % kg
vehicle.Ca = [75000;135000]; % N/rad
vehicle.Izz = 1300; % kg*m^2
vehicle.a = 1.35; % m
vehicle.b = 1.1; % m
vehicle.L = vehicle.a + vehicle.b; % m
vehicle.J = 30; % kg*m^2
vehicle.mu_peak = 1.2;
vehicle.mu_slide = 0.8;
vehicle.radius = 0.2667; % m

% Define the simulation parameters for your first simulation. 
% Our state variables are x = [Uy r]' where Uy = lateral velocity, r = yaw rate
% Define the initial conditions of the simulation

% Define testing scenario 
driver.mode = {'step','data'}; % Type of steering (control strategy or maneuver)
driver.steertime = 0.1; % Time to start the step
simulation.speed = 20;	% Perform the maneuver at 20 m/s
% EDIT TO USE GPS DATA SPEED

% Define any convenient physical parameters
simulation.g = 9.81;

dt = rt_tout(2,1) - rt_tout(1,1); % sec, time step
t = rt_tout; % time vector for run pulled from car data

Fy = zeros(length(t),2); % 2 is number of wheels in bike model
Uxdot = zeros(length(t),1);
Uydot = zeros(length(t),1);
rdot = zeros(length(t),1);
alpha = zeros(length(t),2);
state.Ux = zeros(length(t),1);
state.Ux(1) = simulation.speed; % take this out, just for demonstration
% should either assume speed starts at zero, or take initial GPS data
state.Uy = zeros(length(t),1);
state.r = zeros(length(t),1);

% driver.delta = [];
% driver.delta(1:200,1) = 0.04;
% driver.delta(201:500,1) = -0.025;
% driver.delta(501:700,1) = -0.06;
% driver.delta(701:4163,1) = 0;% Give the steering input as an array
% Try to get from SteeringLeft and SteeringRight
% Bits 16:19 of steering left and right give actual position in units of
% counts. Need to get value into 
posTargetValLeft = uint8todouble(1,0,rt_SteeringLeft(:,4),rt_SteeringLeft(:,5),rt_SteeringLeft(:,6),rt_SteeringLeft(:,7));
posTargetValRight = uint8todouble(1,0,rt_SteeringRight(:,4),rt_SteeringRight(:,5),rt_SteeringRight(:,6),rt_SteeringRight(:,7));
driver.delta = mean([posTargetValLeft posTargetValRight],2)*(0.785398/(2e4));
% There's a ratio for getting counts to steering angle
% Change from using target value, need to use actual steering angle (though
% should hopefully be similar in testing)

for k = 1:length(t)-1
    % Acceleration calculation using known torque values
    netTau = mean([rt_MotorRightTorque(k+1) rt_MotorLeftTorque(k+1)]);
    % Perhaps develop way to measure braking, though kind of difficult to
    % do
    
    % Calculate the slip angles, done for front and back wheels of
    % bicycle model
    beta = atan(state.Uy(k)/state.Ux(k));
    alpha(k+1,1) = beta + (vehicle.a/state.Ux(k))*state.r(k) - driver.delta(k);
    alpha(k+1,2) = beta - (vehicle.b/state.Ux(k))*state.r(k);

    % Calculate tire forces
    for wheel = ff:rr
        Fy(k+1,wheel) = -vehicle.Ca(wheel)*alpha(k+1,wheel);
    end
    
    % State derivatives
    Uxdot(k+1) = netTau/(vehicle.J/vehicle.radius + vehicle.m*vehicle.radius); % m/s^2
    Uydot(k+1) = (Fy(k+1,ff) + Fy(k+1,rr))/vehicle.m - state.r(k)*simulation.speed;
    rdot(k+1) = (vehicle.a*Fy(k+1,ff) - vehicle.b*Fy(k+1,rr))/vehicle.Izz;
    
    % Update state with forward Euler integration
    state.Ux(k+1) = state.Ux(k) + Uxdot(k+1)*dt;
    state.Uy(k+1) = state.Uy(k) + Uydot(k+1)*dt;
    state.r(k+1) = state.r(k) + rdot(k+1)*dt;
end 

clear alpha beta dt endT ff Fy k rdot rr rss size Uydot Uyss wheel netTau

%% Pull comparison data from car

% Speed (Longitudinal velocity, Ux)
%%GPS_Ux = uint8todouble(1,1,rt_GPS(:,45),rt_GPS(:,46),rt_GPS(:,47),rt_GPS(:,48)); % m/s

%% Plotting results

figure
subplot(3,1,1)
plot(t,state.Ux,'-.b')% plot some Ux GPS data for comparison
xlabel('Time (seconds)')
ylabel('U_x (m/s)')
title('Longitudinal Velocity of Vehicle')
legend('Model Data','Experimental Data','location','best')

subplot(3,1,2)
plot(t,state.Uy,'-.b') % how to get lateral vel. of vehicle, From GPS
xlabel('Time (seconds)')
ylabel('U_y (m/s)')
legend('Model Data','Experimental Data','location','best')
title('Lateral velocity step response')

subplot(3,1,3)
plot(t,state.r,'-.b',t,rt_IMUgZ,'-r')
xlabel('Time (seconds)')
ylabel('Yaw Rate (rad/s)')
legend('Model Data','Experimental Data','location','best')
title('Yaw rate step response')
