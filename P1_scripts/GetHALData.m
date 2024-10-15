function [HAL,number,hints]=GetHALData()
% Quick function to convert some CSV data into brief descriptions of HAL
% maneuvers.

hey=csvread('mungedtestplan.csv');

empty=cell(1,length(hey));
HAL=struct('enabled',empty,...
	       'maneuver',empty,...
		   'amplitude',empty,...
		   'delay',empty,...
		   'duration',empty,...
		   'startfreq',empty,...
		   'endfreq',empty);
number=hey(:,1);

hints=struct('start',empty,'stop',empty);

for ii=1:length(hey)
	switch(hey(ii,6))
		case 1
			HAL(ii).maneuver='Chirp';
		case 2
			HAL(ii).maneuver='Step';
		case 4
			HAL(ii).maneuver='Ramp';
		case 10
			HAL(ii).maneuver='Double step';
		otherwise
			HAL(ii).maneuver='';
	end
	if(isempty(HAL(ii).maneuver))
		HAL(ii).enabled='off';
	else
		HAL(ii).enabled='on';
	end

	HAL(ii).amplitude=hey(ii,3);
	HAL(ii).startfreq=hey(ii,7);
	HAL(ii).endfreq=hey(ii,8);
	HAL(ii).duration=[];
	HAL(ii).delay=[];

end

[hints.start]=deal(hey(:,4));
[hints.stop]=deal(hey(:,5));

% get_param('nissan_steer/Steering Controller/HAL-9000/enabled');
% info.hal.maneuver=get_param('nissan_steer/Steering Controller/HAL-9000/maneuver');
% info.hal.amplitude=get_param('nissan_steer/Steering Controller/HAL-9000/amplitude');
% info.hal.delay=get_param('nissan_steer/Steering Controller/HAL-9000/delay');
% info.hal.duration=get_param('nissan_steer/Steering Controller/HAL-9000/duration');
% info.hal.startfreq=get_param('nissan_steer/Steering Controller/HAL-9000/startfreq');
% info.hal.endfreq=get_param('nissan_steer/Steering Controller/HAL-9000/endfreq');
