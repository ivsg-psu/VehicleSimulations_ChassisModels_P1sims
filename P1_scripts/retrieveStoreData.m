% This script pulls the data collected on the car that is temporarily
% stored on the Flexcase and pulls it back onto the Matlab running on the
% host computer, then stores and saves the data as .mat files.

% Author: Graham Heckert, Summer 2022 Research Project


%% Testing Functions to talk directly to Raspberry Pi

% Loads and saves the output log file onto current Matlab directory
getFile(r,'model*.mat');

% Using a pre-written Mathworks support package function, can call to have
% the multiple saved files to be joined

% Continue to modify to work with a long list of incoming .mat files
Raspberrypi_MAT_stitcher('model*.mat');


%% Sanity check




