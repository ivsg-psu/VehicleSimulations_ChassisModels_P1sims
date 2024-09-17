%% script_test_fcn_plotRoad_calcLaneBoundingBox
% This is a script to exercise the function:
% fcn_plotRoad_calcLaneBoundingBox.m
% This function was written on 2024_08_16 by S. Brennan, sbrennan@psu.edu


%% test 1 - basic example
fig_num = 1;
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
assert(ishandle(fig_num));

% Does the boundingBoxPolyshape.Verticies have 2 columns?
assert(length(boundingBoxPolyshape.Vertices(1,:))== 2);

% Does boundingBoxPolyshape.Verticies have same number of rows?
assert(length(boundingBoxPolyshape.Vertices(:,1))==2*length(XYdata(:,1)));

% Does boundingBoxPolyshape.NumRegions have 1 region and 0 holes?
assert(1 == boundingBoxPolyshape.NumRegions)
assert(0 == boundingBoxPolyshape.NumHoles)





%% test 2 - basic example, no figure
fig_num = 2;
figure(fig_num);
close(fig_num);

% Create data
xData = linspace(-2,20,100)';
yData = 2*xData+4;
XYdata = [xData yData];
[leftLaneBoundary_XY, rightLaneBoundary_XY] = fcn_plotRoad_calcLaneBoundaries(XYdata, (projectionDistance), (-1));

% Test the function
boundingBoxPolyshape = fcn_plotRoad_calcLaneBoundingBox(leftLaneBoundary_XY, rightLaneBoundary_XY, ([]));

% Was a figure was created?
assert(~ishandle(fig_num));

% Does the boundingBoxPolyshape.Verticies have 2 columns?
assert(length(boundingBoxPolyshape.Vertices(1,:))== 2);

% Does boundingBoxPolyshape.Verticies have same number of rows?
assert(length(boundingBoxPolyshape.Vertices(:,1))==2*length(XYdata(:,1)));

% Does boundingBoxPolyshape.NumRegions have 1 region and 0 holes?
assert(1 == boundingBoxPolyshape.NumRegions)
assert(0 == boundingBoxPolyshape.NumHoles)



%% Speed test

% Create data
xData = linspace(-2,20,100)';
yData = 2*xData+4;
XYdata = [xData yData];
[leftLaneBoundary_XY, rightLaneBoundary_XY] = fcn_plotRoad_calcLaneBoundaries(XYdata, (projectionDistance), (-1));



fig_num=[];
REPS=5;
minTimeSlow=Inf;
maxTimeSlow=-Inf;
tic;

% Slow mode calculation - code copied from plotVehicleXYZ
for i=1:REPS
    tstart=tic;
    boundingBoxPolyshape = fcn_plotRoad_calcLaneBoundingBox(leftLaneBoundary_XY, rightLaneBoundary_XY, (fig_num));
    telapsed=toc(tstart);
    minTimeSlow=min(telapsed,minTimeSlow);
    maxTimeSlow=max(telapsed,maxTimeSlow);
end
averageTimeSlow=toc/REPS;
% Slow mode END

% Fast Mode Calculation
fig_num = -1;
minTimeFast = Inf;
tic;
for i=1:REPS
    tstart = tic;
    boundingBoxPolyshape = fcn_plotRoad_calcLaneBoundingBox(leftLaneBoundary_XY, rightLaneBoundary_XY, (fig_num));
    telapsed = toc(tstart);
    minTimeFast = min(telapsed,minTimeFast);
end
averageTimeFast = toc/REPS;
% Fast mode END

% Display Console Comparison
if 1==1
    fprintf(1,'\n\nComparison of fcn_plotRoad_calcLaneBoundingBox without speed setting (slow) and with speed setting (fast):\n');
    fprintf(1,'N repetitions: %.0d\n',REPS);
    fprintf(1,'Slow mode average speed per call (seconds): %.5f\n',averageTimeSlow);
    fprintf(1,'Slow mode fastest speed over all calls (seconds): %.5f\n',minTimeSlow);
    fprintf(1,'Fast mode average speed per call (seconds): %.5f\n',averageTimeFast);
    fprintf(1,'Fast mode fastest speed over all calls (seconds): %.5f\n',minTimeFast);
    fprintf(1,'Average ratio of fast mode to slow mode (unitless): %.3f\n',averageTimeSlow/averageTimeFast);
    fprintf(1,'Fastest ratio of fast mode to slow mode (unitless): %.3f\n',maxTimeSlow/minTimeFast);
end
%Assertion on averageTime NOTE: Due to the variance, there is a chance that
%the assertion will fail.
assert(averageTimeFast<2*averageTimeSlow);

