%% script_test_fcn_plotRoad_animateHandlesDataSlide
% This is a script to exercise the function:
% fcn_plotRoad_animateHandlesDataSlide
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

%% Example 1 - simple points in XY
fig_num = 1;
figure(fig_num);
clf;

% Fill in data
time = linspace(0,15,100)';
ydata = sin(time);

% Fill in some plot handles by plotting the first Ncolor points
Ncolors = 4;
colorMapMatrix = colormap('winter');
reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, -1);
h_plots = zeros(Ncolors,1);

for ith_plot = 1:Ncolors
    dataToPlot = [time(ith_plot,1) ydata(ith_plot,1)];
    h_plots(ith_plot) = fcn_plotRoad_plotXY(dataToPlot, (reducedColorMap(ith_plot,:)), (fig_num));
end
title(sprintf('Example %.0d: fcn_plotRoad_animateHandlesDataSlide',fig_num), 'Interpreter','none');
subtitle('Showing animation of XY data');

%%%% Do the animation 
handleList = h_plots;
Xdata = time;
Ydata = ydata;
afterPlotColor = [];
for timeIndex = 1:400
    fcn_plotRoad_animateHandlesDataSlide(timeIndex, handleList, Xdata, Ydata, (afterPlotColor), (fig_num))
    pause(0.02);
end


%% Example 2 - line segments in XY
fig_num = 2;
figure(fig_num);
clf;

% Fill in data
Npoints = 200;
time = linspace(0,15,Npoints)';
ydata = sin(time);

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
h_plots = zeros(Ncolors,1);
range=4;

for ith_plot = 1:Ncolors
    dataToPlot = [time(ith_plot:ith_plot+range,1) ydata(ith_plot:ith_plot+range,1)];
    plotFormat.Color = reducedColorMap(ith_plot,:);
    h_plots(ith_plot) = fcn_plotRoad_plotXY(dataToPlot, (plotFormat), (fig_num));
end
title(sprintf('Example %.0d: fcn_plotRoad_animateHandlesDataSlide',fig_num), 'Interpreter','none');
subtitle('Showing animation of XY data');

%%%% Do the animation 
handleList = h_plots;
Xdata = time;
Ydata = ydata;
afterPlotColor = [];
for timeIndex = 1:406
    fcn_plotRoad_animateHandlesDataSlide(timeIndex, handleList, Xdata, Ydata, (afterPlotColor), (fig_num))
    pause(0.02);
end

%% Example 3 - points in XY with trail
fig_num = 3;
figure(fig_num);
clf;

% Fill in data
Npoints = 200;
time = linspace(0,15,Npoints)';
ydata = sin(time);

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
h_plots = zeros(Ncolors,1);
range=4;

for ith_plot = 1:Ncolors
    dataToPlot = [time(ith_plot:ith_plot+range,1) ydata(ith_plot:ith_plot+range,1)];
    plotFormat.Color = reducedColorMap(ith_plot,:);
    h_plots(ith_plot) = fcn_plotRoad_plotXY(dataToPlot, (plotFormat), (fig_num));
end
title(sprintf('Example %.0d: fcn_plotRoad_animateHandlesDataSlide',fig_num), 'Interpreter','none');
subtitle('Showing animation of XY data');


handleList = h_plots;
Xdata = time;
Ydata = ydata;
afterPlotColor = [0.5 0.5 0.5];
for timeIndex = 1:406
    fcn_plotRoad_animateHandlesDataSlide(timeIndex, handleList, Xdata, Ydata, (afterPlotColor), (fig_num))
    pause(0.02);
end


%% Example 4 - geoplot XY with trail
fig_num = 4;
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
for timeIndex = 1:40
    fcn_plotRoad_animateHandlesDataSlide(timeIndex, handleList, Xdata, Ydata, (afterPlotColor), (fig_num))
    pause(0.02);
end