function boundingBoxPolyshape = fcn_plotRoad_calcLaneBoundingBox(leftLaneBoundary_XY, rightLaneBoundary_XY, varargin)
%fcn_plotRoad_calcLaneBoundingBox  generates polyshape bounding box of lane
%
% The polyshape bounding box is created by using the right boundary and
% left boundary to enclose a polyshape region. The enclosure is created
% such that it starts on the right boundary, proceeds forward, and then is
% reversed in the negative left boundary direction. Thus, the normal
% projection in the z-direction is positive.
%
% FORMAT:
%
%      boundingBoxXY= fcn_plotRoad_calcLaneBoundingBox(leftLaneBoundary_XY, rightLaneBoundary_XY, (fig_num))
%
% INPUTS:
%
%
%      leftLaneBoundary_XY: [Nx2] vectors of the left boundary where each row contains [X Y] data.
%
%      rightLaneBoundary_XY: [Nx2] vectors of the right boundary where each row contains [X Y] data
%
%      (OPTIONAL INPUTS)
%
%      fig_num: a figure number to plot results. If set to -1, skips any
%      input checking or debugging, no figures will be generated, and sets
%      up code to maximize speed.
%
% OUTPUTS:
%
%      boundingBoxXY: the polyshape bounding box result
%
% DEPENDENCIES:
%
%      fcn_geometry_calcOrthogonalVector
%      fcn_plotRoad_plotTraceXY
%
% EXAMPLES:
%
%       See the script:
%       script_test_fcn_plotRoad_calcLaneBoundaries
%
% This function was written on 2024_08_16 by S. Brennan
% Questions or comments? sbrennan@psu.edu

% Revision History
% 2024_08_16 S. Brennan
% -- started writing function from fcn_PlotTestTrack similar function

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
    MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS = getenv("MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS");
    MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG = getenv("MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG");
    if ~isempty(MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS) && ~isempty(MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG)
        flag_do_debug = str2double(MATLABFLAG_PLOTCV2X_FLAG_DO_DEBUG);
        flag_check_inputs  = str2double(MATLABFLAG_PLOTCV2X_FLAG_CHECK_INPUTS);
    end
end

% flag_do_debug = 1;

if flag_do_debug
    st = dbstack; %#ok<*UNRCH>
    fprintf(1,'STARTING function: %s, in file: %s\n',st(1).name,st(1).file);
    debug_fig_num = 999978;
else
    debug_fig_num = [];
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

if 0 == flag_max_speed
    if flag_check_inputs == 1
        % Are there the right number of inputs?
        narginchk(1,3);

    end
end


% Does user want to specify projectionDistance?
projectionDistance = (12/2)/3.281; % 12 feet is standard lane width, and there are 3.281 feet in a meter
if (2 <= nargin)
    temp = varargin{1};
    if ~isempty(temp)
        projectionDistance = temp;
    end
end

% Does user want to specify fig_num?
flag_do_plots = 0;
fig_num = []; % Initialize the figure number to be empty
if (0==flag_max_speed) && (3 <= nargin)
    temp = varargin{end};
    if ~isempty(temp)
        fig_num = temp;
        flag_do_plots = 1;
    end
end

% Setup figures if there is debugging
if flag_do_debug
    fig_debug = 9999;
else
    fig_debug = []; %#ok<*NASGU>
end


%% Main code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   __  __       _
%  |  \/  |     (_)
%  | \  / | __ _ _ _ __
%  | |\/| |/ _` | | '_ \
%  | |  | | (_| | | | | |
%  |_|  |_|\__,_|_|_| |_|
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boundaryXY = [rightLaneBoundary_XY; flipud(leftLaneBoundary_XY)]; %  ; ENU_rightSide(1,:)];
boundaryXY_noRepeats = unique(boundaryXY,'rows','stable');

% Create the polyshape, and turn on warning tracking in case this throws
% errors - as it often does
warning('on','backtrace');
boundingBoxPolyshape = polyshape(boundaryXY_noRepeats(:,1),boundaryXY_noRepeats(:,2),'Simplify',false,'KeepCollinearPoints',true);


%% Any debugging?
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

if flag_do_plots == 1

    figure(fig_num);
    clf;
    hold on;


    clear plotFormat
    plotFormat.Marker = '.';
    plotFormat.MarkerSize = 10;
    plotFormat.LineStyle = 'none';
    plotFormat.LineWidth = 5;

    flag_plot_headers_and_tailers = 0;

    % Create an empty plot in ENU format
    plotFormat.Color = [1 0 0];
    fcn_plotRoad_plotTraceXY([nan nan], (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

    % Bounding box in green
    plot(boundingBoxPolyshape,'FaceColor',[0 1 0],'EdgeColor',[0 1 0],'Linewidth',3);

    % Right is red
    plotFormat.Color = [1 0 0];
    fcn_plotRoad_plotTraceXY(rightLaneBoundary_XY, (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

    % Left is blue
    plotFormat.Color = [0 0 1];
    fcn_plotRoad_plotTraceXY(leftLaneBoundary_XY, (plotFormat), (flag_plot_headers_and_tailers), (fig_num));

end

if flag_do_debug
    fprintf(1,'ENDING function: %s, in file: %s\n\n',st(1).name,st(1).file);
end

end


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



