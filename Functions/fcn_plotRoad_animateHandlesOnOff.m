function fcn_plotRoad_animateHandlesOnOff(timeIndex, handleList, Xdata, Ydata, varargin)
%fcn_plotRoad_animateHandlesOnOff    animates a list of handles by on/off
% 
% This function creates an animation of handles by turning selected plots
% on/off in sequence, creating the appearance of motion. If an array of
% handles is given in a sequence [h(1); h(2); h(3); ... etc], then when
% timeIndex is set to 1, then only h(1) is shown. When set to 2, then only
% h(2) is shown. When h(1)...h(M) are set up in sequence, the illusion of
% motion is created. A user-defined skipInterval can be given to create
% intervals other than 1 to 2 to 3. For example, a skip interval of 3 jumps
% from (1 and 4 and 7...) to (2 and 5 and 8... ) etc.
%
% FORMAT:
%
%      fcn_plotRoad_animateHandlesOnOff(timeIndex, handleList, Xdata, Ydata, (skipInterval), (fig_num))
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
%      skipInterval: the interval between "on" handles. Default is to have
%      only one handle on at a time, e.g. skipInterval = length(handleList)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      (none)
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
% 
%       script_test_fcn_plotRoad_animateHandlesOnOff
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


% Does user want to specify skipInterval?
skipInterval = length(handleList);
if (5<=nargin)
    temp = varargin{1};
    if ~isempty(temp)
        skipInterval = temp;
        skipInterval = min(skipInterval,length(handleList));
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) &&  (6<=nargin)
    % temp = varargin{end};
    % if ~isempty(temp)
    %     fig_num = temp;
    %     flag_do_plots = 1;
    % end
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

% Check to make sure all the data has same length
if flag_check_inputs == 1
    assert(Nhandles==length(Xdata(:,1)));
    assert(Nhandles==length(Ydata(:,1)));
    assert(length(Xdata(1,:))==length(Ydata(1,:)));
end

% Check if doing geoplot
is_geoplot = 0;
try 
    get(handleList(1),'LatitudeData');
    is_geoplot = 1;
catch
end

% Find the "on" pattern
this_index = mod(timeIndex,skipInterval)+1; % This forces this_index to go from 1 to ringSkipInterval, repeatedly
patternOnOff = mod((1:Nhandles)',skipInterval)==(this_index-1);
current_handles_on = find(patternOnOff);


old_index = mod(timeIndex-1,skipInterval)+1; % This forces this_index to go from 1 to ringSkipInterval, repeatedly
patternOnOff = mod((1:Nhandles)',skipInterval)==(old_index-1);
old_handles_off = find(patternOnOff);

if is_geoplot
    % Turn handles on
    for ith_onHandle = 1:length(current_handles_on)
        handle_to_change = current_handles_on(ith_onHandle);
        set(handleList(handle_to_change),'LatitudeData',Xdata(handle_to_change,:),'LongitudeData', Ydata(handle_to_change,:));
    end

    % Turn old ring off
    for ith_offHandle = 1:length(old_handles_off)
        handle_to_change = old_handles_off(ith_offHandle);
        set(handleList(handle_to_change),'LatitudeData',nan,'LongitudeData', nan);
    end
else
    % Turn handles on
    for ith_onHandle = 1:length(current_handles_on)
        handle_to_change = current_handles_on(ith_onHandle);
        set(handleList(handle_to_change),'XData',Xdata(handle_to_change,:),'YData', Ydata(handle_to_change,:));
    end

    % Turn old ring off
    for ith_offHandle = 1:length(old_handles_off)
        handle_to_change = old_handles_off(ith_offHandle);
        set(handleList(handle_to_change),'XData',nan,'YData', nan);
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



