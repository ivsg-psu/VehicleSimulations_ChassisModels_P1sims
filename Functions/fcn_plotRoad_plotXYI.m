function [h_plot, indiciesInEachPlot] = fcn_plotRoad_plotXYI(XYIdata, varargin)
%fcn_plotRoad_plotXYI    plots XY data with intensiy color mapping
% 
% FORMAT:
%
%      [h_plot, indiciesInEachPlot] = fcn_plotRoad_plotXYI(XYIdata, (plotFormat), (colorMapStringOrMatrix), (fig_num))
%
% INPUTS:  
%
%      XYIdata: an [Nx3+] vector data to plot where N is the number
%      of points, and there are 3 or more columns. Each row of data
%      correspond to the [X Y] coordinate of the point to plot in the 1st
%      and 2nd column, and intensity in the 3rd column. If the intensity is
%      not scaled between 0 and 1, then it is converted to 0 and 1 via the
%      following: Iconverted = (I - Imin)/(Imax-Imin)
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
%            handle, for example: h_plot = plot(1:10); get(h_plot)
%          If a color is specified, a colormap is created using this value
%          as 100%, to white as 0% - this supercedes any colormap.  If no
%          color or colormap is specified, then the default color is used.
%          If no color is specified, but a colormap is given, the colormap
%          is used.
%
%      colorMapStringOrMatrix: a string specifying the colormap for the plot, default is
%      to use the current colormap
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      h_plot: the handle to the plotting results, with one handle per
%      colormap entry.
%
%     indiciesInEachPlot: a cell array for each colormap entry listing
%     which indicies were plotted in that color
%
% DEPENDENCIES:
%
%      fcn_plotRoad_plotXY
%
% EXAMPLES:
%
%       See the script:
% 
%       script_test_fcn_plotRoad_plotXYI.m 
%  
%       for a full test suite.
%
% This function was written on 2024_08_12 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2024_08_12 - Sean Brennan
% -- Created function by copying out of load script in Geometry library

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==4 && isequal(varargin{end},-1))
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
        narginchk(1,4);

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
if 2 <= nargin
    input = varargin{1};
    if ~isempty(input)
        if ischar(input) && length(input)<=4
            plotFormat = fcn_plotRoad_extractFormatFromString(input);
        elseif isnumeric(input)  % Numbers are a color style
            plotFormat.Color = input;
        elseif isstruct(input)  % Structures give properties
            plotFormat = input;
        else
            warning('on','backtrace');
            warning('An unkown input plotFormat is detected - throwing an error.')
            error('Unknown plotFormat input detected')
        end
    end
end


% Does user want to specify colorMapStringOrMatrixToUse?
colorMapStringOrMatrixToUse = [];
if (1<=nargin)
    temp = varargin{2};
    if ~isempty(temp)
        colorMapStringOrMatrixToUse = temp;
        if ischar(colorMapStringOrMatrixToUse)
            colorMapStringOrMatrixToUse = colormap(colorMapStringOrMatrixToUse);
        end
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

NplotPoints = length(XYIdata(:,1));
indiciesPlotted = (1:NplotPoints)';

% Check the user entries
XYdata = XYIdata(:,1:2);
rawIdata = XYIdata(:,3);

maxI = max(rawIdata);
minI = min(rawIdata);
if maxI>1 || minI<0
    Idata = (rawIdata - minI)/(maxI - minI);
else
    Idata = rawIdata;
end

% Check the colorMapStringOrMatrix
if isempty(colorMapStringOrMatrixToUse)
    if isfield(plotFormat,'Color')
        colorToScale = plotFormat.Color;
    else
        % Find the next color
        if isempty(plotFormat)
            colors = get(gca,'ColorOrder');
            index  = get(gca,'ColorOrderIndex');
        end
        colorToScale = colors(index,:);
    end
    ratios = linspace(0,1,8)';

    colorMapStringOrMatrixToUse = (1-ratios)*colorToScale + ratios*[1 1 1];
end

% Reformat the XY data if line formats are given (not points)
if isfield(plotFormat,'LineStyle') && NplotPoints>1
    X_dataPadded = [XYdata(1:end-1,1)'; XYdata(2:end,1)'; nan(1,NplotPoints-1)];
    Y_dataPadded = [XYdata(1:end-1,2)'; XYdata(2:end,2)'; nan(1,NplotPoints-1)];
    I_dataPadded = [Idata(1:end-1,1)'; Idata(1:end-1,1)'; Idata(1:end-1,1)'];
    indicies_dataPadded = [indiciesPlotted(1:end-1,1)'; indiciesPlotted(1:end-1,1)'; indiciesPlotted(1:end-1,1)'];


    X_data = reshape(X_dataPadded,[],1);
    Y_data = reshape(Y_dataPadded,[],1);
    I_data = reshape(I_dataPadded,[],1);
    indicies_data = reshape(indicies_dataPadded,[],1);
else
    plotFormat.Marker = '.';
    plotFormat.LineStyle = 'none';
    X_data = XYdata(:,1);
    Y_data = XYdata(:,2);   
    I_data = Idata;
    indicies_data = indiciesPlotted;
end

% Initialize the output
Ncolors = length(colorMapStringOrMatrixToUse(:,1));
h_plot = nan(Ncolors,1);
indiciesInEachPlot{Ncolors} = [];

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

    colorIndicies = round(I_data*(Ncolors-1))+1;

    for ith_color = 1:Ncolors
        h_plot(ith_color,1) = nan;
        plotting_indicies = find(colorIndicies==ith_color);
        if ~isempty(plotting_indicies)
            % Append the color to the current plot format
            tempPlotFormat = plotFormat;
            tempPlotFormat.Color = colorMapStringOrMatrixToUse(ith_color,:);

            % Update the X and Y data to select only the points in this
            % color
            X_data_selected = X_data(plotting_indicies,:);
            Y_data_selected = Y_data(plotting_indicies,:);

            % Do the plotting
            h_plot(ith_color,1)  = fcn_plotRoad_plotXY([X_data_selected Y_data_selected], (tempPlotFormat), (fig_num));

            % Save the indicies
            indiciesInEachPlot{ith_color} = indicies_data(plotting_indicies,:);
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



