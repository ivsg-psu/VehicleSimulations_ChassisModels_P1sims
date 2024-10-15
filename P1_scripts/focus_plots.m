% This script resets the time axis of all the plots that are open so that
% you can jump back and forth between a particular time range of interest
% or the whole time range

tstart = input('Enter start time:'); 
tend = input('Enter end time:');
if isempty(tstart)
    tstart = t(1);
end
if isempty(tend)
    tend = t(end);
end

for i = 1:length(findobj('Type','Figure'))
    figure(i);
    handles = get(gcf,'children');
    for j = 1:length(handles)
        if strcmp(get(handles(j),'tag'),'legend')~=1
            sprintf('In figure %d, fixing axis %d',i,j);
            lims = axis(handles(j));
            axis(handles(j),[tstart tend lims(3) lims(4)])
        end
    end
end
