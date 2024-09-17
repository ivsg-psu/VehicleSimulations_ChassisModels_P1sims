%% script_test_fcn_plotRoad_plotLLCircle
% This is a script to exercise the function:
% fcn_plotRoad_calcLaneBoundaries.m
% This function was written on 2024_08_15 by S. Brennan, sbrennan@psu.edu

close all;

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

%% BASIC example 1 - all defaults
fig_num = 1;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
plotFormat = [];
colorMapStringOrMatrix = [];
maxColorsAngles = [];
[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing basic plotting');

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

%% BASIC example 2 - specifying the color as a string
fig_num = 2;
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



%% BASIC example 3 - specifying the colorMap
fig_num = 3;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
plotFormat = [];
colorMapStringOrMatrix = hot;
maxColorsAngles = [];

[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing color map');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot(:))));

Ncolors = 64;
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


%% BASIC example 4 - specifying the linestyle
fig_num = 4;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
plotFormat = '--';
colorMapStringOrMatrix = hot;
maxColorsAngles = [];

[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing line style');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot(:))));

Ncolors = 64;
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

%% BASIC example 5 - specifying the full plotFormat
fig_num = 5;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 1;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
colorMapStringOrMatrix = 'hot';
maxColorsAngles = [];

[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing full formatted plotting');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot(:))));

Ncolors = 64;
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


%% BASIC example 6 - specifying the color as a fade-out
fig_num = 6;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
plotFormat = [0 0 1];
colorMapStringOrMatrix = [];
maxColorsAngles = [];

[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing color fade-out');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot(:))));

Ncolors = 64;
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

%% BASIC example 7 - changing maxColors
fig_num = 7;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
colormapMatrix = colormap('winter');
colormapMatrix = flipud(colormapMatrix);

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = 'none';
plotFormat.MarkerSize = 10;
colorMapStringOrMatrix = colormapMatrix;
maxColorsAngles = 128;
[h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
subtitle('Showing different max colors');

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Were plot handles returned?
assert(all(ishandle(h_geoplot(:))));

Ncolors = 128;
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



%% Example 10 - Animate a "radar" view with colormap
fig_num = 10;
figure(fig_num);
clf;

% Fill in data
LLcenter = [40.43073, -79.87261, 0];
radius = 1000; 

% Test the function
colormapMatrix = colormap('winter');
colormapMatrix = flipud(colormapMatrix);

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = 'none';
plotFormat.MarkerSize = 10;
colorMapStringOrMatrix = colormapMatrix;
maxColorsAngles = [16 90];
[~, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (-1));

%%%%%% Plot by angles
% NOTE: when plotting by angles, we only need the first and last point, as
% radial projections are just lines
Nangles = length(AllLatData(1,:));
AllLatDataReduced = [LLcenter(1,1)*ones(1,Nangles); AllLatData(end,:)];
AllLonDataReduced = [LLcenter(1,2)*ones(1,Nangles); AllLonData(end,:)];

figure(fig_num);
clf;

Nplots = length(ringColors(:,1));
h_geoplot = fcn_plotRoad_plotLL((LLcenter(1,1:2)), (plotFormat), (fig_num));
set(gca,'MapCenter',LLcenter(1,1:2));

h_colors = zeros(Nplots,1);
for ith_angle = 1:Nplots

    % Append the color to the current plot format
    tempPlotFormat = plotFormat;
    tempPlotFormat.Color = ringColors(Nplots - ith_angle + 1,:);

    % Update the X and Y data to select only the points in this
    % angle
    X_data_selected = AllLatDataReduced(:,ith_angle);
    Y_data_selected = AllLonDataReduced(:,ith_angle);

    % Do the plotting
    h_colors(ith_angle,1)  = fcn_plotRoad_plotLL([X_data_selected Y_data_selected], (tempPlotFormat), (fig_num));
end

%%%%% Peform the animation
angleSkipInterval = Nangles-1;
allNanAngles = nan*AllLatData(:,1);
NfadeColors = length(ringColors(:,1));

if 1==1
    % Method: change the data on only a small set of handles that are
    % always on

    % This "while" method shuts radii on/off using specific indicies. 
    timeIndex = 0;
    while(timeIndex<200)          
        timeIndex = timeIndex+1;
        timeIndexEnd = timeIndex+NfadeColors;
        indicies_on_raw = (timeIndex:timeIndexEnd)';
        indicies_on = mod(indicies_on_raw,Nangles)+1;

        % Change coordinates for rings that are on
        for ith_angle = 1:NfadeColors
            angle_to_change = indicies_on(ith_angle);
            set(h_colors(ith_angle),'LatitudeData',AllLatDataReduced(:,angle_to_change),'LongitudeData', AllLonDataReduced(:,angle_to_change));
        end
        pause(0.02);
    end
end
%% testing speed of function
% Nothing to test - figure number is an argument

% % Fill in data
% data3 = [
%     -77.83108116099999,40.86426763900005,0
%     -77.83098509099995,40.86432365200005,0
%     -77.83093857199998,40.86435301300003,0
%     -77.83087253399998,40.86439877000004,0
%     -77.83080882499996,40.86444684500003,0
%     -77.83075077399997,40.86449883100005,0
%     -77.83069596999997,40.86455288200005,0
%     -77.83064856399994,40.86461089600004,0];
% 
% % NOTE: above data is in BAD column order, so we
% % have to manually rearrange it.
% time = linspace(0,10,length(data3(:,1)))';
% LLIdata = [data3(:,2), data3(:,1), time];
% 
% 
% % Test the function
% clear plotFormat
% plotFormat.LineStyle = ':';
% plotFormat.LineWidth = 5;
% plotFormat.Marker = '+';
% plotFormat.MarkerSize = 10;
% colorMap = 'hot';
% 
% % Speed Test Calculation
% fig_num=[];
% REPS=5; minTimeSlow=Inf;
% tic;
% 
% % Slow mode calculation
% for i=1:REPS
%     tstart=tic;
%     h_geoplot = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (maxColors), (fig_num));
%     telapsed=toc(tstart);
%     minTimeSlow=min(telapsed,minTimeSlow);
% end
% averageTimeSlow=toc/REPS;
% % Slow mode END
% 
% close all;
% 
% % Fast Mode Calculation
% fig_num = -1;
% minTimeFast = Inf;
% tic;
% for i=1:REPS
%     tstart = tic;
%     h_geoplot = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (maxColors), (fig_num));
%     telapsed = toc(tstart);
%     minTimeFast = min(telapsed,minTimeFast);
% end
% averageTimeFast = toc/REPS;
% % Fast mode END
% 
% % Display Console Comparison
% if 1==1
%     fprintf(1,'\n\nComparison of fcn_PlotTestTrack_plotTraceENU without speed setting (slow) and with speed setting (fast):\n');
%     fprintf(1,'N repetitions: %.0d\n',REPS);
%     fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
%     fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
%     fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
%     fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
%     fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
%     fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);
% end
% 
% % Assertion on averageTime NOTE: Due to the variance, there is a chance
% % that the assertion will fail. assert(averageTimeFast<2*averageTimeSlow);