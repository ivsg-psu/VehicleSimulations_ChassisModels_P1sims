function reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, varargin)
%fcn_plotRoad_reduceColorMap    produces a reduced colorMap matrix
%
% This function creates a reduced-sized colorMap matrix from a given
% colorMap matrix and a user-input number of colors to keep. The method of
% reduction is to create an evenly divided list of numbers from 1:M, and
% divide it into Ncolors of numbers, then round to the nearest integer.
% This integer defines which color to use in the reduced colormap. The
% first color of the input colorMap is always preserved.
%
% NOTE: if the number of colors requested is larger than the original
% colormap, the colormap is streteched but NOT resampled so that the number
% of colors requested is always equal to the input Ncolors.
%
% FORMAT:
%
%      reducedColorMap = fcn_plotRoad_reduceColorMap(colorMapMatrix, Ncolors, (fig_num))
%
% INPUTS:
%
%      colorMapMatrix: an [Mx3] matrix of colors defining a color map. Typically,
%      M is 256 in standard MATLAB colormaps.
%
%      Ncolors: an integer value of N denoting the number of colors to
%      keep.
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      reducedColorMap: the reduced colormap
%
% DEPENDENCIES:
%
%      (none)
%
% EXAMPLES:
%
%       See the script:
%
%       script_test_fcn_plotRoad_reduceColorMap
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
if (nargin==3 && isequal(varargin{end},-1))
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
        narginchk(2,3);

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


% Does user want to specify fig_num?
flag_do_plots = 0;
if (0==flag_max_speed) &&  (3<=nargin)
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

Mcolors = length(colorMapMatrix(:,1));
newIndicies = round(linspace(1,Mcolors,Ncolors));
reducedColorMap = colorMapMatrix(newIndicies,:);

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

    figure(fig_num);
    clf;
    hold on;
    
    subplot(1,2,1);
    surf(peaks)
    colormap(gca, colorMapMatrix);    
    colorbar
    title(sprintf('Original colors, M = %.0f', Mcolors));

    subplot(1,2,2);
    surf(peaks)
    colormap(gca, reducedColorMap);    
    colorbar
    title(sprintf('Reduced colors, N = %.0f', Ncolors));
    
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



