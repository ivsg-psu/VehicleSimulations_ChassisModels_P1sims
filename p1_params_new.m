% Script to define a number of constants needed in various places in the P1
% control models.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
%              BASIC MODEL INFO/CONSTANTS               %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Fundamental time step of the model
Ts = 0.001;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
%            P1 SIMULINK MODEL PARAMETERS               %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Accelerator pedal mappingout (pedal volts to motor torque)
p1params.input.VhighGuard =4.8;    % guard voltage to protect against a short
p1params.input.VlowGuard = 0.4;     % guard voltage to protect against an open circuit
p1params.input.VmaxAccel = 4.0;    % high saturation voltage for accelerator potentiometer
p1params.input.VmidAccel = 3.6;    % design voltage at the transition from regen to drive
p1params.input.VminAccel = 1.6;    % low saturation voltage measured from accelerator potentiometer
p1params.input.Vdeadband = 0.4;
p1params.input.TmaxAccel = 350;       % motor torque desired at max accelerator travel (in Nm)
p1params.input.TminAccel = -20;       % regen torque desired at min accelerator travel (negative, in Nm)
p1params.input.TregenBrake = -1000;    % regen torque desired on brake pedal press (negative, in Nm)
p1params.input.TmaxRev = 100;         % motor torque desired at max accelerator travel in reverse (in Nm)
p1params.input.TminRev = -320;         % regen torque desired at min accelerator travel in reverse (in Nm)
p1params.input.Tmax = 3212;            % maximum spec motor torque (in Nm) not to be exceeded
p1params.input.Tmin = -3212;           % maximum spec regen torque (in Nm) not to be exceeded
p1params.input.handwheelMidpoint = 222; % Midpoint of the handwheel potentiometer (cts)
p1params.input.handwheelScaling = 250; % scale factor for handwheel potentiometer (rev/ct)
p1params.input.handwheelOffset = 0; % scale factor for handwheel potentiometer (rev/ct)

p1params.input.VAccelFc = 1;        % Accelerator pedal filter cut off frequency (in Hz)

% The following two lines are the result of using the MATLAB butterworth and IIR filter
% design tools with the cutoff above:
N = 6; %(for a 6th order Butterworth)
wc = p1params.input.VAccelFc*(2*Ts); % (set up the normalized filter frequency)
[b,a] = butter(N,wc); % (design using the specified normalized cutoff frequency)

p1params.input.VAccelFiltNum = [8.5316e-10
    5.119e-09
   1.2797e-08
   1.7063e-08
   1.2797e-08
    5.119e-09
   8.5316e-10]';
p1params.input.VAccelFiltDen = [      1
      -5.7572
       13.816
      -17.687
       12.742
      -4.8969
      0.78442]';

% Drivetrain control parameters
p1params.drivetrain.left.CANTimeOut = 1.2; % CAN time out threshold (in s)
p1params.drivetrain.left.zeroSpeedThresh = 4; % threshold for considering the vehicle to be moving slowly (m/s)
p1params.drivetrain.left.velLimREV = -900; % maximum motor speed in reverse (RPM)
p1params.drivetrain.left.velLimFWD = 5400; % maximum motor speed going forward (RPM)
p1params.drivetrain.left.torqueLimLow = -350; % maximum motor torque in regen (Nm)
p1params.drivetrain.left.torqueLimHigh = 350; % maximum motor torque in drive (Nm)
p1params.drivetrain.left.minTorqueStartDrive = -120; % minimum torque in regen allowed to start limp home drive mode (Nm)
p1params.drivetrain.left.maxTorqueStartDrive = 10; % minimum torque in motoring allowed to start limp home drive mode (Nm)
p1params.drivetrain.left.minTorqueFullDrive = -120; % minimum torque in regen allowed to start full drive mode (Nm)
p1params.drivetrain.left.maxTorqueFullDrive = 50; % minimum torque in motoring allowed to start full drive mode (Nm)
p1params.drivetrain.left.nDrive = 5.6; % minimum torque in regen allowed to start an active drive mode (Nm)

p1params.drivetrain.right.CANTimeOut = 1.2; % CAN time out threshold (in s)
p1params.drivetrain.right.zeroSpeedThresh = 2; % threshold for considering the vehicle to be moving slowly (m/s)
p1params.drivetrain.right.velLimREV = -900; % maximum motor speed in reverse (RPM)
p1params.drivetrain.right.velLimFWD = 5400; % maximum motor speed going forward (RPM) 
p1params.drivetrain.right.torqueLimLow = -350; % maximum motor torque in regen (Nm)
p1params.drivetrain.right.torqueLimHigh = 350; % maximum motor torque in drive (Nm)
p1params.drivetrain.right.minTorqueStartDrive = -25; % minimum torque in regen allowed to start an active drive mode (Nm)
p1params.drivetrain.right.maxTorqueStartDrive = 10; % minimum torque in regen allowed to start an active drive mode (Nm)
p1params.drivetrain.right.minTorqueFullDrive = -25; % minimum torque in regen allowed to start an active drive mode (Nm)
p1params.drivetrain.right.maxTorqueFullDrive = 50; % minimum torque in regen allowed to start an active drive mode (Nm)
p1params.drivetrain.right.nDrive = 5.6; % minimum torque in regen allowed to start an active drive mode (Nm)

% Steering control parameters
p1params.steering.left.CANTimeOut = 0.2; % CAN time out threshold (in s)
p1params.steering.left.startupTimeOut = 30; % Time to wait for proper startup before faulting (s)
p1params.steering.left.initNumPotReadings = 50; % Number of potentiometer readings to average for startup position (#)
p1params.steering.left.maxPotSTD = 500; % Maximum standard deviation of potentiometer readings (mV)
p1params.steering.left.minPotAvgVal = 200; % Minimum average potentiometer value (mV)
p1params.steering.left.maxPotAvgVal = 4800; % Maximum average potentiometer value (mV)
p1params.steering.left.potEncSlope = -73.299; % Slope of potentiometer to encoder calibration curve (cts/mV)
p1params.steering.left.potEncInt = 212718; % Intercept of potentiometer to encoder calibration curve (cts)
p1params.steering.left.finalOffsetLowThresh = -6000;
p1params.steering.left.finalOffsetHighThresh = 24000;
p1params.steering.left.hallWidthLowThresh = 1000;
p1params.steering.left.hallWidthHighThresh = 7000;
p1params.steering.left.homeOffsetLowThresh = -8000;
p1params.steering.left.homeOffsetHighThresh = 8000;
p1params.steering.left.intOffsetThresh = 3;
p1params.steering.left.alignmentSlewRate = 50; %
p1params.steering.left.finalOffsetAlignment = -22917;

p1params.steering.right.CANTimeOut = 0.2; % CAN time out threshold (in s)
p1params.steering.right.startupTimeOut = 30; % Time to wait for proper startup before faulting (s)
p1params.steering.right.initNumPotReadings = 50; % Number of potentiometer readings to average for startup position (#)
p1params.steering.right.maxPotSTD = 500; % Maximum standard deviation of potentiometer readings (mV)
p1params.steering.right.minPotAvgVal = 200; % Minimum average potentiometer value (mV)
p1params.steering.right.maxPotAvgVal = 4800; % Maximum average potentiometer value (mV)
p1params.steering.right.potEncSlope = 130.6; % Slope of potentiometer to encoder calibration curve (cts/mV)
p1params.steering.right.potEncInt = -157771; % Intercept of potentiometer to encoder calibration curve (cts)
p1params.steering.right.finalOffsetLowThresh = -10000;
p1params.steering.right.finalOffsetHighThresh = 6000;
p1params.steering.right.hallWidthLowThresh = 1000;
p1params.steering.right.hallWidthHighThresh = 7000;
p1params.steering.right.homeOffsetLowThresh = -8000;
p1params.steering.right.homeOffsetHighThresh = 8000;
p1params.steering.right.intOffsetThresh = 3;
p1params.steering.right.alignmentSlewRate = 50; %
p1params.steering.right.finalOffsetAlignment = 3407;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
%      DATA ACQUISITION/COMMUNICATION PARAMETERS        %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
p1params.wft.left.FxScale = 1.220703125;
p1params.wft.left.FyScale = 0.6103515625;
p1params.wft.left.FzScale = 1.220703125;
p1params.wft.left.MxScale = 0.18310546875;
p1params.wft.left.MyScale = 0.18310546875;
p1params.wft.left.MzScale = 0.18310546875;
p1params.wft.left.VelScale = 0.06103515625;
p1params.wft.left.PosScale = 0.010986328125;
p1params.wft.left.AxScale = 0.0030517578125;
p1params.wft.left.AyScale = 0.0030517578125;
p1params.wft.right.FxScale = 1.220703125;
p1params.wft.right.FyScale = 0.6103515625;
p1params.wft.right.FzScale = 1.220703125;
p1params.wft.right.MxScale = 0.18310546875;
p1params.wft.right.MyScale = 0.18310546875;
p1params.wft.right.MzScale = 0.18310546875;
p1params.wft.right.VelScale = 0.06103515625;
p1params.wft.right.PosScale = 0.010986328125;
p1params.wft.right.AxScale = 0.0030517578125;
p1params.wft.right.AyScale = 0.0030517578125;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                       %
%        MEASURED/ESTIMATED VEHICLE PARAMETERS          %
%                                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Gear ratios
n_drive = 5.6;      % transmission drive ratio (unitless) 
n_handwheel = 50;   % handwheel drive ratio (unitless) 
n_steering = 160;   % steering drive ratio (unitless)

% Encoder CPRs (counts per revolution)
cpr_handwheel = 500*4;  % 1000 CPR quadrature
cpr_steering = 1000*4;   % 500 CPR quadrature

% Dimensions and mass properties
param.m = 1724.0;                 % mass (kg)
param.a = 1.35;                   % cg to front axle distance (m)
param.b = 1.15;                   % cg to rear axle distance (m)
param.d = 1.62;                   % track width (m)
param.Iz = 1300;                  % Hand-fit estimate. (kg-m^2)

% Roll properties
param.Ix = 800;                   % roll inertia (kg-m^2)
param.h_roll = 0.39;              % effective roll height, i.e. cg height minus roll center height (m)
param.b_roll = 4800;              % roll damping (N-m-s/rad)
param.k_roll = 160000;            % roll stiffness (N-m/rad)

% Cornering stiffness
tire.fl.Ca = 75000/2;                % front left cornering stiffness (N/rad)
tire.fr.Ca = 75000/2;                % front right cornering stiffness (N/rad)
tire.rl.Ca = 135000/2;               % rear left cornering stiffness (N/rad)
tire.rr.Ca = 135000/2;               % rear right cornering stiffness (N/rad)

% Tire effective rolling radii
tire.fl.re = 0.161*2;               % tire effective rolling radius (m)
tire.fr.re = 0.161*2;               % tire effective rolling radius (m)
tire.rl.re = 0.3085;                % tire effective rolling radius (m)
tire.rr.re = 0.3085;                % tire effective rolling radius (m)

% Tire relaxation length estimates
tire.fl.rl = 0.3;                   % tire relaxation length (m)
tire.fr.rl= 0.3;                    % tire relaxation length (m)
tire.rl.rl = 0.55;                  % tire relaxation length (m)
tire.rr.rl = 0.55;                  % tire relaxation length (m)

% Tire pneumatic trail estimates
tire.fl.tp = 0.023;                 % pneumatic trail (m)
tire.fr.tp = 0.023;                 % pneumatic trail (m)
tire.rl.tp = 0.023;                 % pneumatic trail (m)
tire.rr.tp = 0.023;                 % pneumatic trail (m)

% Made-up parameteters for slow filter - what's slow mean though?
[B,A] = butter(2,1/500); % 2nd order, 1 Hz cut-off, Nyquist frequency is 500 Hz given that sampling rate is 1000 Hz
continuousFilter = tf(B,A);
discreteFilter = c2d(continuousFilter,Ts,'tustin');
[NUM_cellarray,DEN_cellarray] = tfdata(discreteFilter);
hal_filter_num = NUM_cellarray{1};
hal_filter_den = DEN_cellarray{1};
