% dataChecks.m

% This script runs data checks specific to the data coming off the car. Eg:
% checking if WFTs are producing data but only after specific period of
% dead travel distance since the wheels only produce data after a
% revolution or so

% Author: Graham Heckert, Summer 2022 Research Project
% Using previous work from cgadda, Shad Laws

% Checks WFTs (one of them) for initialization period (i.e. one revolution
% before taking data), then checks for all zero data after that
step=0.002; % sec
dtSet=46; % column of y data
for i = 2:length(y(:,dtSet))
    if trapz(step,y(1:i,28))>=0.3*pi()*2
        if all(y(1:i,dtSet)==0)
            fprintf('WARNING: After initial startup period, WFT in column %s is collecting all zero data.\n',num2str(dtSet))
            break
        end
    end
end

% GPS checks for proper orientation (if not already included in sanity
% check)


clear dtSet step


