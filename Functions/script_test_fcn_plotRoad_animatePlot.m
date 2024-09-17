%% script_test_fcn_plotRoad_animatePlot
% This is a script to exercise the function: fcn_plotRoad_animatePlot
% This function was written on 2023_09_04 by S. Brennan, sbrennan@psu.edu


% Revision history:
% 2023_09_04 - S. Brennan
% -- first write of the code

%% Basic Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   ____            _        ______                           _
%  |  _ \          (_)      |  ____|                         | |
%  | |_) | __ _ ___ _  ___  | |__  __  ____ _ _ __ ___  _ __ | | ___
%  |  _ < / _` / __| |/ __| |  __| \ \/ / _` | '_ ` _ \| '_ \| |/ _ \
%  | |_) | (_| \__ \ | (__  | |____ >  < (_| | | | | | | |_) | |  __/
%  |____/ \__,_|___/_|\___| |______/_/\_\__,_|_| |_| |_| .__/|_|\___|
%                                                      | |
%                                                      |_|
% See: https://patorjk.com/software/taag/#p=display&f=Big&t=Basic%20Example
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%§
% function only plots, has no outputs

%% BASIC example - plotLLI with defaults
fig_num = 1;
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
plotFormat = [];
colorMap = [];
h_animatedPlot = fcn_plotRoad_animatePlot('plotLLI', 0, [], plotData, (plotFormat), (colorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotLLI',fig_num), 'Interpreter','none');

for ith_time = 1:100:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotLLI', ith_time, h_animatedPlot, plotData, (plotFormat), (colorMap), (fig_num));
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));

%% BASIC example - plotLLI with color
fig_num = 2;
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
plotFormat = 'r';
colorMap = [];
h_animatedPlot = fcn_plotRoad_animatePlot('plotLLI', 0, [], plotData, (plotFormat), (colorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotLLI with string color',fig_num), 'Interpreter','none');

for ith_time = 1:100:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotLLI', ith_time, h_animatedPlot, plotData, (plotFormat), (colorMap), (fig_num));
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));

%% BASIC example 3 - plotLLI specifying the colorMap, automating zoom
fig_num = 3;
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
plotFormat = [];

% Fill in large colormap data
colorMapMatrix = colormap('hot');

% Reduce the colormap
Ncolors = 20;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, -1);


h_animatedPlot = fcn_plotRoad_animatePlot('plotLLI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotLLI with colormap',fig_num), 'Interpreter','none');

for ith_time = 1:100:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotLLI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));



%% BASIC example 4 - plotLLI specifying the linestyle
fig_num = 4;
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
plotFormat = '-';

% Fill in large colormap data
colorMapMatrix = colormap('hot');

% Reduce the colormap
Ncolors = 10;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, -1);



h_animatedPlot = fcn_plotRoad_animatePlot('plotLLI', 0, [], plotData, (plotFormat), (reducedColorMap), (fig_num));
title(sprintf('Example %.0d: showing animated plotLLI with string color',fig_num), 'Interpreter','none');

for ith_time = 1:400:length(plotData(:,1))
    fcn_plotRoad_animatePlot('plotLLI', ith_time, h_animatedPlot, plotData, (plotFormat), (reducedColorMap), (fig_num));
    pause(0.02);
end

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_animatedPlot(:))));

%% BASIC example 5 - plotLLI specifying the full plotFormat
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


%% BASIC example 6 - plotLL specifying the full plotFormat
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

%% BASIC example 7 - plotXYI specifying the full plotFormat
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


%% BASIC example 8 - plotXY specifying the full plotFormat
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

%% testing speed of function
% Not applicable - only a plotting function