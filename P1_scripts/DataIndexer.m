function index=DataIndexer(directory)
% DataIndexer.m - This function indexes the contents of a large number of
% test data files, provided that they were recorded using savedata.m.  The
% output of this script is an html file (which can be searched using any
% web browser) with summary information about each dataset, and a link to
% the corresponding .mat file.
%
% Someday, this script will also output a set of SQL commands that can be
% used to populate a SQL database with the results of this indexing
% process, so that more sophisticated searches may be possible.

	
	htmlfile='index.html';

	if(isstruct(directory))
		index=directory;
		OutputToHTML(index,htmlfile);
		return;
	end

	% First, we'll look up the path separator for our particular OS.
	% Unix uses /, Windows uses \.  
	slash=PathSeparator();

	% Initialize our index variable.
	index=[];

	% Now, we iterate through all subdirectories, looking for valid
	% datasets to index.  If we find a .mat file that doesn't contain an
	% "info" variable, we skip it.
	path=directory;
	while(path)
		% Find data files in the directory.
		files=dir([path slash '*.mat']);

		% Examine each file.
		for ii=1:length(files)
			info=ReadInfo([path slash files(ii).name]);

			if(~CheckInfo(info))
				disp([files(ii).name ' is not a valid dataset.']);
				continue;
			end

			index=AddToIndex(index,info,path,files(ii).name,length(directory)+2);
		end

		path=walk(path,directory);
	end
	% Now, let's sort the index into chronological order.
	[dummy,permute]=sort({index.time});
	index=index(permute);
	% Now that we've extracted all of the description information from
	% each file, we write out that info into a more useful format.
	OutputToHTML(index,htmlfile);
	%OutputToSQL(index,sqlfile);
	
end % -- end of DataIndexer function --



% -- walk function -- %

% This function "walks" a directory tree.  Pass in any path as the first
% argument, and a different path will be returned.  If you always pass in
% the path returned by a previous call to walk, you will eventually visit
% every subdirectory of the original path passed to walk.
% The second argument (which is optional) specifies an effective "root"
% path, which establishes the stopping condition.  The returned path
% will always be a subpath of the second argument.  When all subpaths of
% the second argument have been visited, the empty string '' will be
% returned.  If the second argument is omitted, it assumes the same value
% as the first argument.
function path=walk(oldPath,varargin)
	
	if(nargin>1)
		startingPath=varargin{1};
	else
		startingPath=oldPath;
	end
	
	slash=PathSeparator();

	% First, we'll look for any subdirectories.
	subdirs=dir(oldPath);
	subdirs=subdirs(find([subdirs.isdir]));
	
	% If there are any subdirectories, return the first of them.
	if(length(subdirs)>2) % We have to skip the first two entries, "." and ".."
		path=[oldPath slash subdirs(3).name];
	else
		while(true)
			% If there are no subdirectories, we must be at a "leaf".  Time to
			% start working our way back up.
			% First, we'll split up oldPath.
			lastSlash=max(find(slash==oldPath));
			parentDir=oldPath(1:lastSlash-1);
			tail=oldPath(lastSlash+1:end);

			% Make sure we don't go too high up.
			if(isempty(strfind(parentDir,startingPath)))
				path='';  % Indicate that we're done.
				break;
			end
				
			% Find our "sibling" directories.
			sibs=dir(parentDir);
			sibs=sibs(find([sibs.isdir]));
			
			nextSib=find(strcmp(tail,{sibs.name}))+1;
			if(nextSib>length(sibs))
				% We've already visited the last subdirectory here,
				% so we'll keep going up.
				oldPath=parentDir;
			else
				% Ok, move into the next sibling directory.
				path=[parentDir slash sibs(nextSib).name];
				break;
			end
		end
	end
end % -- end of walk function --

% -- PathSeparator -- %
function ps=PathSeparator()
	% The path separater is OS-specific.  (stupid microsoft)
	if(ispc)
		ps='\';
	else
		ps='/';
	end
end % -- end of PathSeparator function --

function info=ReadInfo(file)
	warningSettings=warning('off');
	try
		info=load(file,'info');
	catch
		warning(warningSettings);
	end
	warning(warningSettings);
	if(isfield(info,'info'))
		info=info.info;
	end
end % -- end of ReadInfo function --

function ver=CheckInfo(info)
	ver=0;
	if(isfield(info,'time') & ...
			isfield(info,'modelname') & ...
			isfield(info,'modelversion') & ...
			isfield(info,'driver') & ...
			isfield(info,'description') & ...
			isfield(info,'run'))
		ver=1; % ver 1.x has just the basic set of fields.
	end
	if(isfield(info,'libversion'))
		ver=2;  % ver 2.x has a separate library for I/O.
	end
	if(isfield(info,'testnum'))
		ver=3;	% ver 3.x added a test number.
	end
end % -- end of CheckInfo function --


function newIndex=AddToIndex(oldIndex,info,path,filename,relPathStart)

	%% Add some additional fields.
	info.filename=filename; 
	info.relativeURL=[path(relPathStart:end) '/' filename];
	
	% Pad out older style info blocks with any missing fields.
	if(~isfield(info,'libversion'))
		info.libversion='-0-';
	end
	if(~isfield(info,'testnum'))
		info.testnum=0;
	end
	if(~isfield(info,'HAL'))
		info.HAL.enabled='';
		info.HAL.maneuver='';
		info.HAL.amplitude=[];
		info.HAL.delay=[];
		info.HAL.duration=0;
		info.HAL.startfreq=[];
		info.HAL.endfreq=[];
	end
	if(~isfield(info,'maxlat'))
		info.maxlat=0;
	end
	if(~isfield(info,'speed'))
		info.speed=0;
	end
	if(~isfield(info,'testplanURL'))
		info.testplanURL='TestPlans/Moffett3.pdf';
	end
	if(~isfield(info,'hints'))
		info.hints.start=[];
		info.hints.stop=[];
	end
	
	% Add this info block to the index.
	if(isempty(oldIndex))
		newIndex=info;
	else
		newIndex=[oldIndex info];  % This is very inefficient!!
	end
end % -- end of AddToIndex --


function OutputToHTML(index,filename)
	% Open the output file.
	file=fopen(filename,'w');

	% Write out the header.
	fprintf(file,['<?xml version="1.0" encoding="UTF-8"?>\n'...
				  '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">\n'...
				  '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">\n'...
				  '  <head>\n'...
				  '    <title>Nissan Test Data Index</title>\n'...
				  '    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />\n'...
				  '    <link href="main.css" rel="stylesheet" type="text/css" />\n'...
				  '  </head>\n'...
				  '\n'...
				  '  <body>\n'...
				  '    <h1>Nissan Test Data Index</h1>\n'...
				  '    <div class="content">\n']);
	% Put in the option to browse the data manually.
	fprintf(file,['      <p>Click <a class="noticeable" href="Browse">here</a> to browse the data repository manually.</p>\n'...
				  '      <table>\n']);
	
	% Put column headings in
	fprintf(file,'      <col class="time"/><col class="driver"/><col class="testnum"/><col class="speed"/><col class="maxlat"/><col class="HAL"/><col class="desc"/>\n');
	fprintf(file,'      <tr class="row1">\n');
	fprintf(file,'        <th>Date &amp; Time</th>\n');
	fprintf(file,'        <th>Driver</th>\n');
	%fprintf(file,'        <th>Code</th>\n');
	fprintf(file,'        <th>Test</th>\n');
	fprintf(file,'        <th><i>v</i> (m/s)</th>\n');
	fprintf(file,'        <th><i>a<sub>y</sub></i> (g)</th>\n');
	fprintf(file,'        <th>HAL</th>\n');
	fprintf(file,'        <th>Description</th>\n');
	fprintf(file,'      </tr>\n');
	
	% Mark what year we're starting in. (Probably 2004)
	fprintf(file,'      <tr>\n');
	fprintf(file,'        <td colspan=20 class="year">%s</td>\n',index(1).time(1:4));
	%fprintf(file,'        <td/><td/><td/><td/>\n');
	fprintf(file,'      </tr>\n');
	% Create a table of data from the context of the index.
	for ii=1:length(index)
		if(ii>1)  % Here's where we check for year changes.
			if(~strcmp(index(ii).time(1:4),index(ii-1).time(1:4)))
				% When we find one, we put in a little break.
				fprintf(file,'      <tr>\n');
				fprintf(file,'        <td colspan=20 class="year">%s</td>\n',index(ii).time(1:4));
				%fprintf(file,'        <td/><td/><td/><td/>\n');
				fprintf(file,'      </tr>\n');
			end
		end
		if(ii<length(index))
			if(~strcmp(index(ii).time(1:10),index(ii+1).time(1:10)))
				endOfDay='eod';
			else
				endOfDay='';
			end
		end
		% Start a new row.  (Use a different style for even & odd rows.)
		if(abs(floor(ii/2)-ii/2)<.1) % i.e. if ii is even
			fprintf(file,'      <tr class="even%s">\n',endOfDay);
		else
			fprintf(file,'      <tr class="odd%s">\n',endOfDay);
		end
		
		% Ok, here's where we actually write out the fields of the table.
		% Date & time, with link to dataset.
		fprintf(file,'        <td><a href="%s">%s</a></td>\n',...
			index(ii).relativeURL,...
			strrep(index(ii).time(6:end-3),'-','/'));
		% Driver name.
		fprintf(file,'        <td>%s</td>\n',index(ii).driver);
		% Code letter
		% fprintf(file,'        <td>%s</td>\n',index(ii).run);
		% Test number if available.
		if(index(ii).testnum)
			fprintf(file,'        <td><a href="%s">%s</a></td>\n',...
				index(ii).testplanURL,...
				num2str(index(ii).testnum,3));
		else
			fprintf(file,'        <td></td>\n');
		end
		% Speed
		if(index(ii).speed)
			fprintf(file,'        <td>%2.2f</td>\n',index(ii).speed);
		else
			fprintf(file,'        <td></td>\n');
		end
		% Maximum lateral acceleration
		if(index(ii).maxlat)
			fprintf(file,'        <td>%0.2f</td>\n',index(ii).maxlat/9.8);
		else
			fprintf(file,'        <td></td>\n');
		end
		% HAL maneuver description
		fprintf(file,'        <td>%s</td>\n',SummarizeHAL(index(ii).HAL));		
		% Description
		fprintf(file,'        <td>%s</td>\n',strrep(index(ii).description(3:end),'\n','<br/>'));

		fprintf(file,'      </tr>\n'); % End of the row.
	end
	% Write out the footer.
	fprintf(file,'      </table>\n    </div>\n  </body>\n</html>');
			
	% Close the file.
	fclose(file);

end % -- end of OutputToHTML function --

function HALText=SummarizeHAL(HAL)
	switch(HAL.maneuver)
		case 'Step'
			HALText=sprintf('step %.3g&deg;',HAL.amplitude);
		case 'Ramp'
			HALText=sprintf('ramp %.3g&deg; %.3gs',HAL.amplitude,HAL.duration);
		case 'Chirp'
			if(HAL.startfreq==HAL.endfreq)
				HALText=sprintf('slalom %.3g&deg; %.3gHz  %.3gs',...
					HAL.amplitude,HAL.startfreq,HAL.duration);
			else
				HALText=sprintf('chirp %.3g&deg; %.3g-%.3gHz  %.3gs',...
					HAL.amplitude,HAL.startfreq,HAL.endfreq,HAL.duration);
			end
		case 'Double step'
			if(isempty(HAL.duration))
				HALText=sprintf('double %.3g&deg;',HAL.amplitude,HAL.duration);
			else
				HALText=sprintf('double %.3g&deg; %.3gs',HAL.amplitude,HAL.duration);
			end
		otherwise
			HALText='';
	end
end % -- end of SummarizeHAL function --
