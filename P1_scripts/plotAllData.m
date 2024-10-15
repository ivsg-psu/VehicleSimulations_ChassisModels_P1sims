% Script to call all plots or plot a specific 

% %% Data Selection
% % Modify to make such it pulls most recent data file saved by default
% % Ask user for file name
% query = input('Enter P1 file name with .mat extension or leave empty to use most recent file: ','s');
% 
% % If user hits return without entering file name, then it's assumed that 
% % the user wants to use most recently saved file
% 
% if ~isempty(query)
%     load(query)
% else
%     disp('Using most recently saved file...');
%     filePath = 'C:\Users\gjh014\gjhSummer2022Research\data\';
%     %Get the directory contents
%     dirc = dir(filePath);
%     % Filter out garbage folders
%     dirc = dirc(~cellfun(@isfolder,{dirc(:).name}));
%     % I contains the index of most recent folder
%     [~,I] = max([dirc(:).datenum]);
%     % Add the dated folder to the file path
%     filePath = append(filePath,dirc(I).name);
%     % Reset name of dirc to include dated folder
%     dirc = dir([filePath]);
%     % Filter out garbage folders
%     dirc = dirc(~cellfun(@isfolder,{dirc(:).name}));
%     % Find most recent .mat file instead
%     [~,I] = max([dirc(:).datenum]);
%     
%     % Now load the file name
%     if ~isempty(I)
%         load([filePath '\' dirc(I).name])
%     end
% end
% clear dirc filePath I query
%% Asking for which plots to display
plotsToDisp = input(['Enter the number corresponding to the plot you want to display.\nSeparate multiple plot inputs by a comma.\n' ...
    '[0]: All\n 1: Control Panels\n 2: Driver Input\n 3: Steering\n 4: Motor\n 5: IMU\n 6: Wheel Force Transducers\n 7: GPS\n'],'s');

cleanedInput = erase(plotsToDisp," ");
c = strsplit(cleanedInput,',');


%% Displaying plots

if isempty(plotsToDisp) || '0' == plotsToDisp
    plotControlPanel;
    plotDriverInput;
    plotSteering;
    plotMotors
    plotIMU;
    plotWFTs;
    plotGPS;
else
    for k = 1:length(c)
        if c{k} == '1'
            plotControlPanel;
        elseif c{k} == '2'
            plotDriverInput;
        elseif c{k} == '3'
            plotSteering;
        elseif c{k} == '4'
            plotMotors;
        elseif c{k} == '5'
            plotIMU;
        elseif c{k} == '6'
            plotWFTs;
        elseif c{k} == '7'
            plotGPS;
        else
            disp(['NOTE: The number ' c{k} ' does not correspond to any value on the list.'])
        end  
    end
end

% Clean up
clear plotsToDisp cleanedInput c dirc filePath I query