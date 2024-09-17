%% script_test_fcn_plotRoad_reduceColorMap
% This is a script to exercise the function:
% fcn_plotRoad_reduceColorMap
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

%% Example 1 - convert the "winter" colormap to 4 colors
fig_num = 1;
figure(fig_num);
clf;

% Fill in large colormap data
colorMapMatrix = colormap('winter');

% Reduce the colormap
Ncolors = 4;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, fig_num);

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of Lat reducedColorMap correct?
assert(Ncolors==length(reducedColorMap(:,1)));
assert(3==length(reducedColorMap(1,:)));


%% Example 1 - convert the "winter" colormap to 400 colors (stretching)
fig_num = 1;
figure(fig_num);
clf;

% Fill in large colormap data
colorMapMatrix = colormap('winter');

% Reduce the colormap
Ncolors = 400;
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, fig_num);

% Check results
% Was a figure created?
assert(all(ishandle(fig_num)));

% Are the dimensions of Lat reducedColorMap correct?
assert(Ncolors==length(reducedColorMap(:,1)));
assert(3==length(reducedColorMap(1,:)));




%% testing speed of function
% Fill in large colormap data
colorMapMatrix = colormap('winter');

% Reduce the colormap
Ncolors = 4;

% Speed Test Calculation
fig_num=[];
REPS=5; 
minTimeSlow=Inf;
maxTimeSlow=-Inf;
tic;

% Slow mode calculation
for i=1:REPS
    tstart=tic;
    reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, fig_num);
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
    maxTimeSlow=max(telapsed,maxTimeSlow);
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
    reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, fig_num);

    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
% Fast mode END

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotRoad_reduceColorMap without speed setting (slow) and with speed setting (fast):\n');
    fprintf(1,'N repetitions: %.0d\n',REPS);
    fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
    fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
    fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
    fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
    fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
    fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',maxTimeSlow/minTimeFast);
end

% Assertion on averageTime NOTE: Due to the variance, there is a chance
% that the assertion will fail. 
assert(averageTimeFast<2*averageTimeSlow);