% savedata.m
%
%     This function displays a dialog which prompts for information about
%     the data being saved, then writes the data and the information into
%     a uniquely-named file.  The data to be saved should be in global
%     variables y & t, as will be the case if the command getdata is used
%     to retrieve the data from the xpc target.
% Last Modified by GUIDE v2.5 13-Sep-2004 17:44:51

% Author: Graham Heckert, Summer 2022 Research Project
% Using previous work from cgadda, Shad Laws


%% Grabbing data

% Stop the model (if not already stopped) and retrieve the data...
getData;

% Setting up description file
dataDesc;

% Build the info structure...
info.date=datestr(now,29);
info.time=erase(datestr(now,15),":");
info.modelname=input('Please enter the simulink model name without including the file extension: ','s'); % Used getRunOnBoot(r); FIX THIS. Only checks for things 'added' to run on boot, not built onto rp4 
% Check with Beal if necessary
% info.userblockname=UserBlockName;

% Ok, we want to get some info, but we need the model files to be loaded into
% memory for this to work.  So first we see if they're already available.
if(~isempty(find_system('name',info.modelname)))
    load_system(info.modelname);
	info.modelversion=get_param(info.modelname,'ModelVersion');
    close_system(info.modelname);
else
	info.modelversion=get_param(info.modelname,'ModelVersion');
end

% Building info structure from user input
info.driver=lower(deblank(input('Driver: ','s')));
info.testloc=lower(deblank(input('Test Location: ','s')));
info.tyPress=lower(deblank(input('Tire Pressures: ','s')));
info.ambT=lower(deblank(input('Ambient Temp: ','s')));

description='';
des=input('Description:  (End with a . on a line by itself.)\n','s');
while(~strcmp(des,'.'))
    description=[description '\n' des];
    des=input('','s');
end
info.description=description;

% Making subdirectory that sorts data into each date it was collected
if ~exist(['data\' info.date],'dir')
    mkdir(['C:\Users\gjh014\gjhSummer2022Research\data\' info.date])
end

dirlist=dir(['data\' info.date '\' info.driver '_' info.date '_*.mat']);

if(size(dirlist,1))
    lastone=dirlist(end);
    letters=lastone.name(end-(5:-1:4));
	if(letters(2)<'z')
		letters(2)=char(letters(2)+1);
	else
		letters(2)='a';
		letters(1)=char(letters(1)+1);
	end
else
    letters='aa';
end

info.run=letters;

% Create a unique filename
fname=[info.driver '_' info.date '_' info.run ];

% This part shouldn't be necessary.  But just to be safe...
dirlist=dir([fname '.mat']);
if(size(dirlist,1))
	error(['Internal savedata error.  Tried to save data as: ' fname ...
			'.mat but that file already exists!']);
end
        
% Run the sanity checker
sanity;

% Now save the file...
if exist('DataDescriptionUser','var')
    save(['C:\Users\gjh014\gjhSummer2022Research\data\' info.date '\' fname],'info','data','time','DataDescriptionUser');
else
    save(['C:\Users\gjh014\gjhSummer2022Research\data\' info.date '\' fname],'info','data','time');
end

% Summarize things
disp(['Model name: ' info.modelname]);
disp(['Version: ' info.modelversion]);
disp(['Time & Date: ' info.date ' ' info.time]);
disp(['Driver: ' info.driver]);
fprintf('Data dimensions: %d signals at %d data points\n',size(rt_spiBytesIn,2),size(rt_spiBytesIn,1));
% disp(['Max TET: ' num2str(max(TET)) ' with Ts= ' num2str(Ts)]);            
disp(['Data successfully saved to file: ' fname '.mat']);

% Clean up workspace
clear letters fname des description dirlist