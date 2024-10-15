% Script to extract test info from a directory of P1 data files

dirName = uigetdir();
files = dir(dirName);
fid = fopen('test_log.txt','w');
fprintf(fid,'Test ID\t Descrip\t Max Speed\t Max Lat Acc\t Test Time\n');
for i = 1:length(files)
    if ~files(i).isdir && ~isempty(strfind(files(i).name,'.mat'))
        load([dirName '/' files(i).name]);

        if ~exist('rt_tout')
            rt_tout = 0:0.01:0.01*(length(rt_spiBytesIn)-1);
        end
        parseP1data;
        topSpeed = max(GPS.HorSpd);
        maxLatAcc = max(abs(IMU.accelY));
        endTime = rt_tout(end);

        % Hack the newline characters out of the description field
        description = info.description;
        % Drop the prefix \n
        description = description(3:end);
        % Replace other \n's with ;'s
        description(findstr(description,'\n'))=';';
        % Write out the log
        fprintf(fid,'%s\t %2.1f\t %2.1f\t %2.1f\t %s\n',files(i).name, topSpeed, maxLatAcc, endTime, description);
        clearvars -except dirName files fid info
    end
end
fclose(fid);