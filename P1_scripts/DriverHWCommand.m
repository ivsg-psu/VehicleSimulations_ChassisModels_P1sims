function delta = DriverHWCommand(maneuver, varargin)
% steering  Calculate steer angle applied to vehicle
% 
% steering('step',delta0,deltaf,steptime,t) provides the steer angle at time t
% corresponding to a step change from delta0 to deltaf at steptime.
%
% steering('slalom',tstart,frequencyHz,amplitudeDeg,t) returns the steer angle at time t
% corresponding to a slalom starting at tstart
%
% steering('Ramp',delta0,deltaf,t0,tf,t) provides the steer angle at time t
% corresponding to a step change from delta0 to deltaf at steptime.

% Step input
if strcmp(maneuver,'step')             
    if (nargin == 5)                
        delta0 = varargin{1}(1);        
        deltaf = varargin{2}(1);   
        steptime = varargin{3}(1); 
        t = varargin{4}(1);
        if (t < steptime)
            delta = delta0*(pi/180);
        else
            delta = deltaf*(pi/180);
        end
    else                            
        error('Wrong number of arguments for step steer');
    end
% Slalom
elseif strcmp(maneuver,'slalom')
    if (nargin == 5)
        tstart = varargin{1}(1);
        frequencyHz = varargin{2}(1);
        amplitudeDeg = varargin{3}(1);
        t = varargin{4}(1);
        if t > tstart
            % sine wave input
            delta = amplitudeDeg*(pi/180)*sin(2*pi*frequencyHz*t);
        else
            delta = 0;
        end
    else
        error('Wrong number of arguments for slalom steer');
    end
% Ramp
elseif strcmp(maneuver,'ramp')         
    if (nargin == 6)
        delta0 = varargin{1}(1);
        deltaf = varargin{2}(1);
        t0 = varargin{3}(1);
        tf = varargin{4}(1);
        t = varargin{5}(1);
        if t < t0
            delta = delta0*(pi/180);
        elseif t > tf
            delta = deltaf*(pi/180);
        else
            delta = delta0*(pi/180) + (deltaf - delta0)*(pi/180)/(tf - t0)*t;
        end
    else
        error('Wrong number of arguments for ramp steer');
    end
else 
    error('Unknown steering maneuver');       
end
