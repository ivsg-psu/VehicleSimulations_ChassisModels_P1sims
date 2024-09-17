function fcn_plotRoad_animateHandlesDataSlide(timeIndex, handleList, Xdata, Ydata, varargin)
%fcn_plotRoad_animateHandlesDataSlideDataSlide    animates a list of handles by data sliding
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
%
% INPUTS:  
%
%      timeIndex: an integer that indicates which step in the time sequence
%      is being animated currently
%      
%      handleList: an [Mx1] array of handles to the graphic objects being
%      turned on/off
%      
%      Xdata: an [MxN] matrix of the original X data for the "on" condition.
%      If the handles contain "LatitudeData", this is filled instead of
%      "XData".
%      
%      Ydata: an [MxN] matrix of the original Y data for the "on" condition.
%      If the handles contain "LongitudeData", this is filled instead of
%      "YData".
%      
%      (OPTIONAL INPUTS)
%
%      afterPlotColor: which color the points should inheret after being
%      passed through. Default is to not plot the point.
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      newHandleList: the updated handles
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
% 
%       script_test_fcn_plotRoad_animateHandlesDataSlide
%  
%       for a full test suite.
%
% This function was written on 2024_08_19 by Sean Brennan
% Questions or comments? sbrennan@psu.edu

% Revision history
% 2024_08_19 - Sean Brennan
% -- Created function by copying out of load script in Geometry library

%% Debugging and Input checks

% Check if flag_max_speed set. This occurs if the fig_num variable input
% argument (varargin) is given a number of -1, which is not a valid figure
% number.
flag_max_speed = 0;
if (nargin==6 && isequal(varargin{end},-1))
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
        narginchk(4,6);

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


% Does user want to specify afterPlotColor?
afterPlotColor = [];
if (5<=nargin)
    temp = varargin{1};
    if ~isempty(temp)
        afterPlotColor = temp;
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
fig_num = [];
if (0==flag_max_speed) &&  (6<=nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end

if isempty(fig_num)
    fig_num = gcf;
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

Nhandles = length(handleList);

%% Check if doing geoplot
is_geoplot = 0;
try 
    XDataSample = get(handleList(1),'LatitudeData');
    is_geoplot = 1;

catch
    XDataSample = get(handleList(1),'XData');
end

%% Check to make sure all the data has same length
Ndatapoints = length(Xdata(:,1));
if flag_check_inputs == 1
    % assert(length(XDataSample(1,:))==length(Xdata(1,:)));
    % assert(length(XDataSample(1,:))==length(Ydata(1,:)));
    assert(length(Ydata(:,1))==length(Xdata(:,1)));
end

if is_geoplot

    % Turn handles on
    for ith_onHandle = 1:Nhandles
        handleIndex = Nhandles - ith_onHandle +1;
        handle_to_change = handleList(handleIndex);
        % if timeIndex is larger than K, it is "wrapped" back into the
        % allowable range.
        rawTimeIndicies = (timeIndex-ith_onHandle+1):-1:((timeIndex-ith_onHandle+1)-Nhandles+1);
        timeIndicies = rawTimeIndicies(rawTimeIndicies>0);
        this_index = mod(timeIndicies-1,Ndatapoints)+1; % This forces this_index to go from 1 to Ndatapoints, repeatedly

        % This if-statement prevents wrap-around at ends
        if ~isempty(this_index) && this_index(1)<this_index(end)
            wrapPoint = find(this_index==Ndatapoints);
            this_index_no_wrap = this_index(wrapPoint:end);
        else
            this_index_no_wrap = this_index;
        end
        set(handle_to_change,'XData',Xdata(this_index_no_wrap,:),'YData', Ydata(this_index_no_wrap,:));
    end

    % Turn old point off?
    if ~isempty(afterPlotColor)
        rawOldTimeIndicies = (timeIndex-(Nhandles+1)+1);
        oldTimeIndicies = rawOldTimeIndicies(rawOldTimeIndicies>0);
        this_index = mod(oldTimeIndicies-1,Ndatapoints)+1; % This forces this_index to go from 1 to Ndatapoints, repeatedly
        fcn_plotRoad_plotLL([Xdata(this_index,:),Ydata(this_index,:)],afterPlotColor,fig_num)
    end
else
    % Fix the axes
    temp = [min(Xdata) max(Xdata) min(Ydata) max(Ydata)];
    axis_range_x = temp(2)-temp(1);
    axis_range_y = temp(4)-temp(3);
    percent_larger = 0.3;
    axis([temp(1)-percent_larger*axis_range_x, temp(2)+percent_larger*axis_range_x,  temp(3)-percent_larger*axis_range_y, temp(4)+percent_larger*axis_range_y]);

    % Turn handles on
    for ith_onHandle = 1:Nhandles
        handleIndex = Nhandles - ith_onHandle +1;
        handle_to_change = handleList(handleIndex);
        % if timeIndex is larger than K, it is "wrapped" back into the
        % allowable range.
        rawTimeIndicies = (timeIndex-ith_onHandle+1):-1:((timeIndex-ith_onHandle+1)-Nhandles+1);
        timeIndicies = rawTimeIndicies(rawTimeIndicies>0);
        this_index = mod(timeIndicies-1,Ndatapoints)+1; % This forces this_index to go from 1 to Ndatapoints, repeatedly

        % This if-statement prevents wrap-around at ends
        if ~isempty(this_index) && this_index(1)<this_index(end)
            wrapPoint = find(this_index==Ndatapoints);
            this_index_no_wrap = this_index(wrapPoint:end);
        else
            this_index_no_wrap = this_index;
        end
        set(handle_to_change,'XData',Xdata(this_index_no_wrap,:),'YData', Ydata(this_index_no_wrap,:));
    end

    % Turn old point off?
    if ~isempty(afterPlotColor)
        rawOldTimeIndicies = (timeIndex-(Nhandles+1)+1);
        oldTimeIndicies = rawOldTimeIndicies(rawOldTimeIndicies>0);
        this_index = mod(oldTimeIndicies-1,Ndatapoints)+1; % This forces this_index to go from 1 to Ndatapoints, repeatedly
        plot(Xdata(this_index,:),Ydata(this_index,:),'.','Color',afterPlotColor)
    end
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

    % % Is plotFormat filled? If not, set defaults
    % if isempty(plotFormat) || ~isfield(plotFormat,'LineStyle') || ~isfield(plotFormat,'LineWidth')
    %     if ~isfield(plotFormat,'LineStyle') 
    %         plotFormat.LineStyle = '-';
    %     end
    %     if ~isfield(plotFormat,'LineWidth')
    %         plotFormat.LineWidth = 3;
    %     end
    % end
    % 
    % % Center plot on circle center
    % h_geoplot = fcn_plotRoad_plotLL((LLcenter(1,1:2)), (plotFormat), (fig_num));
    % set(gca,'MapCenter',LLcenter(1,1:2));
    % 
    % for ith_color = Rcolors:-1:1
    % 
    %     % Append the color to the current plot format
    %     tempPlotFormat = plotFormat;
    %     tempPlotFormat.Color = ringColors(ith_color,:);
    % 
    %     % Update the X and Y data to select only the points in this
    %     % color
    %     X_data_selected = AllLatData(ith_color,:)';
    %     Y_data_selected = AllLonData(ith_color,:)';
    % 
    %     % Do the plotting
    %     h_geoplot(ith_color,1)  = fcn_plotRoad_plotLL([X_data_selected Y_data_selected], (tempPlotFormat), (fig_num));
    % end
    % 

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



