% This script pulls data off the flexcase collected by the car's sensors 
% to do basic things like check the validity of
% the data and give some graphics to the user to show it makes sense.

% Author: Graham Heckert, Summer 2022 Research Project
% Using previous work from cgadda, Shad Laws
%% Pull data to host computer

% Setup up object to communicate with raspberry pi
% Enter the raspberrypi address, username, and password to the following
% function
r = raspberrypi('FlexCase01.local','pi','FazK75niXS');

% First check for the existence of raspberry pi object.
if(~exist('r','var'))
    error('Unable to create object "r".  Unable to control flexcase target.');
end

disp('Retrieving data from Raspberry Pi 4...');

% Get user input to determine the name of the files being retrieved
% Useful: y.mat can be made into y*.mat to include all filenames
% starting with y and ending with .mat in order to retrieve and load
% multiple files under one main name with numbered iterations
% e.g.: giving y*.mat will save y1.mat, y2.mat, y3.mat, etc.
if ~exist('masterFileName','var')
    masterFileName = input('Please enter the name of the file you are retreiving. \nIf you want to retrieve multiple files under the same base name, use *. \ne.g.: y*.mat will return all names such as y1.mat, yApple.mat, etc. \nEnter file name: ','s');
    while isempty(masterFileName)
        masterFileName = input('Please enter the name of the file you are retreiving. \nIf you want to retrieve multiple files under the same base name, use *. \ne.g.: y*.mat will return all names such as y1.mat, yApple.mat, etc. \nEnter file name: ','s');
    end
end
% Retrieving files under the name given in masterFileName variable
getFile(r,masterFileName); % Change to filename you are looking for

% Give option to run matlab stitcher, default to Yes if nothing is entered
stitcherAns = input("Run file stitcher? Hit return for yes.\n(Yes or No): ",'s');
if isempty(stitcherAns)
    stitcherAns = 'Yes';
end
if strcmp(stitcherAns,'Yes')
    Raspberrypi_MAT_stitcher(dir(masterFileName));
else
    % FileDataStore() gives option to choose where to read from, so use that in
    % later implementation to give flexibility for user
    fds = fileDatastore(masterFileName,'ReadFcn',@importdata);
    fullFileNames = fds.Files;
    for k = 1:length(fullFileNames)
        fprintf('Now reading file %s\n',fullFileNames{k});
        load(fullFileNames{k});
    end    
end


%% Define DataDescriptionUser
% Chooses one of the many 'Profiles' such that multiple users have ease of access
% to connect matlab to their simulink blocks. Should be altered for new simulink
% files. Ex: 'p1/User Controllers/ControllerP1Racing' indicates the
% simulink file name/subsystem1/subsystem2
if sum(strcmp(find_system(bdroot),'p1/User Controllers/ControllerP1Racing'))+sum(strcmp(find_system(bdroot),'p1/User Controllers/ControllerP1RacingSlipCircle'))
    DataDescriptionUser=datadescRacing;
    UserBlockName='ControllerP1Racing';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/Sliding Surface Control Subsystem'))
    DataDescriptionUser=datadescSSC;
    UserBlockName='SSC';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/MPC CAN Connection'))
    DataDescriptionUser=datadescMPCEnv;
    UserBlockName='MPC_Envelope';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/EnvEnv Connection'))
    DataDescriptionUser=datadescEnvEnv;
    UserBlockName='EnvEnv Connection';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/Envelope control with Differential drive'))
    DataDescriptionUser=datadescTCS;
    UserBlockName='TCS';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/MPCACC'))
    DataDescriptionUser=datadescMPCACC;
    UserBlockName='MPCACC';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/LQACC'))
    DataDescriptionUser=datadescLQACC;
    UserBlockName='LQACC';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/Drift and Speed Controller'))
    DataDescriptionUser=datadescDriftSpeedController;
    UserBlockName='Drift and Speed Controller';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/Driftkeeping'))
    DataDescriptionUser=datadescDriftkeeping;
    UserBlockName='Driftkeeping';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/Simplified Drift Control'))
    DataDescriptionUser=datadescDriftControllerSDSC;
    UserBlockName='Simplified Drift Control';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/Lanekeeping'))
    DataDescriptionUser=datadescLK;
    UserBlockName='Lanekeepingl';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/SSC Drift Controller'))
    DataDescriptionUser=datadescDriftControllerSSC;
    UserBlockName='SSC Drift Controller';
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/TTS Steering Control'))
    DataDescriptionUser=datadescTTSsteering;
    UserBlockName='TTS Steering';    
elseif sum(strcmp(find_system(bdroot),'p1/User Controllers/PSU Sim'))
    DataDescriptionUser=datadescPSU;
    UserBlockName='PSU Sim';
else
   UserBlockName='none';
end

%% Set up data descriptions
dataDesc;

%% Run sanity check
sanity;

%% Clean up
clear fds fullFileNames k i masterFileName
