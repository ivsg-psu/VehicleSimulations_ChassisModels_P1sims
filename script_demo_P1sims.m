%% Introduction to and Purpose of the P1simscodes
% This is a strter script to show the primary functionality of the
% P1sims library.
%
% This is the explanation of the code that can be found by running
%
%       script_demo_P1sims
%
% This is a script to demonstrate the functions within the P1sims code
% library. This code repo is typically located at:
%
%   https://github.com/ivsg-psu/VehicleSimulations_ChassisModels_P1sims
%
% If you have questions or comments, please contact Sean Brennan at
% sbrennan@psu.edu, Craig Beal at cbeal@bucknell.edu



%% Revision History:
% 2024_09_17 - sbrennan@psu.edu
% -- First write of code by cloning PlotRoad as starter


%% To-Do list
% 2024_09_17 - S. Brennan
% -- Need to do a top-to-bottom clean of code to prep it for P1sim work

%% Prep the workspace
close all
clc

%% Dependencies and Setup of the Code
% The code requires several other libraries to work, namely the following
%
% * DebugTools - used for debugging prints
% * GPS - this is the library that converts from ENU to/from LLA
% List what libraries we need, and where to find the codes for each
clear library_name library_folders library_url

ith_library = 1;
library_name{ith_library}    = 'DebugTools_v2024_10_14';
library_folders{ith_library} = {'Functions','Data'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/Errata_Tutorials_DebugTools/archive/refs/tags/DebugTools_v2024_10_14.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'PathClass_v2024_03_14';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_PathTools_PathClassLibrary/archive/refs/tags/PathClass_v2024_03_14.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'GPSClass_v2023_06_29';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FieldDataCollection_GPSRelatedCodes_GPSClass/archive/refs/tags/GPSClass_v2023_06_29.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'LineFitting_v2023_07_24';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FeatureExtraction_Association_LineFitting/archive/refs/tags/LineFitting_v2023_07_24.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'FindCircleRadius_v2023_08_02';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/PathPlanning_GeomTools_FindCircleRadius/archive/refs/tags/FindCircleRadius_v2023_08_02.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'BreakDataIntoLaps_v2023_08_25';
library_folders{ith_library} = {'Functions'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FeatureExtraction_DataClean_BreakDataIntoLaps/archive/refs/tags/BreakDataIntoLaps_v2023_08_25.zip';

ith_library = ith_library+1;
library_name{ith_library}    = 'PlotRoad_v2024_09_14';
library_folders{ith_library} = {'Functions', 'Data'};
library_url{ith_library}     = 'https://github.com/ivsg-psu/FieldDataCollection_VisualizingFieldData_PlotRoad/archive/refs/tags/PlotRoad_v2024_09_14.zip'; 


%% Clear paths and folders, if needed
if 1==0
    clear flag_P1sims_Folders_Initialized;
    fcn_INTERNAL_clearUtilitiesFromPathAndFolders;
end


%% Do we need to set up the work space?
if ~exist('flag_P1sims_Folders_Initialized','var')
    this_project_folders = {'Functions','Data','P1_scripts'};
    fcn_INTERNAL_initializeUtilities(library_name,library_folders,library_url,this_project_folders);
    flag_P1sims_Folders_Initialized = 1;
end

%% Load hard-coded vectors
% These are used to align key data to a local coordinate system wherein
% that data is axis-aligned. Usually NOT needed

% hard_coded_reference_unit_tangent_vector_outer_lanes   = [0.793033249943519   0.609178351949592];
% hard_coded_reference_unit_tangent_vector_LC_south_lane = [0.794630317120972   0.607093616431785];

%% Set environment flags that define the ENU origin
% This sets the "center" of the ENU coordinate system for all plotting
% functions
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LATITUDE','40.86368573');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_LONGITUDE','-77.83592832');
setenv('MATLABFLAG_PLOTROAD_REFERENCE_ALTITUDE','344.189');


%% Set environment flags for plotting
% These are values to set if we are forcing image alignment via Lat and Lon
% shifting, when doing geoplot. This is added because the geoplot images
% are very, very slightly off at the test track, which is confusing when
% plotting data above them.
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LAT','-0.0000008');
setenv('MATLABFLAG_PLOTROAD_ALIGNMATLABLLAPLOTTINGIMAGES_LON','0.0000054');


%% Set environment flags for input checking
% These are values to set if we want to check inputs or do debugging
setenv('MATLABFLAG_P1SIMS_FLAG_CHECK_INPUTS','1');
setenv('MATLABFLAG_P1SIMS_FLAG_DO_DEBUG','0');


%% Core Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                  ______                _   _
%  / ____|                |  ____|              | | (_)
% | |     ___  _ __ ___   | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
% | |    / _ \| '__/ _ \  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
% | |___| (_) | | |  __/  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  \_____\___/|_|  \___|  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
%
% See:
% https://patorjk.com/software/taag/#p=display&f=Big&t=Core%20%20Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% fcn_plotRoad_plotXY
% plots XY data with user-defined formatting

fig_num = 1;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYdata = [time sin(time)];

% Test the function
clear plotFormat
plotFormat.Color = [0 0.7 0];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
h_plot = fcn_plotRoad_plotXY(XYdata, (plotFormat), (fig_num));
title(sprintf('Example %.0d: showing  color numbers',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Is a plot handle returned?
assert(all(ishandle(h_plot)));

%% fcn_plotRoad_plotXYI
% plots XY data with intensiy color mapping

fig_num = 2;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYIdata = [time sin(time) cos(time)];

% Test the function
plotFormat = 'r';
colorMap = [];
h_plot = fcn_plotRoad_plotXYI(XYIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing user-defined color to produce colormap',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Is a plot handle returned?
assert(all(ishandle(h_plot)))

%% fcn_plotRoad_plotXYZ
% plots XYZ data with user-defined formatting strings

fig_num = 3;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYZdata = [time sin(time) cos(time)];

% Test the function
plotFormat = 'r.-';
h_plot = fcn_plotRoad_plotXYZ(XYZdata, (plotFormat), (fig_num));
title(sprintf('Example %.0d: showing basic plot string',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Is a plot handle returned?
assert(all(ishandle(h_plot)))



%% fcn_plotRoad_plotXYZI
% plots XYZ data with intensiy color mapping

fig_num = 4;
figure(fig_num);
clf;

time = linspace(0,10,100)';
XYZIdata = [time sin(time) 1/25*(time-5).^2  cos(time)];

% Test the function
clear plotFormat
plotFormat.LineStyle = ':';
plotFormat.LineWidth = 5;
plotFormat.Marker = '+';
plotFormat.MarkerSize = 10;
colorMapString = 'hot';
colormapValues = colormap(colorMapString);
indicies_to_keep = (1:8:256)';
colormapValues = colormapValues(indicies_to_keep,:);

h_plot = fcn_plotRoad_plotXYZI(XYZIdata, (plotFormat),  (colormapValues), (fig_num));
title(sprintf('Example %.0d: showing use of a complex plotFormat',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Is a plot handle returned?
good_indicies = ~isnan(h_plot);
assert(all(ishandle(h_plot(good_indicies,1))));


%% fcn_plotRoad_plotLL
% geoplots Latitude and Longitude data with user-defined formatting strings

fig_num = 5;
figure(fig_num);
clf;


% Now call the function again to plot data into an existing figure to check
% that this works
data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
LLdata = [data3(:,2), data3(:,1), data3(:,3)];

% Test the function
clear plotFormat
plotFormat.Color = [1 1 0];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
h_geoplot = fcn_plotRoad_plotLL((LLdata), (plotFormat), (fig_num));

title(sprintf('Example %.0d: showing use of plotLL',fig_num), 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Is a plot handle returned?
assert(ishandle(h_geoplot))


%% fcn_plotRoad_plotLLI
% geoplots Latitude and Longitude data with intensiy color mapping

fig_num = 6;
figure(fig_num);
clf;

% Fill in data
data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
time = linspace(0,10,length(LLdata(:,1)))';
LLIdata = [data3(:,2), data3(:,1), time];

% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 5;
colorMap = 'hot';
h_plot = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing use of fcn_plotRoad_plotLLI',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Is a plot handle returned?
good_indicies = find(~isnan(h_plot));
assert(all(ishandle(h_plot(good_indicies,1))));

%% Animation Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 _                 _   _                 ______                _   _
%     /\         (_)               | | (_)               |  ____|              | | (_)
%    /  \   _ __  _ _ __ ___   __ _| |_ _  ___  _ __     | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%   / /\ \ | '_ \| | '_ ` _ \ / _` | __| |/ _ \| '_ \    |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  / ____ \| | | | | | | | | | (_| | |_| | (_) | | | |   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
% /_/    \_\_| |_|_|_| |_| |_|\__,_|\__|_|\___/|_| |_|   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See:
% https://patorjk.com/software/taag/#p=display&f=Big&t=Animation%20%20%20Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§                                                                                                     

%% fcn_plotRoad_animateHandlesOnOff
%fcn_plotRoad_animateHandlesOnOff    animates a list of handles by on/off
% 
% This function creates an animation of handles by turning selected plots
% on/off in sequence, creating the appearance of motion. If an array of
% handles is given in a sequence [h(1); h(2); h(3); ... etc], then when
% timeIndex is set to 1, then only h(1) is shown. When set to 2, then only
% h(2) is shown. When h(1)...h(M) are set up in sequence, the illusion of
% motion is created. A user-defined skipInterval can be given to create
% intervals other than 1 to 2 to 3. For example, a skip interval of 3 jumps
% from (1 and 4 and 7...) to (2 and 5 and 8... ) etc.
%
% fcn_plotRoad_animateHandlesOnOff(timeIndex, handleList, Xdata, Ydata, (skipInterval), (fig_num))

fig_num = 903;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

colormapMatrix = colormap('winter');
colormapMatrix = flipud(colormapMatrix);

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = 'none';
plotFormat.MarkerSize = 10;
colorMapStringOrMatrix = colormapMatrix;
maxColorsAngles = [128 45];
[h_geoplot, AllLatData, AllLonData, ~, ~, ~] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing animation of expanding circles');

%%%% Do the animation 
Nrings = length(AllLatData(:,1));
skipInterval = 40;
% filename = cat(2,filesep,'Images',filesep,'fcn_plotRoad_animateHandlesOnOff.gif');
filename = 'fcn_plotRoad_animateHandlesOnOff.gif';
flagFirstTime = 1;
for timeIndex = 1:200

    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot(1:end-1), AllLatData, AllLonData, skipInterval,-1);

    % Create an animated gif?
    if 1==1
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.02);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.02);
        end
    end

    pause(0.02);
end


%% fcn_plotRoad_animateHandlesDataSlide
% animates a list of handles by data sliding
% 
% This function creates an animation of handles by "sliding" data through
% the handles. For example, assume 4 data handles are given as
% handleList(1)...handleList(4), and each handle points to a plot of [1xN]
% data in X, and [1xN] data in Y, and Xdata and Ydata both contain
% matricies [KxN] which contain K timesteps of data in X and Y
% respectively, as rows. The code "slides" the data "up" into the handles
% such that, at the first time interval, handleList(4) is filled with the
% first row of X and Y data. At the second time interval, handleList(3) is
% filled with the first row, and handleList(4) is the second row. At the
% 3rd time interval, handleList(2) is filled with the 1st row,
% handleList(3) the 2nd row, and handleList(4) the 3rd row. Etc. This
% "sliding" method allows formatting defined within the handle definitions
% to be applied repeatedly across a data set, creating the illusion of
% animation.
%
% NOTE: if timeIndex is larger than K, it is "wrapped" back into the
% allowable range.
%
% FORMAT:
%
%      fcn_plotRoad_animateHandlesDataSlide(timeIndex, handleList, Xdata, Ydata, (afterPlotColor), (fig_num))

fig_num = 905;
figure(fig_num);
clf;

% Fill in some dummy data (East curve from scenario 1_1)

data3 = [
    -77.83108116099999,40.86426763900005,0
    -77.83098509099995,40.86432365200005,0
    -77.83093857199998,40.86435301300003,0
    -77.83087253399998,40.86439877000004,0
    -77.83080882499996,40.86444684500003,0
    -77.83075077399997,40.86449883100005,0
    -77.83069596999997,40.86455288200005,0
    -77.83064856399994,40.86461089600004,0
    -77.83060707999994,40.86467151800008,0
    -77.83057291199998,40.86473474700006,0
    -77.83054614799994,40.86479999100004,0
    -77.83052443199995,40.86486635700004,0
    -77.83051053899999,40.86493399600005,0
    -77.83050385699994,40.86500232600008,0
    -77.83050469499995,40.86507096000003,0
    -77.83051096999998,40.86513880700005,0
    -77.83051548199995,40.86516167900004,0
    -77.83052813799998,40.86520696400004,0
    -77.83055303799995,40.86527300500006,0
    -77.83058410099994,40.86533739600003,0
    -77.83062308399997,40.86539921800005,0
    -77.83066833899994,40.86545839100006,0
    -77.83071974699999,40.86551445800006,0
    -77.83077704999994,40.86556697700007,0
    -77.83084030799995,40.86561520700008,0
    -77.83090661499995,40.86566081200004,0
    -77.83097722599996,40.86570252900003,0
    -77.83105323399997,40.86573830000003,0
    -77.83113270799998,40.86576916300004,0
    -77.83121508099998,40.86579495800004,0
    -77.83129931099995,40.86581674200005,0
    -77.83138581099996,40.86583237300005,0
    -77.83147340899995,40.86584355000008,0
    -77.83156186599996,40.86584960200003,0
    -77.83165067999994,40.86585007100007,0
    -77.83173939599999,40.86584604200004,0
    -77.83182788999994,40.86583809200005,0
    -77.83191641299999,40.86582709200007,0
    -77.83198191299994,40.86581637600005,0
    -77.83211176999998,40.86579081600007,0
    ];

% NOTE: above data is in BAD column order, so we
% have to manually rearrange it.
LLdata = [data3(:,2), data3(:,1), data3(:,3)];


clear plotFormat
plotFormat.Color = [0 0.7 0];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;

% Fill in some plot handles by plotting the first Ncolor points
Ncolors = 5;
colorMapMatrix = colormap('turbo');
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, -1);
h_geoplots = zeros(Ncolors,1);
range=4;

for ith_plot = 1:Ncolors
    dataToPlot = [LLdata(ith_plot:ith_plot+range,1) LLdata(ith_plot:ith_plot+range,2)];
    plotFormat.Color = reducedColorMap(ith_plot,:);
    h_geoplots(ith_plot) = fcn_plotRoad_plotLL(dataToPlot, (plotFormat), (fig_num));
end
title(sprintf('Example %.0d: fcn_plotRoad_animateHandlesDataSlide',fig_num), 'Interpreter','none');
subtitle('Showing geoplot animation of XY data');

%%%% animate results
handleList = h_geoplots;
Xdata = LLdata(:,1);
Ydata = LLdata(:,2);
afterPlotColor = [1 1 0]; % Yellow
filename = 'fcn_plotRoad_animateHandlesDataSlide.gif';
flagFirstTime = 1;

for timeIndex = 1:40
    fcn_plotRoad_animateHandlesDataSlide(timeIndex, handleList, Xdata, Ydata, (afterPlotColor), (fig_num))

    % Create an animated gif?
    if 1==1
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",0.02);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",0.02);
        end
    end

    pause(0.02);
end

%% fcn_plotRoad_animatePlot - plotLLI specifying the full plotFormat
fig_num = 5;
figure(fig_num);
clf;

% Fill in data
% Check to see if XY data for the centerline of the original track lane was loaded earlier
mat_filename = fullfile(cd,'Data','Centerline_OriginalTrackLane_InnerMarkerClusterCenterOfDoubleYellow.mat');
if exist(mat_filename,'file')
    load(mat_filename,'XY_data');
end

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class

Npoints = length(XY_data(:,1));
LLA_positions_matrix =  gps_object.ENU2WGSLLA([XY_data zeros(Npoints,1)]);

time = linspace(0,10,Npoints)';
plotData = [LLA_positions_matrix(:,1), LLA_positions_matrix(:,2), sin(time)];


% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 5;

% Fill in large colormap data
colorMapMatrix = colormap('hot');

% Reduce the colormap
Ncolors = 20;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, -1);


h_animatedPlot = fcn_plotRoad_animatePlot('plotLLI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotLLI specifying the full plotFormat',fig_num), 'Interpreter','none');

for ith_time = 1:100:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotLLI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
    set(gca,'ZoomLevel',20,'MapCenter',plotData(ith_time,1:2));
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));

%%%%%
% Create an animated GIF with "following"?
if 1==0
    timeDelay = 0.2;
    filename = 'fcn_plotRoad_animatePlot_plotLLI_follow.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotLLI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));

    for ith_time = 1:500:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotLLI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        set(gca,'ZoomLevel',18.5,'MapCenter',plotData(ith_time,1:2));

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end

%%%%
% Create an animated GIF with "global view"?
if 1==0
    timeDelay = 0.2;
    filename = 'fcn_plotRoad_animatePlot_plotLLI_global.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotLLI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
    set(gca,'ZoomLevelMode','auto','MapCenterMode','auto');
    entireZoom = get(gca,'ZoomLevel');
    entireCenter = get(gca,'MapCenter');


    for ith_time = 1:500:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotLLI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        set(gca,'ZoomLevel',entireZoom,'MapCenter',entireCenter);

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end


%% fcn_plotRoad_animatePlot - plotLL specifying the full plotFormat
fig_num = 6;
figure(fig_num);
clf;

% Fill in data
% Check to see if XY data for the centerline of the original track lane was loaded earlier
mat_filename = fullfile(cd,'Data','Centerline_OriginalTrackLane_InnerMarkerClusterCenterOfDoubleYellow.mat');
if exist(mat_filename,'file')
    load(mat_filename,'XY_data');
end

% Prep for GPS conversions
% The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
reference_latitude = 40.86368573;
reference_longitude = -77.83592832;
reference_altitude = 344.189;
gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class

Npoints = length(XY_data(:,1));
LLA_positions_matrix =  gps_object.ENU2WGSLLA([XY_data zeros(Npoints,1)]);

time = linspace(0,10,Npoints)';
plotData = [LLA_positions_matrix(:,1), LLA_positions_matrix(:,2), sin(time)];


% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 20;
plotFormat.Color = [1 0 1];

reducedColorMap = [];

h_animatedPlot = fcn_plotRoad_animatePlot('plotLL', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotLL specifying the full plotFormat',fig_num), 'Interpreter','none');

for ith_time = 1:100:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotLL', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
    set(gca,'ZoomLevel',20,'MapCenter',plotData(ith_time,1:2));
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));

%%%%%
% Create an animated GIF with "following"?
if 1==0
    timeDelay = 0.2;
    filename = 'fcn_plotRoad_animatePlot_plotLL_follow.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotLL', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));

    for ith_time = 1:500:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotLL', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        set(gca,'ZoomLevel',18.5,'MapCenter',plotData(ith_time,1:2));

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end

%%%%
% Create an animated GIF with "global view"?
if 1==0
    timeDelay = 0.2;
    filename = 'fcn_plotRoad_animatePlot_plotLL_global.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotLL', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
    set(gca,'ZoomLevelMode','auto','MapCenterMode','auto');
    entireZoom = get(gca,'ZoomLevel');
    entireCenter = get(gca,'MapCenter');


    for ith_time = 1:500:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotLL', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        set(gca,'ZoomLevel',entireZoom,'MapCenter',entireCenter);

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end

%% fcn_plotRoad_animatePlot - plotXYI specifying the full plotFormat
fig_num = 7;
figure(fig_num);
clf;

% Fill in data
% Check to see if XY data for the centerline of the original track lane was loaded earlier
mat_filename = fullfile(cd,'Data','Centerline_OriginalTrackLane_InnerMarkerClusterCenterOfDoubleYellow.mat');
if exist(mat_filename,'file')
    load(mat_filename,'XY_data');
end

% % Prep for GPS conversions
% % The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
% reference_latitude = 40.86368573;
% reference_longitude = -77.83592832;
% reference_altitude = 344.189;
% gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class
% 
% Npoints = length(XY_data(:,1));
% LLA_positions_matrix =  gps_object.ENU2WGSLLA([XY_data zeros(Npoints,1)]);

time = linspace(0,10,Npoints)';
plotData = [XY_data(:,1), XY_data(:,2), sin(time)];


% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 20;

% Fill in large colormap data
colorMapMatrix = colormap('parula');

% Reduce the colormap
Ncolors = 100;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, -1);


h_animatedPlot = fcn_plotRoad_animatePlot('plotXYI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotXYI specifying the full plotFormat',fig_num), 'Interpreter','none');

for ith_time = 1:100:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotXYI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
    set(gca,'XLim',plotData(ith_time,1)*[1 1]+[-100 100],'YLim',plotData(ith_time,2)*[1 1]+[-100 100]);
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));

%%%%
% Create an animated GIF with "following"?
if 1==0
    timeDelay = 0.05;
    filename = 'fcn_plotRoad_animatePlot_plotXYI_follow.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotXYI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
    title(sprintf('Example %.0d: showing animated plotXY specifying the full plotFormat, in following mode',fig_num), 'Interpreter','none');

    for ith_time = 1:100:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotXYI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        set(gca,'XLim',plotData(ith_time,1)*[1 1]+[-100 100],'YLim',plotData(ith_time,2)*[1 1]+[-100 100]);

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end

%%%%
% Create an animated GIF with "global view"?
if 1==0
    timeDelay = 0.05;
    filename = 'fcn_plotRoad_animatePlot_plotXYI_global.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotXYI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
    title(sprintf('Example %.0d: showing animated plotXY specifying the full plotFormat, in global mode',fig_num), 'Interpreter','none');

    entireAxis = axis;


    for ith_time = 1:100:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotXYI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        axis(entireAxis);

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end


%% fcn_plotRoad_animatePlot - plotXY specifying the full plotFormat
fig_num = 8;
figure(fig_num);
clf;

% Fill in data
% Check to see if XY data for the centerline of the original track lane was loaded earlier
mat_filename = fullfile(cd,'Data','Centerline_OriginalTrackLane_InnerMarkerClusterCenterOfDoubleYellow.mat');
if exist(mat_filename,'file')
    load(mat_filename,'XY_data');
end

% % Prep for GPS conversions
% % The true location of the track base station is [40.86368573°, -77.83592832°, 344.189 m].
% reference_latitude = 40.86368573;
% reference_longitude = -77.83592832;
% reference_altitude = 344.189;
% gps_object = GPS(reference_latitude,reference_longitude,reference_altitude); % Load the GPS class
% 
% Npoints = length(XY_data(:,1));
% LLA_positions_matrix =  gps_object.ENU2WGSLLA([XY_data zeros(Npoints,1)]);

time = linspace(0,10,Npoints)';
plotData = [XY_data(:,1), XY_data(:,2), sin(time)];


% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 20;
plotFormat.Color = [1 0 1];

reducedColorMap = [];

h_animatedPlot = fcn_plotRoad_animatePlot('plotXY', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotXY specifying the full plotFormat',fig_num), 'Interpreter','none');

for ith_time = 1:100:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotXY', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
    set(gca,'XLim',plotData(ith_time,1)*[1 1]+[-100 100],'YLim',plotData(ith_time,2)*[1 1]+[-100 100]);
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));

%%%%%
% Create an animated GIF with "following"?
if 1==0
    timeDelay = 0.2;
    filename = 'fcn_plotRoad_animatePlot_plotXY_follow.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotXY', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));

    for ith_time = 1:500:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotXY', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        set(gca,'XLim',plotData(ith_time,1)*[1 1]+[-100 100],'YLim',plotData(ith_time,2)*[1 1]+[-100 100]);

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end

%%%%
% Create an animated GIF with "global view"?
if 1==0
    timeDelay = 0.2;
    filename = 'fcn_plotRoad_animatePlot_plotXY_global.gif';
    flagFirstTime = 1;

    figure(fig_num);
    clf;

    h_animatedPlot = fcn_plotRoad_animatePlot('plotXY', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
    entireAxis = axis;


    for ith_time = 1:500:length(plotData(:,1))
        fcn_plotRoad_animatePlot('plotXY', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
        axis(entireAxis);

        % Create an animated gif
        frame = getframe(gcf);
        current_image = frame2im(frame);
        [A,map] = rgb2ind(current_image,256);
        if flagFirstTime == 1
            imwrite(A,map,filename,"gif","LoopCount",Inf,"DelayTime",timeDelay);
            flagFirstTime = 0;
        else
            imwrite(A,map,filename,"gif","WriteMode","append","DelayTime",timeDelay);
        end

        pause(0.02);
    end
end

%% Supporting functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   _____                              _   _                 ______                _   _
%  / ____|                            | | (_)               |  ____|              | | (_)
% | (___  _   _ _ __  _ __   ___  _ __| |_ _ _ __   __ _    | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  \___ \| | | | '_ \| '_ \ / _ \| '__| __| | '_ \ / _` |   |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  ____) | |_| | |_) | |_) | (_) | |  | |_| | | | | (_| |   | |  | |_| | | | | (__| |_| | (_) | | | \__ \
% |_____/ \__,_| .__/| .__/ \___/|_|   \__|_|_| |_|\__, |   |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%              | |   | |                            __/ |
%              |_|   |_|                           |___/
% See:
% https://patorjk.com/software/taag/#p=display&f=Big&t=Supporting%20%20%20Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§

%% fcn_plotRoad_calcRectangleXYZ in 2D
% finds the XY(Z) corners of a rectangle
% cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num))
fig_num = 11;
figure(fig_num);
clf;


centerPointXYZ = [0 0];
LWH = [4 2];
yawAngle = 45*pi/180;
centerOffsetLWH = [2 1];

cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
title(sprintf('Example %.0d: basic rectangle',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

assert(length(cornersXYZ(:,1))==5);
assert(length(cornersXYZ(1,:))==2);
assert(isequal(round(cornersXYZ,4),[...
    0         0
    2.8284    2.8284
    1.4142    4.2426
    -1.4142    1.4142
    0         0]));


%% fcn_plotRoad_calcRectangleXYZ in 3D
% finds the XY(Z) coordinates of a rectangle
% cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num))
fig_num = 12;
figure(fig_num);
clf;


centerPointXYZ = [0 0 0];
LWH = [4 2 1];
yawAngle = 45*pi/180;
centerOffsetLWH = [2 1 0.5];

cornersXYZ = fcn_plotRoad_calcRectangleXYZ(centerPointXYZ, LWH, (yawAngle), (centerOffsetLWH), (fig_num));
title(sprintf('Example %.0d: basic rectangle',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

assert(length(cornersXYZ(:,1))==5*6);
assert(length(cornersXYZ(1,:))==3);
assert(isequal(round(cornersXYZ,4),[...
    0         0         0
    -1.4142    1.4142         0
    1.4142    4.2426         0
    2.8284    2.8284         0
    0         0         0
    0         0         0
    0         0    1.0000
    -1.4142    1.4142    1.0000
    -1.4142    1.4142         0
    0         0         0
    0         0         0
    2.8284    2.8284         0
    2.8284    2.8284    1.0000
    0         0    1.0000
    0         0         0
    0         0    1.0000
    2.8284    2.8284    1.0000
    1.4142    4.2426    1.0000
    -1.4142    1.4142    1.0000
    0         0    1.0000
    2.8284    2.8284    1.0000
    2.8284    2.8284         0
    1.4142    4.2426         0
    1.4142    4.2426    1.0000
    2.8284    2.8284    1.0000
    1.4142    4.2426    1.0000
    -1.4142    1.4142    1.0000
    -1.4142    1.4142         0
    1.4142    4.2426         0
    1.4142    4.2426    1.0000]));



%% fcn_plotRoad_breakArrayByNans% 
% breaks data separated by nan into subdata
% indicies_cell_array = fcn_plotRoad_breakArrayByNans(input_array, (fig_num))

test_data = [1; 2; 3; 4; nan; 6; nan; 8; 9; nan(3,1)];
indicies_cell_array = fcn_plotRoad_breakArrayByNans(test_data);
assert(isequal(indicies_cell_array{1},[1; 2; 3; 4]));
assert(isequal(indicies_cell_array{2},6));
assert(isequal(indicies_cell_array{3},[8; 9]));

%% fcn_plotRoad_plotTraceXY
% plots EN components of ENU data as a trace
% h_plot = fcn_plotRoad_plotTraceXY(XYdata, (plotFormat), (flag_plot_headers_and_tailers), (fig_num))

% Load the first marker cluster - call it by name
fig_num = 13;
figure(fig_num);
clf;

plotFormat = [];
flag_plot_headers_and_tailers = [];

% load from data
ENU_positions_cell_array{1} = 1.0e+02 *[

-0.681049494040000  -1.444101004200000   0.225959982543000
-0.635840916402000  -1.480360972130000   0.225959615156000
-0.591458020164000  -1.513620272760000   0.225949259327000
-0.526826099435000  -1.557355626820000   0.226468769561000
-0.455230413850000  -1.601954836740000   0.226828212563000
-0.378844266810000  -1.644026018910000   0.227087638509000
-0.302039949257000  -1.680678797970000   0.227207090339000
-0.217481846757000  -1.715315663660000   0.227336509752000
-0.141767378277000  -1.742610853740000   0.227585981357000
-0.096035753167200  -1.756950994360000   0.227825672033000
];

ENU_positions_cell_array{2} = 1.0e+02 *[

-0.096035753167200  -1.756950994360000   0.227825672033000
-0.046217812938600  -1.771005260420000   0.227995337636000
0.025700956316500  -1.787638230440000   0.228144884542000
0.098357974826600  -1.800501473440000   0.228144450639000
0.177152561887000  -1.810690305340000   0.228123991965000
0.273236198681000  -1.817654871680000   0.228263454451000
0.364501910235000  -1.819114777210000   0.228492957384000
0.478769749755000  -1.813569236680000   0.228312361316000
0.578252405450000  -1.801635770890000   0.228621877252000
0.673410108325000  -1.783910295550000   0.228621444283000
0.781523906444000  -1.756930070190000   0.228470963597000
0.889917048000000  -1.721948466680000   0.228650501826000
0.992406509804000  -1.681063720990000   0.228310085456000
1.103055017650000  -1.628270864690000   0.228849643172000
1.239723948340000  -1.548705836180000   0.229439122979000
1.339251709010000  -1.483153008740000   0.230088675427000
];

ENU_positions_cell_array{3} = 1.0e+02 *[

1.339251709010000  -1.483153008740000   0.230088675427000
1.390220496380000  -1.447536755330000   0.230688406825000
1.500649039670000  -1.366687645210000   0.231947695749000
1.619936232260000  -1.276276969780000   0.232946659694000
1.658497814730000  -1.246290733430000   0.232756264199000
1.726179576070000  -1.194134129080000   0.233285471766000
1.794279852100000  -1.141732303180000   0.233674556691000
1.843697046830000  -1.103673506040000   0.233793821086000
1.910881897570000  -1.051369238160000   0.233222732062000
1.977969375100000  -1.000036991350000   0.234591516738000
2.068718586050000  -0.930372260841000   0.234979699947000
2.156970005120000  -0.862078062070000   0.235407742313000
2.250276408100000  -0.790321941946000   0.235655454741000
2.325942215980000  -0.732634183262000   0.235873435191000
2.399021146270000  -0.676636598005000   0.236361352612000
2.474931357600000  -0.618332934789000   0.236659049556000
2.549576311420000  -0.561057731254000   0.236856644300000
2.619865592130000  -0.506750602539000   0.237104255992000
2.678747493610000  -0.461078483932000   0.237282161108000
2.733351558350000  -0.418913036557000   0.237370139513000
2.817368600250000  -0.354774607364000   0.237136878544000
2.890132472030000  -0.298398935810000   0.238023917403000
2.958342902630000  -0.245730396869000   0.238551020311000
3.022800229050000  -0.195952921879000   0.238668175184000
3.090309635410000  -0.143496389415000   0.239285083890000
3.154853774550000  -0.093981341725300   0.239102022359000
3.228508266550000  -0.037237819080300   0.239008399590000
3.294531008890000   0.013364746657600   0.239325038737000
3.347855324030000   0.054476705490200   0.239382243889000
3.410794169220000   0.102364292519000   0.240278855067000
3.489861812030000   0.162838824587000   0.240064458640000
3.560042302360000   0.216146186620000   0.240130428855000
3.638139977820000   0.275334615114000   0.240585802681000
3.721450737040000   0.339180331666000   0.240930689915000
3.809597399650000   0.406379169292000   0.241165100709000
3.900050945570000   0.475638580737000   0.241129163056000
3.982613892930000   0.538223979629000   0.241263570378000
4.061187445720000   0.599298131740000   0.241768075210000
];

ENU_positions_cell_array{4} = 1.0e+02 *[

4.061187445720000   0.599298131740000   0.241768075210000
4.151958465970000   0.672552042441000   0.241971507236000
4.240694971640000   0.751542411688000   0.242794794590000
4.312200354840000   0.825206523025000   0.242829094571000
4.373338107310000   0.895670512718000   0.243033985961000
4.437267496340000   0.980974659389000   0.243898317745000
4.498262514620000   1.079682605530000   0.245192453662000
4.548525556310000   1.193543635030000   0.246706860636000
4.577024497810000   1.296471982690000   0.248232811363000
4.592437993220000   1.394261623260000   0.249939637162000
4.598790818700000   1.506113691290000   0.250706630741000
];

ENU_positions_cell_array{5} =  1.0e+02 *[
    4.598790818700000   1.506113691290000   0.250706630741000
    4.596661110239999   1.568128878250000   0.251335285541000
    4.583246426620000   1.675270749070000   0.252583519421000
    4.561186217190000   1.769497222660000   0.253722548098000
    4.525806593920000   1.867642539130000   0.254812259350000
    4.485891020010000   1.948186043530000   0.255902659702000
    4.420143114050000   2.050532875340000   0.257284028077000];


% Plot ENU cell array
h_plot = fcn_plotRoad_plotTraceXY(ENU_positions_cell_array, (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

title(sprintf('Fig %.0d: showing plot of entire cell array in ENU',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

assert(all(ishandle(h_plot)));

%% fcn_plotRoad_plotTraceLL
% plots LL components of LLA data as a trace
% h_plot = fcn_plotRoad_plotTraceLL(LLdata, (plotFormat), (flag_plot_headers_and_tailers), (fig_num))

% Load the first marker cluster - call it by name
fig_num = 14;
figure(fig_num);
clf;

flag_plot_headers_and_tailers = 1;

clear plotFormat
plotFormat.Color = [0 0 1];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 5;

LLA_positions_cell_array{1} = 1.0e+02 *[
    0.408623854107731  -0.778367360663248   3.667869999985497
    0.408623527614556  -0.778366824471459   3.667869999850096
    0.408623228140075  -0.778366298073317   3.667860000095597
    0.408622834336925  -0.778365531515185   3.668379999958485
    0.408622432755178  -0.778364682365638   3.668739999760671
    0.408622053936209  -0.778363776401051   3.669000000069386
    0.408621723905615  -0.778362865478155   3.669120000111036
    0.408621412026466  -0.778361862594228   3.669249999930642
    0.408621166253217  -0.778360964599280   3.669500000276769
    0.408621037130544  -0.778360422209667   3.669740000166511
    ];

LLA_positions_cell_array{2} = 1.0e+02 *[
    0.408621037130544  -0.778360422209667   3.669740000166511
    0.408620910581732  -0.778359831355492   3.669909999911038
    0.408620760813066  -0.778358978379926   3.670060000357283
    0.408620644987599  -0.778358116648858   3.670059999702186
    0.408620553242639  -0.778357182124869   3.670040000064136
    0.408620490528764  -0.778356042548437   3.670179999861086
    0.408620477379800  -0.778354960113735   3.670410000100996
    0.408620527307769  -0.778353604867370   3.670229999998058
    0.408620634754331  -0.778352424976358   3.670540000052632
    0.408620794353143  -0.778351296379382   3.670539999995281
    0.408621037282434  -0.778350014117954   3.670389999900177
    0.408621352257419  -0.778348728541404   3.670570000009770
    0.408621720385415  -0.778347512981890   3.670230000461088
    0.408622195735826  -0.778346200650471   3.670770000265628
    0.408622912146380  -0.778344579701966   3.671360000088283
    0.408623502390288  -0.778343399258920   3.672010000005752
    ];

LLA_positions_cell_array{3} = 1.0e+02 *[
    0.408623502390288  -0.778343399258920   3.672010000005752
    0.408623823082493  -0.778342794745478   3.672610000179001
    0.408624551055474  -0.778341485008913   3.673870000077450
    0.408625365120639  -0.778340070200358   3.674870000165449
    0.408625635118899  -0.778339612838710   3.674679999876076
    0.408626104740356  -0.778338810095173   3.675210000424097
    0.408626576569184  -0.778338002386662   3.675600000155037
    0.408626919252242  -0.778337416269483   3.675720000282946
    0.408627390201705  -0.778336619415988   3.675150000059706
    0.408627852398521  -0.778335823717256   3.676519999448042
    0.408628479660438  -0.778334747373473   3.676910000483610
    0.408629094581277  -0.778333700652997   3.677340000033700
    0.408629740672029  -0.778332593975040   3.677589999674629
    0.408630260090558  -0.778331696525266   3.677810000180061
    0.408630764290284  -0.778330829756372   3.678300000336009
    0.408631289253163  -0.778329929404911   3.678600000067062
    0.408631804955124  -0.778329044058944   3.678799999808977
    0.408632293932271  -0.778328210373197   3.679050000024036
    0.408632705160062  -0.778327511986843   3.679229999953498
    0.408633084813624  -0.778326864338324   3.679320000010756
    0.408633662308712  -0.778325867826726   3.679089999563726
    0.408634169908534  -0.778325004785828   3.679979999874208
    0.408634644129081  -0.778324195751327   3.680510000226133
    0.408635092318332  -0.778323431230610   3.680630000091892
    0.408635564629046  -0.778322630508557   3.681249999269378
    0.408636010454227  -0.778321864956050   3.681070000551346
    0.408636521362880  -0.778320991345114   3.680979999523698
    0.408636976978745  -0.778320208253084   3.681300000269231
    0.408637347142726  -0.778319575775352   3.681359999872883
    0.408637778312331  -0.778318829260005   3.682259999770026
    0.408638322811597  -0.778317891439188   3.682050000253030
    0.408638802778403  -0.778317059027921   3.682120002045467
    0.408639335696130  -0.778316132709792   3.682580004820194
    0.408639910546490  -0.778315144557028   3.682929999704857
    0.408640515586353  -0.778314099043665   3.683170000405118
    0.408641139178260  -0.778313026165848   3.683140001454500
    0.408641702677991  -0.778312046877916   3.683280001693282
    0.408642252571069  -0.778311114906378   3.683789999701637
    ];

LLA_positions_cell_array{4} = 1.0e+02 *[
    0.408642252571069  -0.778311114906378   3.683789999701637
    0.408642912127771  -0.778310038255036   3.683999999414922
    0.408643623337391  -0.778308985728842   3.684830000158788
    0.408644286595829  -0.778308137576304   3.684869999998250
    0.408644921044209  -0.778307412391722   3.685080000765020
    0.408645689116139  -0.778306654084958   3.685949999411057
    0.408646577881266  -0.778305930570878   3.687249999828023
    0.408647603095110  -0.778305334333136   3.688770000000163
    0.408648529879331  -0.778304996240297   3.690300000315188
    0.408649410400107  -0.778304813353941   3.692009999976025
    0.408650417548742  -0.778304737922569   3.692779999766870
    ];

LLA_positions_cell_array{5} = 1.0e+02 *[
    0.408650417548742  -0.778304737922569   3.692779999766870
    0.408650975954674  -0.778304763137331   3.693409999348094
    0.408651940702053  -0.778304922168343   3.694659999904711
    0.408652789159778  -0.778305183752297   3.695800000069042
    0.408653672911305  -0.778305603313501   3.696889999769326
    0.408654398172712  -0.778306076688765   3.697979999465836
    0.408655319771976  -0.778306856443722   3.699360000198093
    ];

% Plot ENU cell array
h_plot = fcn_plotRoad_plotTraceLL(LLA_positions_cell_array, (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

title(sprintf('Fig %.0d: showing flag_plot_headers_and_tailers',fig_num), 'Interpreter','none');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

assert(all(ishandle(h_plot)));

%% fcn_plotRoad_plotTraces
% plots traces in LLA, ENU, and/or STH coords given one of three formats,
% returning all formats
%       [LLA_trace, ENU_trace, STH_trace]  = fcn_plotRoad_plotTraces(...
%          Trace_coordinates, input_coordinates_type,...
%          (plotFormat),...
%          (reference_unit_tangent_vector),...
%          (flag_plot_headers_and_tailers),...
%          (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

% input LLA coordinates and plot all traces
% FieldMeasurements_OriginalTrackLane_OuterMarkerClusterSolidWhite_1

Trace_coordinates = 1.0e+02 *[

0.408623854107731  -0.778367360663248   3.667869999985497
0.408623527614556  -0.778366824471459   3.667869999850096
0.408623228140075  -0.778366298073317   3.667860000095597
0.408622834336925  -0.778365531515185   3.668379999958485
0.408622432755178  -0.778364682365638   3.668739999760671
0.408622053936209  -0.778363776401051   3.669000000069386
0.408621723905615  -0.778362865478155   3.669120000111036
0.408621412026466  -0.778361862594228   3.669249999930642
0.408621166253217  -0.778360964599280   3.669500000276769
0.408621037130544  -0.778360422209667   3.669740000166511
];

clear plotFormat
plotFormat.Color = [1 1 1];
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;


input_coordinates_type = "LLA";
LLA_fig_num = 1111;
ENU_fig_num = 2222;
STH_fig_num = 3333;
reference_unit_tangent_vector =[];
flag_plot_headers_and_tailers =[];

fcn_plotRoad_plotTraces(...
    Trace_coordinates, input_coordinates_type,...
    (plotFormat),...
    (reference_unit_tangent_vector),...
    (flag_plot_headers_and_tailers),...
    (LLA_fig_num), (ENU_fig_num), (STH_fig_num));

% Was a figure created?
assert(all(ishandle(LLA_fig_num)));
assert(all(ishandle(ENU_fig_num)));
assert(all(ishandle(STH_fig_num)));


%% fcn_plotRoad_calcLaneBoundaries
% calculates left and right lane boundaries by projecting a fixed distance from XYdata
% [leftLaneBoundary_XY, rightLaneBoundary_XY] = fcn_plotRoad_calcLaneBoundaries(XYdata, (projectionDistance), (fig_num))


fig_num = 900;
figure(fig_num);
clf;

% Load data (from the following, in the plotCV2X library)
% csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
% [XYdata, tENU] = fcn_plotCV2X_loadDataFromFile(csvFile, (-1));
% disp(tENU(:,2:3))

load(cat(2,'Data',filesep,'SampleCV2XData.mat'),'XYdata');

% Test the function
csvFile = 'TestTrack_PendulumRSU_InstallTest_OuterLane1_2024_08_09.csv'; % Path to your CSV file
projectionDistance = [];
[leftLaneBoundary_XY, rightLaneBoundary_XY] = fcn_plotRoad_calcLaneBoundaries(XYdata, (projectionDistance), (fig_num));
title(sprintf('Example of fcn_plotRoad_calcLaneBoundaries'), 'Interpreter','none','FontSize',12);
subtitle(sprintf('File: %s',csvFile), 'Interpreter','none','FontSize',12);

% Was a figure created?
assert(all(ishandle(fig_num)));

% Does the data have 2 columns?
assert(length(leftLaneBoundary_XY(1,:))== 2)
assert(length(rightLaneBoundary_XY(1,:))== 2)

% Do both have same number of rows?
assert(length(leftLaneBoundary_XY(:,1)) == length(rightLaneBoundary_XY(:,1)))

% Do both have same number of rows as input data?
assert(length(leftLaneBoundary_XY(:,1)) == length(XYdata(:,1)))

% Check that a figure was created
assert(all(ishandle(fig_num)));

%% fcn_plotRoad_calcLaneBoundingBox
% generates polyshape bounding box of lane
% boundingBoxXY = fcn_plotRoad_calcLaneBoundingBox(leftLaneBoundary_XY, rightLaneBoundary_XY, (fig_num))

fig_num = 901;
figure(fig_num);

% Create data
xData = linspace(-2,20,100)';
yData = 2*xData+4;
XYdata = [xData yData];
[leftLaneBoundary_XY, rightLaneBoundary_XY] = fcn_plotRoad_calcLaneBoundaries(XYdata, (projectionDistance), (-1));

% Test the function
boundingBoxPolyshape = fcn_plotRoad_calcLaneBoundingBox(leftLaneBoundary_XY, rightLaneBoundary_XY, (fig_num));
title(sprintf('Example of fcn_plotRoad_calcLaneBoundingBox'), 'Interpreter','none','FontSize',12);

% Was a figure was created?
assert(all(ishandle(fig_num)));

% Does the boundingBoxPolyshape.Verticies have 2 columns?
assert(length(boundingBoxPolyshape.Vertices(1,:))== 2);

% Does boundingBoxPolyshape.Verticies have same number of rows?
assert(length(boundingBoxPolyshape.Vertices(:,1))==2*length(XYdata(:,1)));

% Does boundingBoxPolyshape.NumRegions have 1 region and 0 holes?
assert(1 == boundingBoxPolyshape.NumRegions)
assert(0 == boundingBoxPolyshape.NumHoles)


%% fcn_plotRoad_plotLLcircle    
% geoplots a circle
% [h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LL_center, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num))
fig_num = 902;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
plotFormat = 'r';
colorMapStringOrMatrix = [];
maxColorsAngles = [];
[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing color string');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot(:))));

Ncolors = 1;
Nangles = 91;

% Are the dimensions of Lat Long data correct?
assert(Ncolors==length(AllLatData(:,1)));
assert(Ncolors==length(AllLonData(:,1)));
assert(Nangles==length(AllLonData(1,:)));
assert(length(AllLatData(1,:))==length(AllLonData(1,:)));

% Are the dimension of X Y data correct?
assert(Ncolors==length(AllXData(:,1)));
assert(Ncolors==length(AllYData(:,1)));
assert(length(AllXData(1,:))==length(AllYData(1,:)));
assert(length(AllXData(1,:))==length(AllLatData(1,:)));

% Are the dimensions of the ringColors correct?
assert(isequal(size(ringColors),[Ncolors 3]));



%% fcn_plotRoad_reduceColorMap 
% produces a reduced colorMap matrix
%
% This function creates a reduced-sized colorMap matrix from a given
% colorMap matrix and a user-input number of colors to keep. The method of
% reduction is to create an evenly divided list of numbers from 1:M, and
% divide it into Ncolors of numbers, then round to the nearest integer.
% This integer defines which color to use in the reduced colormap. The
% first color of the input colorMap is always preserved.
%
% NOTE: if the number of colors requested is larger than the original
% colormap, the colormap is streteched but NOT resampled so that the number
% of colors requested is always equal to the input Ncolors.
%
%      reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, (fig_num))

fig_num = 904;
figure(fig_num);
clf;

% Fill in large colormap data
colorMapMatrix = colormap('winter');

% Reduce the colormap
Ncolors = 4;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, fig_num);
sgtitle(sprintf('Example %.0d: fcn_plotRoad_reduceColorMap',fig_num), 'Interpreter','none');
% subtitle('Showing user-defined reductin of color map dimension');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of Lat reducedColorMap correct?
assert(Ncolors==length(reducedColorMap(:,1)));
assert(3==length(reducedColorMap(1,:)));

%% Functions follow
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ______                _   _
%  |  ____|              | | (_)
%  | |__ _   _ _ __   ___| |_ _  ___  _ __  ___
%  |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
%  | |  | |_| | | | | (__| |_| | (_) | | | \__ \
%  |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/
%
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Functions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§


%% function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
function fcn_INTERNAL_clearUtilitiesFromPathAndFolders
% Clear out the variables
clear global flag* FLAG*
clear flag*
clear path

% Clear out any path directories under Utilities
path_dirs = regexp(path,'[;]','split');
utilities_dir = fullfile(pwd,filesep,'Utilities');
for ith_dir = 1:length(path_dirs)
    utility_flag = strfind(path_dirs{ith_dir},utilities_dir);
    if ~isempty(utility_flag)
        rmpath(path_dirs{ith_dir});
    end
end

% Delete the Utilities folder, to be extra clean!
if  exist(utilities_dir,'dir')
    [status,message,message_ID] = rmdir(utilities_dir,'s');
    if 0==status
        error('Unable remove directory: %s \nReason message: %s \nand message_ID: %s\n',utilities_dir, message,message_ID);
    end
end

end % Ends fcn_INTERNAL_clearUtilitiesFromPathAndFolders

%% fcn_INTERNAL_initializeUtilities
function  fcn_INTERNAL_initializeUtilities(library_name,library_folders,library_url,this_project_folders)
% Reset all flags for installs to empty
clear global FLAG*

fprintf(1,'Installing utilities necessary for code ...\n');

% Dependencies and Setup of the Code
% This code depends on several other libraries of codes that contain
% commonly used functions. We check to see if these libraries are installed
% into our "Utilities" folder, and if not, we install them and then set a
% flag to not install them again.

% Set up libraries
for ith_library = 1:length(library_name)
    dependency_name = library_name{ith_library};
    dependency_subfolders = library_folders{ith_library};
    dependency_url = library_url{ith_library};

    fprintf(1,'\tAdding library: %s ...',dependency_name);
    fcn_INTERNAL_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url);
    clear dependency_name dependency_subfolders dependency_url
    fprintf(1,'Done.\n');
end

% Set dependencies for this project specifically
fcn_DebugTools_addSubdirectoriesToPath(pwd,this_project_folders);

disp('Done setting up libraries, adding each to MATLAB path, and adding current repo folders to path.');
end % Ends fcn_INTERNAL_initializeUtilities


function fcn_INTERNAL_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url, varargin)
%% FCN_DEBUGTOOLS_INSTALLDEPENDENCIES - MATLAB package installer from URL
%
% FCN_DEBUGTOOLS_INSTALLDEPENDENCIES installs code packages that are
% specified by a URL pointing to a zip file into a default local subfolder,
% "Utilities", under the root folder. It also adds either the package
% subfoder or any specified sub-subfolders to the MATLAB path.
%
% If the Utilities folder does not exist, it is created.
%
% If the specified code package folder and all subfolders already exist,
% the package is not installed. Otherwise, the folders are created as
% needed, and the package is installed.
%
% If one does not wish to put these codes in different directories, the
% function can be easily modified with strings specifying the
% desired install location.
%
% For path creation, if the "DebugTools" package is being installed, the
% code installs the package, then shifts temporarily into the package to
% complete the path definitions for MATLAB. If the DebugTools is not
% already installed, an error is thrown as these tools are needed for the
% path creation.
%
% Finally, the code sets a global flag to indicate that the folders are
% initialized so that, in this session, if the code is called again the
% folders will not be installed. This global flag can be overwritten by an
% optional flag input.
%
% FORMAT:
%
%      fcn_DebugTools_installDependencies(...
%           dependency_name, ...
%           dependency_subfolders, ...
%           dependency_url)
%
% INPUTS:
%
%      dependency_name: the name given to the subfolder in the Utilities
%      directory for the package install
%
%      dependency_subfolders: in addition to the package subfoder, a list
%      of any specified sub-subfolders to the MATLAB path. Leave blank to
%      add only the package subfolder to the path. See the example below.
%
%      dependency_url: the URL pointing to the code package.
%
%      (OPTIONAL INPUTS)
%      flag_force_creation: if any value other than zero, forces the
%      install to occur even if the global flag is set.
%
% OUTPUTS:
%
%      (none)
%
% DEPENDENCIES:
%
%      This code will automatically get dependent files from the internet,
%      but of course this requires an internet connection. If the
%      DebugTools are being installed, it does not require any other
%      functions. But for other packages, it uses the following from the
%      DebugTools library: fcn_DebugTools_addSubdirectoriesToPath
%
% EXAMPLES:
%
% % Define the name of subfolder to be created in "Utilities" subfolder
% dependency_name = 'DebugTools_v2023_01_18';
%
% % Define sub-subfolders that are in the code package that also need to be
% % added to the MATLAB path after install; the package install subfolder
% % is NOT added to path. OR: Leave empty ({}) to only add
% % the subfolder path without any sub-subfolder path additions.
% dependency_subfolders = {'Functions','Data'};
%
% % Define a universal resource locator (URL) pointing to the zip file to
% % install. For example, here is the zip file location to the Debugtools
% % package on GitHub:
% dependency_url = 'https://github.com/ivsg-psu/Errata_Tutorials_DebugTools/blob/main/Releases/DebugTools_v2023_01_18.zip?raw=true';
%
% % Call the function to do the install
% fcn_DebugTools_installDependencies(dependency_name, dependency_subfolders, dependency_url)
%
% This function was written on 2023_01_23 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history:
% 2023_01_23:
% -- wrote the code originally
% 2023_04_20:
% -- improved error handling
% -- fixes nested installs automatically

% TO DO
% -- Add input argument checking

flag_do_debug = 0; % Flag to show the results for debugging
flag_do_plots = 0; % % Flag to plot the final results
flag_check_inputs = 1; % Flag to perform input checking

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
end


%% check input arguments
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____                   _
%  |_   _|                 | |
%    | |  _ __  _ __  _   _| |_ ___
%    | | | '_ \| '_ \| | | | __/ __|
%   _| |_| | | | |_) | |_| | |_\__ \
%  |_____|_| |_| .__/ \__,_|\__|___/
%              | |
%              |_|
% See: http://patorjk.com/software/taag/#p=display&f=Big&t=Inputs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if flag_check_inputs
    % Are there the right number of inputs?
    narginchk(3,4);
end

%% Set the global variable - need this for input checking
% Create a variable name for our flag. Stylistically, global variables are
% usually all caps.
flag_varname = upper(cat(2,'flag_',dependency_name,'_Folders_Initialized'));

% Make the variable global
eval(sprintf('global %s',flag_varname));

if nargin==4
    if varargin{1}
        eval(sprintf('clear global %s',flag_varname));
    end
end

%% Main code starts here
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if ~exist(flag_varname,'var') || isempty(eval(flag_varname))
    % Save the root directory, so we can get back to it after some of the
    % operations below. We use the Print Working Directory command (pwd) to
    % do this. Note: this command is from Unix/Linux world, but is so
    % useful that MATLAB made their own!
    root_directory_name = pwd;

    % Does the directory "Utilities" exist?
    utilities_folder_name = fullfile(root_directory_name,'Utilities');
    if ~exist(utilities_folder_name,'dir')
        % If we are in here, the directory does not exist. So create it
        % using mkdir
        [success_flag,error_message,message_ID] = mkdir(root_directory_name,'Utilities');

        % Did it work?
        if ~success_flag
            error('Unable to make the Utilities directory. Reason: %s with message ID: %s\n',error_message,message_ID);
        elseif ~isempty(error_message)
            warning('The Utilities directory was created, but with a warning: %s\n and message ID: %s\n(continuing)\n',error_message, message_ID);
        end

    end

    % Does the directory for the dependency folder exist?
    dependency_folder_name = fullfile(root_directory_name,'Utilities',dependency_name);
    if ~exist(dependency_folder_name,'dir')
        % If we are in here, the directory does not exist. So create it
        % using mkdir
        [success_flag,error_message,message_ID] = mkdir(utilities_folder_name,dependency_name);

        % Did it work?
        if ~success_flag
            error('Unable to make the dependency directory: %s. Reason: %s with message ID: %s\n',dependency_name, error_message,message_ID);
        elseif ~isempty(error_message)
            warning('The %s directory was created, but with a warning: %s\n and message ID: %s\n(continuing)\n',dependency_name, error_message, message_ID);
        end

    end

    % Do the subfolders exist?
    flag_allFoldersThere = 1;
    if isempty(dependency_subfolders{1})
        flag_allFoldersThere = 0;
    else
        for ith_folder = 1:length(dependency_subfolders)
            subfolder_name = dependency_subfolders{ith_folder};

            % Create the entire path
            subfunction_folder = fullfile(root_directory_name, 'Utilities', dependency_name,subfolder_name);

            % Check if the folder and file exists that is typically created when
            % unzipping.
            if ~exist(subfunction_folder,'dir')
                flag_allFoldersThere = 0;
            end
        end
    end

    % Do we need to unzip the files?
    if flag_allFoldersThere==0
        % Files do not exist yet - try unzipping them.
        save_file_name = tempname(root_directory_name);
        zip_file_name = websave(save_file_name,dependency_url);
        % CANT GET THIS TO WORK --> unzip(zip_file_url, debugTools_folder_name);

        % Is the file there?
        if ~exist(zip_file_name,'file')
            error(['The zip file: %s for dependency: %s did not download correctly.\n' ...
                'This is usually because permissions are restricted on ' ...
                'the current directory. Check the code install ' ...
                '(see README.md) and try again.\n'],zip_file_name, dependency_name);
        end

        % Try unzipping
        unzip(zip_file_name, dependency_folder_name);

        % Did this work? If so, directory should not be empty
        directory_contents = dir(dependency_folder_name);
        if isempty(directory_contents)
            error(['The necessary dependency: %s has an error in install ' ...
                'where the zip file downloaded correctly, ' ...
                'but the unzip operation did not put any content ' ...
                'into the correct folder. ' ...
                'This suggests a bad zip file or permissions error ' ...
                'on the local computer.\n'],dependency_name);
        end

        % Check if is a nested install (for example, installing a folder
        % "Toolsets" under a folder called "Toolsets"). This can be found
        % if there's a folder whose name contains the dependency_name
        flag_is_nested_install = 0;
        for ith_entry = 1:length(directory_contents)
            if contains(directory_contents(ith_entry).name,dependency_name)
                if directory_contents(ith_entry).isdir
                    flag_is_nested_install = 1;
                    install_directory_from = fullfile(directory_contents(ith_entry).folder,directory_contents(ith_entry).name);
                    install_files_from = fullfile(directory_contents(ith_entry).folder,directory_contents(ith_entry).name,'*'); % BUG FIX - For Macs, must be *, not *.*
                    install_location_to = fullfile(directory_contents(ith_entry).folder);
                end
            end
        end

        if flag_is_nested_install
            [status,message,message_ID] = movefile(install_files_from,install_location_to);
            if 0==status
                error(['Unable to move files from directory: %s\n ' ...
                    'To: %s \n' ...
                    'Reason message: %s\n' ...
                    'And message_ID: %s\n'],install_files_from,install_location_to, message,message_ID);
            end
            [status,message,message_ID] = rmdir(install_directory_from);
            if 0==status
                error(['Unable remove directory: %s \n' ...
                    'Reason message: %s \n' ...
                    'And message_ID: %s\n'],install_directory_from,message,message_ID);
            end
        end

        % Make sure the subfolders were created
        flag_allFoldersThere = 1;
        if ~isempty(dependency_subfolders{1})
            for ith_folder = 1:length(dependency_subfolders)
                subfolder_name = dependency_subfolders{ith_folder};

                % Create the entire path
                subfunction_folder = fullfile(root_directory_name, 'Utilities', dependency_name,subfolder_name);

                % Check if the folder and file exists that is typically created when
                % unzipping.
                if ~exist(subfunction_folder,'dir')
                    flag_allFoldersThere = 0;
                end
            end
        end
        % If any are not there, then throw an error
        if flag_allFoldersThere==0
            error(['The necessary dependency: %s has an error in install, ' ...
                'or error performing an unzip operation. The subfolders ' ...
                'requested by the code were not found after the unzip ' ...
                'operation. This suggests a bad zip file, or a permissions ' ...
                'error on the local computer, or that folders are ' ...
                'specified that are not present on the remote code ' ...
                'repository.\n'],dependency_name);
        else
            % Clean up the zip file
            delete(zip_file_name);
        end

    end


    % For path creation, if the "DebugTools" package is being installed, the
    % code installs the package, then shifts temporarily into the package to
    % complete the path definitions for MATLAB. If the DebugTools is not
    % already installed, an error is thrown as these tools are needed for the
    % path creation.
    %
    % In other words: DebugTools is a special case because folders not
    % added yet, and we use DebugTools for adding the other directories
    if strcmp(dependency_name(1:10),'DebugTools')
        debugTools_function_folder = fullfile(root_directory_name, 'Utilities', dependency_name,'Functions');

        % Move into the folder, run the function, and move back
        cd(debugTools_function_folder);
        fcn_DebugTools_addSubdirectoriesToPath(dependency_folder_name,dependency_subfolders);
        cd(root_directory_name);
    else
        try
            fcn_DebugTools_addSubdirectoriesToPath(dependency_folder_name,dependency_subfolders);
        catch
            error(['Package installer requires DebugTools package to be ' ...
                'installed first. Please install that before ' ...
                'installing this package']);
        end
    end


    % Finally, the code sets a global flag to indicate that the folders are
    % initialized.  Check this using a command "exist", which takes a
    % character string (the name inside the '' marks, and a type string -
    % in this case 'var') and checks if a variable ('var') exists in matlab
    % that has the same name as the string. The ~ in front of exist says to
    % do the opposite. So the following command basically means: if the
    % variable named 'flag_CodeX_Folders_Initialized' does NOT exist in the
    % workspace, run the code in the if statement. If we look at the bottom
    % of the if statement, we fill in that variable. That way, the next
    % time the code is run - assuming the if statement ran to the end -
    % this section of code will NOT be run twice.

    eval(sprintf('%s = 1;',flag_varname));
end


%% Plot the results (for debugging)?
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   _____       _
%  |  __ \     | |
%  | |  | | ___| |__  _   _  __ _
%  | |  | |/ _ \ '_ \| | | |/ _` |
%  | |__| |  __/ |_) | |_| | (_| |
%  |_____/ \___|_.__/ \__,_|\__, |
%                            __/ |
%                           |___/
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if flag_do_plots

    % Nothing to do!



end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends function fcn_DebugTools_installDependencies

