function h_animatedPlot = fcn_plotRoad_animatePlot(plotTypeString, timeIndex, h_animatedPlot, plotData, varargin)
%fcn_plotRoad_animatePlot    creates animations of various plot types
% 
% FORMAT:
%
%      h_animatedPlot = fcn_plotRoad_animatePlot(plotTypeString, timeIndex, handleList, plotData, (plotFormat), (colorMap), (fig_num))
%
% INPUTS:  
%
%      plotTypeString: a string indicating the type of plot to animate. The
%      string can be one of the following:
%
%             'plotXY' - plots XY data using the plotXY function
%
%             'plotXYI' - plots XY data with intensity using the plotXYI
%             function
%
%             'plotLL' - plots LL data using the plotLL function
%
%             'plotLLI' - plots LL data with intensity using the plotLLI
%             function
%
%      timeIndex: the time index to plot. Values of 0 or less reset the
%      plot and initialize the handles for future plotting. Values of 1, 2,
%      3, etc index the data to be plotted.
%
%      handleList: the handle to the plotting results, with one handle per
%      colormap entryused for updating the plot with each timeIndex.
%
%      plotData: an [Nx2+] or [Nx3+] vector data to plot where N is the
%      number of points, and there are 2 or more columns. Each row of data
%      correspond to the [X Y] or [Latitude Longitude] coordinate of the
%      point to plot in the 1st and 2nd column. For some plots, data should
%      contain intensity in the 3rd column. If the intensity is not scaled
%      between 0 and 1, then it is converted to 0 and 1 via the following:
%      Iconverted = (I - Imin)/(Imax-Imin)
%      
%      (OPTIONAL INPUTS)
%
%      plotFormat: one of the following:
%      
%          * a format string, e.g. 'b-', that dictates the plot style.
%          a colormap is created using this value as 100%, to white as 0%
%          * a [1x3] color vector specifying the RGB ratios from 0 to 1
%          a colormap is created using this value as 100%, to white as 0%
%          * a structure whose subfields for the plot properties to change, for example:
%            plotFormat.LineWideth = 3;
%            plotFormat.MarkerSize = 10;
%            plotFormat.Color = [1 0.5 0.5];
%            A full list of properties can be found by examining the plot
%            handle, for example: h_geoplot = plot(1:10); get(h_geoplot)
%          If a color is specified, a colormap is created using this value
%          as 100%, to white as 0% - this supercedes any colormap.  If no
%          color or colormap is specified, then the default color is used.
%          If no color is specified, but a colormap is given, the colormap
%          is used.
%
%      colorMap: a string specifying the colormap for the plot, default is
%      to use the current colormap
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      handleList: the handle to the plotting results, with one handle per
%      colormap entry.
%
% DEPENDENCIES:
%
%      fcn_plotRoad_plotXY
%
% EXAMPLES:
%
%       See the script:
% 
%       script_test_fcn_plotRoad_animatePlot 
%  
%       for a full test suite.
%
% This function was written on 2023_09_04 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2023_09_04 - Sean Brennan
% -- Created function by copying out of load script in Geometry library

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==7 && isequal(varargin{end},-1))
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 0; % Flag to perform input checking
    flag_max_speed = 1;
else
    % Check to see if we are externally setting debug mode to be "on"
    flag_do_debug = 0; % % % % Flag to plot the results for debugging
    flag_check_inputs = 1; % Flag to perform input checking
    MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTROAD_FLAG_DO_DEBUG); 
        flag_check_inputs  = str2double(MATLABFLAG_PLOTROAD_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 999978; %#ok<NASGU>
else
    debug_fig_num = []; %#ok<NASGU>
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

if 0==flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(4,7);

        % % Check the points input to be length greater than or equal to 2
        % fcn_DebugTools_checkInputsToFunctions(...
        %     points, '2column_of_numbers',[2 3]);
        %
        % % Check the transverse_tolerance input is a positive single number
        % fcn_DebugTools_checkInputsToFunctions(transverse_tolerance, 'positive_1column_of_numbers',1);
        %
        % % Check the station_tolerance input is a positive single number
        % if ~isempty(station_tolerance)
        %     fcn_DebugTools_checkInputsToFunctions(station_tolerance, 'positive_1column_of_numbers',1);
        % end
    end
end


% Does user want to specify plotFormat?
% plotFormat = 'k';
plotFormat = [];
if 5 <= nargin
    temp = varargin{1};
    if ~isempty(temp)        
        plotFormat = temp;
    end
end


% Does user want to specify colorMapToUse?
colorMapToUse = [];
if (6<=nargin)
    temp = varargin{2};
    if ~isempty(temp)
        colorMapToUse = temp;
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) &&  (2<=nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end


%% Solve for the Maxs and Mins
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _       
%  |  \/  |     (_)      
%  | \  / | __ _ _ _ __  
%  | |\/| |/ _` | | '_ \ 
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


    % Is it the first plot?
    if timeIndex<1
        % It's the first plot, set up plot results
        switch lower(plotTypeString)
            case {'plotxy'}
                h_animatedPlot  = fcn_plotRoad_plotXY((plotData(:,1:2)), (plotFormat), (fig_num));

            case {'plotxyi'}
                [h_animatedPlot, indiciesInEachPlot]  = fcn_plotRoad_plotXYI(plotData, (plotFormat), (colorMapToUse), (fig_num));
                for ith_handle = 1:length(h_animatedPlot)
                    if ~isnan(h_animatedPlot(ith_handle))
                        % Grab the plotting data from the plot handle
                        plottedLatitudeData = get(h_animatedPlot(ith_handle),'XData');
                        plottedLongitudeData = get(h_animatedPlot(ith_handle),'YData');

                        % Shut off the plotted points
                        set(h_animatedPlot(ith_handle),'XData',plottedLatitudeData,'YData',plottedLongitudeData);

                        % Save the data back into the plot handles for
                        % future use
                        saveData.indiciesInThisPlot = indiciesInEachPlot{ith_handle};
                        saveData.plottedLatitudeData = plottedLatitudeData;
                        saveData.plottedLongitudeData = plottedLongitudeData;
                        set(h_animatedPlot(ith_handle),'UserData',saveData);
                    end
                end

            case {'plotll'}
                h_animatedPlot  = fcn_plotRoad_plotLL((plotData(:,1:2)), (plotFormat), (fig_num));

            case {'plotlli'}
                [h_animatedPlot, indiciesInEachPlot]  = fcn_plotRoad_plotLLI(plotData, (plotFormat), (colorMapToUse), (fig_num));
                for ith_handle = 1:length(h_animatedPlot)
                    if ~isnan(h_animatedPlot(ith_handle))
                        % Grab the plotting data from the plot handle
                        plottedLatitudeData = get(h_animatedPlot(ith_handle),'LatitudeData');
                        plottedLongitudeData = get(h_animatedPlot(ith_handle),'LongitudeData');

                        % Shut off the plotted points
                        set(h_animatedPlot(ith_handle),'LatitudeData',plottedLatitudeData,'LongitudeData',plottedLongitudeData);

                        % Save the data back into the plot handles for
                        % future use
                        saveData.indiciesInThisPlot = indiciesInEachPlot{ith_handle};
                        saveData.plottedLatitudeData = plottedLatitudeData;
                        saveData.plottedLongitudeData = plottedLongitudeData;
                        set(h_animatedPlot(ith_handle),'UserData',saveData);
                    end
                end

            otherwise
                warning('on','backtrace');
                warning('An unkown plotTypeString detected on initialization - throwing an error.');
                error('Unknown plotTypeString found.');
        end
    else
        % It's not the first plot, just update the results
        switch lower(plotTypeString)

            case {'plotxy'}
                set(h_animatedPlot,'XData',plotData(1:timeIndex,1),'YData',plotData(1:timeIndex,2));

            case {'plotxyi'}
                % Loop through the handles, turning on the plotted points
                for ith_handle = 1:length(h_animatedPlot)
                    if ~isnan(h_animatedPlot(ith_handle))
                        % Grab the plotting data from the plot handle
                        saveData = get(h_animatedPlot(ith_handle),'UserData');
                        indiciesInThisPlot = saveData.indiciesInThisPlot; 
                        plottedLatitudeData = saveData.plottedLatitudeData;
                        plottedLongitudeData = saveData.plottedLongitudeData;

                        % Which indicies to turn on?
                        indiciesTurnOn = find(indiciesInThisPlot<=timeIndex);

                        % Turn on the plotted points
                        set(h_animatedPlot(ith_handle),'XData',plottedLatitudeData(indiciesTurnOn),'YData',plottedLongitudeData(indiciesTurnOn));

                    end
                end
                
            case {'plotll'}
                set(h_animatedPlot,'LatitudeData',plotData(1:timeIndex,1),'LongitudeData',plotData(1:timeIndex,2));

            case {'plotlli'}
                % Loop through the handles, turning on the plotted points
                for ith_handle = 1:length(h_animatedPlot)
                    if ~isnan(h_animatedPlot(ith_handle))
                        % Grab the plotting data from the plot handle
                        saveData = get(h_animatedPlot(ith_handle),'UserData');
                        indiciesInThisPlot = saveData.indiciesInThisPlot; 
                        plottedLatitudeData = saveData.plottedLatitudeData;
                        plottedLongitudeData = saveData.plottedLongitudeData;

                        % Which indicies to turn on?
                        indiciesTurnOn = find(indiciesInThisPlot<=timeIndex);

                        % Turn on the plotted points
                        set(h_animatedPlot(ith_handle),'LatitudeData',plottedLatitudeData(indiciesTurnOn),'LongitudeData',plottedLongitudeData(indiciesTurnOn));

                    end
                end

            otherwise
                warning('on','backtrace');
                warning('An unkown plotTypeString detected on initialization - throwing an error.');
                error('Unknown plotTypeString found.');
        end
    end


    
end % Ends check if plotting

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end % Ends main function

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



