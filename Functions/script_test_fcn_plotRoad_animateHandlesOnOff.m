%% script_test_fcn_plotRoad_animateHandlesOnOff
% This is a script to exercise the function:
% fcn_plotRoad_animateHandlesOnOff.m
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

%% Example 1 - simple points
fig_num = 1;
figure(fig_num);
clf;

% Fill in data
time = linspace(0,15,100)';
ydata = sin(time);
intensity_raw = cos(time);
intensity = (intensity_raw - min(intensity_raw))/(max(intensity_raw) - min(intensity_raw)); 

% Test the function
colormapMatrix = colormap('winter');

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 30;
colorMapStringOrMatrix = colormapMatrix;

% Fill in the plot handles
h_plots = zeros(length(time),1);
for ith_plot = 1:length(time)
    dataToPlot = [time(ith_plot,1) ydata(ith_plot,1) intensity(ith_plot,1)];
    temp = fcn_plotRoad_plotXYI(dataToPlot, (plotFormat), (colorMapStringOrMatrix), (fig_num));
    h_plots(ith_plot) = temp(~isnan(temp));
end

% Resize the axis to full extent
axis auto;

% Freeze it in place
temp = axis;
axis(temp);

title(sprintf('Example %.0d: fcn_plotRoad_animateHandlesOnOff',fig_num), 'Interpreter','none');
subtitle('Showing animation of XYI plot');

%%%% Do the animation 
skipInterval = [];
for timeIndex = 1:400
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_plots, time, ydata, skipInterval,-1);
    pause(0.05);
end


%% Example 2 - line segments
fig_num = 2;
figure(fig_num);
clf;

% Fill in data
time = linspace(0,10,100)';
ydata = sin(time);
intensity_raw = cos(time);
intensity = (intensity_raw - min(intensity_raw))/(max(intensity_raw) - min(intensity_raw)); 

% Test the function
colormapMatrix = colormap('winter');

clear plotFormat
plotFormat.LineStyle = '-';
plotFormat.LineWidth = 3;
plotFormat.Marker = '.';
plotFormat.MarkerSize = 10;
colorMapStringOrMatrix = colormapMatrix;

% Fill in the plot handles
interval = 10;
h_plots = zeros(length(time)-interval,1);
allDataX = zeros(length(time)-interval,interval+1);
allDataY = zeros(length(time)-interval,interval+1);
for ith_plot = 1:length(time)-interval
    range = (ith_plot:ith_plot+interval);
    dataToPlot = [time(range,1) ydata(range,1) intensity(ith_plot,1)*ones(interval+1,1)];    
    temp = fcn_plotRoad_plotXYI(dataToPlot, (plotFormat), (colorMapStringOrMatrix), (fig_num));
    h_plots(ith_plot) = temp(~isnan(temp));

    allDataX(ith_plot,:) = time(range,1)';
    allDataY(ith_plot,:) = ydata(range,1)';
end

% Resize the axis to full extent
axis auto;

% Freeze it in place
temp = axis;
axis(temp);

title(sprintf('Example %.0d: fcn_plotRoad_animateHandlesOnOff',fig_num), 'Interpreter','none');
subtitle('Showing animation of XYI plot');

%%%% Do the animation 
skipInterval = [];
for timeIndex = 1:500
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_plots, allDataX, allDataY, skipInterval,-1);
    pause(0.02);
end

%% Example 7 - Do an animation of expanding rings
fig_num = 7;
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
skipInterval = Nrings/4;

for timeIndex = 1:200
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_geoplot(1:end-1), AllLatData, AllLonData, skipInterval,-1);
    pause(0.02);
end

%% Example 8 - Do an animation of expanding rings with different skip interval
fig_num = 8;
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
    if 1==0
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

%% Example 10 - Animate a "radar" view with one "beam"
fig_num = 10;
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
maxColorsAngles = [1 45];  % Ncolors Nangles
[~, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (-1));

%%%%%% Plot by angles
% NOTE: when plotting by angles, we only need the first and last point, as
% radial projections are just lines
Nangles = length(AllLatData(1,:));
Ncolors = length(ringColors(:,1));

AllLatDataReduced = [LLcenter(1,1)*ones(1,Nangles); AllLatData(end,:)]';
AllLonDataReduced = [LLcenter(1,2)*ones(1,Nangles); AllLonData(end,:)]';

figure(fig_num);
clf;

% Initialize the plot
fcn_plotRoad_plotLL((LLcenter(1,1:2)), (plotFormat), (fig_num));
set(gca,'MapCenter',LLcenter(1,1:2));

% Create a list of handles filled with empty data
h_radar = zeros(Nangles,1);
for ith_angle = 1:Nangles

    % Do the plotting
    h_radar(ith_angle,1)  = fcn_plotRoad_plotLL([nan nan], (tempPlotFormat), (fig_num));
end

%%%%% Peform the animation

%%%% Do the animation 
skipInterval = [];
allNan = nan*AllLatData(1,:);

for timeIndex = 1:100
    fcn_plotRoad_animateHandlesOnOff(timeIndex, h_radar, AllLatDataReduced, AllLonDataReduced, skipInterval,-1);
    pause(0.02);
end



%% Example 9 - Animate a "radar" view with default output

% fig_num = 9;
% figure(fig_num);
% clf;
% 
% % Fill in data
% LLcenter = [40.43073, -79.87261, 0];
% radius = 1000; 
% 
% % Test the function
% colormapMatrix = colormap('winter');
% colormapMatrix = flipud(colormapMatrix);
% 
% clear plotFormat
% plotFormat.LineStyle = '-';
% plotFormat.LineWidth = 3;
% plotFormat.Marker = 'none';
% plotFormat.MarkerSize = 10;
% colorMapStringOrMatrix = colormapMatrix;
% maxColorsAngles = 128;
% [h_geoplot, AllLatData, AllLonData, AllXData, AllYData, ringColors] = fcn_plotRoad_plotLLCircle(LLcenter, radius, (plotFormat), (colorMapStringOrMatrix), (maxColorsAngles), (fig_num));
% title(sprintf('Example %.0d: fcn_plotRoad_plotLLCircle',fig_num), 'Interpreter','none');
% subtitle('Showing radar animation');
% 
% %%%%% Do animation
% % Method: clear all the handles' data, then turn only some of them one in a
% % sequence that is given by timeIndex
% Nfade = 2; 
% 
% for timeIndex = 1:100
%     tempLatData = nan(Nrings,Nangles);
%     tempLonData = nan(Nrings,Nangles);
% 
%     % Fill in fade rings    
%     for ith_fade = 1:Nfade
%         change_index = mod(timeIndex+ith_fade,Nangles-1)+1; % This forces this_index to go from 1 to Nangles-1, repeatedly (note: last angle is a repeat of first)
%         tempLatData(:,change_index) = AllLatData(:,change_index);
%         tempLonData(:,change_index) = AllLonData(:,change_index);
%     end
% 
%     % Update all the plot handles
%     for ith_handle = 1:Nrings-1
%         set(h_geoplot(ith_handle),'LatitudeData',tempLatData(ith_handle,:),'LongitudeData', tempLonData(ith_handle,:));
%     end
% 
% 
% 
%     pause(0.02);
% end

