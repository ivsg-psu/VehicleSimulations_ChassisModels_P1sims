% extractData.m
% Used to extract a portion of the Audesse data by name or number

% Author: Graham Heckert, Summer 2022 Research Project
% Using previous work from Chris Gadda, Shad Laws

% This function takes some RP4 data (y.mat) a description of that data
% (dd), and the name of a signal in that data (signal) to be extracted.
% Starting index is the first index of the signal, in datadesc, this will
% equal 1, but if read from debugger, startingIndex will equal
% sum([DataDescription.size]). Note that startingIndex = 0 if labeling the
% data from datadesc.
% It returns the requested subset of the data, or generates an error
% if no such named subset exists. Optionally, signal can be an integer, in
% which case the signal returned is looked up by number instead of name.

function [data]=extractData(y,dd,signal,startingIndex)
indx = startingIndex+1;

for signo=1:length(dd)
    sigsize=dd(signo).size;
    if(isa(signal,'double'))
        if(signo==signal)
            data = y(:,indx:indx+signsize-1);
            return;
        end
    else
        if(strcmp(dd(signo).name,signal))
            data = y(:,indx:indx+sigsize-1);
            return;
        end
    end
    indx = indx+sigsize;
end
error('Unable to find requested signal');
end
