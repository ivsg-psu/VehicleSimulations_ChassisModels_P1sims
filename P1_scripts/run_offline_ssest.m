% This script loads in data sets recorded by the model
% nissan_steer.mdl and applies
% Jihan's sideslip estimation filters by using the
% simulink model offline_ssest.mdl.  The constants for the filters
% were most recently tweaked by Shad Laws.
%
% It is designed to work with the new y-vector structure as of
% the 12/11/04 Moffett tests.  It also includes the stuff that
% used to be in nissan_steer_start.m to initialize the filters.
% Note that this most recent structure has yaw rate in rad/s but
% other gyros in deg/s, so the yaw rate is changed back to deg/s
% to make the estimator happy.


% kalman filter parameters
% Velocity filter initialization
init_state_vel = [0, 0]; % P42
init_cov_vel = zeros(1,4*4); % P43
% Heading filter initialization
init_state_hdg = [1, 0]; % P42
init_cov_hdg = zeros(1,3*3); % P43
% Roll filter initialization
init_state_roll = [0]; % P66
init_cov_roll = zeros(1,2*2); % P67

Ts=0.002;
load('steeranglelookup.mat');

fnames={...
        '..\shad_2004-12-11_a', ...
        '..\shad_2004-12-11_b', ...
        '..\shad_2004-12-11_c', ...
        '..\shad_2004-12-11_d', ...
        '..\shad_2004-12-11_e', ...
        '..\shad_2004-12-11_f', ...
        '..\shad_2004-12-11_g', ...
        '..\shad_2004-12-11_h', ...
        '..\shad_2004-12-11_i', ...
        '..\shad_2004-12-11_j', ...
        '..\shad_2004-12-11_k', ...
        '..\shad_2004-12-11_l', ...
        '..\shad_2004-12-11_m', ...
        '..\shad_2004-12-11_n', ...
        '..\shad_2004-12-11_o', ...
        '..\shad_2004-12-11_p', ...
        '..\shad_2004-12-11_q', ...
        '..\shad_2004-12-11_r', ...
        '..\shad_2004-12-11_s', ...
        '..\shad_2004-12-11_t', ...
        '..\gerdes_2004-12-11_a', ...
        '..\gerdes_2004-12-11_b', ...
        '..\gerdes_2004-12-11_c', ...
        '..\gerdes_2004-12-11_d', ...
        '..\gerdes_2004-12-11_e', ...
        '..\gerdes_2004-12-11_f', ...
        };
    
for i=1:size(fnames,2),
	fname=fnames{i};

	load([fname '.mat']);

	stoptime=Ts*(length(t)-1);   %note that this does not use the t vector itself due to tiny time offsets from 1/500 Hz... it confuses MATLAB otherwise
   
	delta=struct('time',t,'signals',struct('values',y(:,7:8),'dimensions',2));
	ins=struct('time',t,'signals',struct('values',[y(:,9)*180/pi y(:,10:12) y(:,13:14)*0],'dimensions',6));  % this fudges in some zeros so the measurement block in the post processor stays happy.  Note the deg vs. rad!!!  Code wants deg.
	gps=struct('time',t,'signals',struct('values',[y(:,25:30) 0*y(:,25:30)],'dimensions',12));
	beeline=struct('time',t,'signals',struct('values',y(:,15:24),'dimensions',10));
	pps=struct('time',t,'signals',struct('values',[y(:,31) y(:,31)],'dimensions',2));
   
	sim('offline_ssest',[0 stoptime]);
    z=simout.signals.values;
    velin=vfin.signals.values;
    velout=vfout.signals.values;
    
    y1=zeros(length(t),49);
    y1(:,1:36)=y(:,1:36);
    y1(:,37)=z(:,1)*pi/180;  %beta
    y1(:,38)=z(:,2)*pi/180;  %r
    y1(:,39)=z(:,3);  %Vy
    y1(:,40)=z(:,4);  %Vx
    y1(:,41)=z(:,5)*pi/180;  %phi
    y1(:,42)=z(:,6)*pi/180;  %phidot
    y1(:,43)=interp1(lma,lsalu,y(:,7));  %delta_l (translated through lookup table)
    y1(:,44)=interp1(rma,rsalu,y(:,8));  %delta r (translated through lookup table)
    y1(:,45:49)=y(:,40:44);
    y=y1;
    
    DataDescription(6).size = 8;
    DataDescription(6).units = {'rad' 'rad/s' 'm/s' 'm/s' 'rad' 'rad/s' 'rad' 'rad'};
    DataDescription(6).desc = 'Contains postprocessed beta, r, Vy, Vx, phi, phidot, and actual wheel steer angles';
    
    save([fname '_pp.mat'],'t','y','DataDescription','info');  % you can add ssout, delays, velin, velout, etc. here if desired.

    clear y t z y1 velin velout delays ssout;
 
end

display('done...')