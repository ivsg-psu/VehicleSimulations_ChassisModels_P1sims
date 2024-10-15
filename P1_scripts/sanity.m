% sanitySenseHat.m
% To be used to test collected data sets for bad data

% Author: Graham Heckert, Summer 2022 Research Project
% Using previous work from cgadda, Shad Laws

%% Important Checks

% First check for variable & DataDescription
if(~exist('data','var'))
    error("Variable 'data' does not exist.");
end
if(~exist('time','var'))
    error("Variable 'time' does not exist.");
end

% A quick check to catch an obvious inconsistency...
if sum([data.size]) ~= size(rt_spiBytesIn(1,:)) % CHANGE this since time vector might not be included in data
    error('Data dimensions are not consistent with spiBytesIn variable.');
end

% Ok, now use extractdata to convert y into something more useful.
% GPS=extractData(y,data,'03 GPS',0);
% INS=extractData(y,data,'02 INS',0);

%% Basic data checks
% Checking to see that data is reasonably large given how much data is
% being taken
if(time(1)~=0)
    disp('WARNING: Non-zero start time. Data may have wrapped.');
    if(numel(y)<1000000)
        disp('WARNING: Total data collected less than 8MB.');
    end
end

% Checking data to see if data is being recorded (either data is all 0s or
% all 255 or some other max value)
% MAKE DATA CHECK FOR
badDataList = [];
for i=1:length(data)
    fn = fieldnames(data(i).val);
    for k=1:length(fn)
        for j=1:length(data(i).val.(fn{k})(1,:))
            if (all(data(i).val.(fn{k})(:,j)==0)) || (all(data(i).val.(fn{k})(:,j) == 255)) || (range(data(i).val.(fn{k})(:,j)) == 0)
                badDataList(end+1) = fn(k);
            end
        end
    end
end
if ~isempty(badDataList)
    fprintf('WARNING: The following data is all constant values. Data collection might not have occurred.\n %s\n',badDataList)
end
clear badDataList i k j fn
% End of basic checks

%% Check the GPS data. Any other data specific checks as well
% Creating data to be checked via GPS & INS data NEED TO CHANGE COLUMNS
% THAT DATA IS SELECTED FROM SINCE y.mat IS INVERTED
% AttitudeInvalid=round(100*size(find(GPS(:,15)~=4))/size(t));
% PosVelocityInvalid=round(100*size(find(GPS(:,16)~=529))/size(t)); % Signal 16 is attitude status (expected value)
% bitshift(bitand(GPS(:,16),512),-8); 
% bitshift(bitand(GPS(:,16),16),-4);
% bitand(GPS(:,16),1);
% RollAyCov=cov(GPS(:,14),INS(:,4));
% SlipAngle=(mod(GPS(:,13)-GPS(:,12)+180,360)-180).*(GPS(:,10)>3);  % Heading - course over ground, multiplied by boolean of speed above threshold
% ReverseSlipAngle=(mod(GPS(:,12)-GPS(:,13)+180,360)-180).*(GPS(:,10)>3);  % Course over ground - heading, multiplied by boolean of speed above threshold
% PPSSignal=100*size(find(GPS(:,1)>2))/size(t);

%If more than 10% of the data has an invalid GPS status, issue a warning.
% if(AttitudeInvalid>10)
% 	fprintf('WARNING: Attitude status invalid for %d%% of data.\n',AttitudeInvalid);
% end
% if(PosVelocityInvalid>10)
% 	fprintf('WARNING: Position/velocity status invalid for %d%% of data.\n',PosVelocityInvalid);
% end
% 
% % Check to see if the beeline antennas are hooked up backwards.
% if(RollAyCov(2,1)<0)
% 	disp('WARNING: Roll angle is negatively correlated with lateral acceleration.');
% end
% % NOTE: The previous test may be fooled by high-frequency driver commands.
% 
% % This test checks the same thing, but in a different way.
% if(any(abs(SlipAngle)>20))
% 	if(all(abs(ReverseSlipAngle)<20))
% 		disp('WARNING: Beeline antennas may be reversed.')
% 	else
% 		disp('WARNING: Excessive sideslip angles.');
% 	end
% end
% 
% % Check the PPS signal.  It should have a 50% duty cycle.
% if(PPSSignal>55||PPSSignal<45)
% 	disp('WARNING: Invalid PPS signal.');
% end

% End of GPS checks

disp('Sanity check complete')

% Clean up
clear GPS INS i
clear BeelineHeadingInvalid BeelineVelocityInvalid GPSVelocityInvalid ... 
	 RollAyCov PPSSignal DirectionHeading SlipAngle ReverseSlipAngle
     