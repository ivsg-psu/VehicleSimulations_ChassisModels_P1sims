%% script_test_fcn_plotRoad_plotLLI
% This is a script to exercise the function: fcn_plotRoad_plotLLI
% This function was written on 2023_08_12 by S. Brennan, sbrennan@psu.edu


% Revision history:
% 2023_08_12 - S. Brennan
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

%% BASIC example 1 - all defaults
fig_num = 1;
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
time = linspace(0,10,length(data3(:,1)))';
LLIdata = [data3(:,2), data3(:,1), time];


% Test the function
plotFormat = [];
colorMap = [];
[h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing basic plotting',fig_num), 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_plot(:))));

% Check that the number of indicies matches the amount of data in the plot
for ith_handle = 1:length(h_plot)
    dataPlotted = get(h_plot(ith_handle),'LatitudeData');    
    NumInPlot = length(dataPlotted);
    assert(isequal(NumInPlot,length(indiciesInEachPlot{ith_handle})));
end


%% BASIC example 2 - specifying the color
fig_num = 2;
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
time = linspace(0,10,length(data3(:,1)))';
LLIdata = [data3(:,2), data3(:,1), time];

% Test the function
plotFormat = 'r';
colorMap = [];
[h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing user-defined color to produce colormap',fig_num), 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
assert(all(ishandle(h_plot(:))));

% Check that the number of indicies matches the amount of data in the plot
for ith_handle = 1:length(h_plot)
    dataPlotted = get(h_plot(ith_handle),'LatitudeData');    
    NumInPlot = length(dataPlotted);
    assert(isequal(NumInPlot,length(indiciesInEachPlot{ith_handle})));
end


%% BASIC example 3 - specifying the colorMap
fig_num = 3;
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
time = linspace(0,10,length(data3(:,1)))';
LLIdata = [data3(:,2), data3(:,1), time];

% Test the function
plotFormat = [];
colorMap = 'hot';
[h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing user-defined color map',fig_num), 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
good_indicies = ~isnan(h_plot);
assert(all(ishandle(h_plot(good_indicies,1))));

% Check that the number of indicies matches the amount of data in the plot
for ith_handle = 1:length(h_plot)
    if ~isnan(h_plot(ith_handle))
        dataPlotted = get(h_plot(ith_handle),'LatitudeData');
        NumInPlot = length(dataPlotted);
        assert(isequal(NumInPlot,length(indiciesInEachPlot{ith_handle})));
    end
end



%% BASIC example 4 - specifying the linestyle
fig_num = 4;
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
time = linspace(0,10,length(data3(:,1)))';
LLIdata = [data3(:,2), data3(:,1), time];

% Test the function
plotFormat = '-';
colorMap = 'hot';
[h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing use of a linestyle',fig_num), 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
good_indicies = find(~isnan(h_plot));
assert(all(ishandle(h_plot(good_indicies,1))));

% Check that the number of indicies matches the amount of data in the plot
for ith_handle = 1:length(h_plot)
    if ~isnan(h_plot(ith_handle))
        dataPlotted = get(h_plot(ith_handle),'LatitudeData');
        NumInPlot = length(dataPlotted);
        assert(isequal(NumInPlot,length(indiciesInEachPlot{ith_handle})));
    end
end

%% BASIC example 5 - specifying the full plotFormat
fig_num = 5;
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
time = linspace(0,10,length(data3(:,1)))';
LLIdata = [data3(:,2), data3(:,1), time];

% Test the function
clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 5;
colorMap = 'hot';
[h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
title(sprintf('Example %.0d: showing use of a complex plotFormat',fig_num), 'Interpreter','none');

% Was a figure created?
assert(all(ishandle(fig_num)));

% Check results
good_indicies = find(~isnan(h_plot));
assert(all(ishandle(h_plot(good_indicies,1))));

% Check that the number of indicies matches the amount of data in the plot
for ith_handle = 1:length(h_plot)
    if ~isnan(h_plot(ith_handle))
        dataPlotted = get(h_plot(ith_handle),'LatitudeData');
        NumInPlot = length(dataPlotted);
        assert(isequal(NumInPlot,length(indiciesInEachPlot{ith_handle})));
    end
end


%% testing speed of function


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
time = linspace(0,10,length(data3(:,1)))';
LLIdata = [data3(:,2), data3(:,1), time];


% Test the function
clear plotFormat
plotFormat.LineStyle = ':';
plotFormat.LineWidth = 5;
plotFormat.Marker = '+';
plotFormat.MarkerSize = 10;
colorMap = 'hot';

% Speed Test Calculation
fig_num=[];
REPS=5; minTimeSlow=Inf;
tic;

% Slow mode calculation
for i=1:REPS
    tstart=tic;
    [h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
end
averageTimeSlow=toc/REPS;
% Slow mode END

close all;

% Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
    tstart = tic;
    [h_plot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(LLIdata, (plotFormat),  (colorMap), (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
% Fast mode END

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_PlotTestTrack_plotTraceENU without speed setting (slow) and with speed setting (fast):\n');
    fprintf(1,'N repetitions: %.0d\n',REPS);
    fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
    fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
    fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
    fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
    fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
    fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',minTimeSlow/minTimeFast);
end

% Assertion on averageTime NOTE: Due to the variance, there is a chance
% that the assertion will fail. assert(averageTimeFast<2*averageTimeSlow);