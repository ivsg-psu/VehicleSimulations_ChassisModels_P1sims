function make(varargin)
% This function compiles all of the necessary c-files into DLLs (or whatever
% sort of shared library your system uses) using the mex command.  If mex
% is not properly installed on your system (i.e. you're running Windows
% and you haven't installed a C compiler yet), this script will fail.
%
% It checks the file modifications times so as to avoid compiling files
% that have not changed since they were last compiled.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: Christopher Gadda
% (C) 2005 Dynamic Design Laboratory -- Stanford University
% $Revision: 746 $ $Date: 2009-09-21 15:03:37 -0700 (Mon, 21 Sep 2009) $

% These are the source files that need to be built in order to run nissan_steer.mdl
% Shad also added the ones needed for Jihan's filters (6th & 7th lines).
% Judy added the file needed for the NL observer (last line)
% Carrie added the file needed for SS controller (discrete_bike_nonlinear)
% Mick added the files needed for ControllerRacingSCACS
%srcnames={'beeline.c','bic_model.c', 'bike_model_threestate.c','enable.c',...
% 	      'nameddemux.c','namedmux.c','ssest_filter.c',...
%           'wgsxyz2enuP.c','wgsxyz2enuV.c',...
% 		  'wheelspeed.c','handwheel.c','encoderinit.c','unwrapper.c',...
%           'rollfilter.c','hdgfilter_s.c','velfilter_acc.c',...
%           'pps_vs330.c','pos_filter2.c',...
%           'bike_model_nonlinear.c','Envelope_Controller.c', 'discrete_bike_nonlinear.c',...
%           'FFWcontrolClothoid.c','longitudinalController_psi.c','match_scacs.c','FFWstraight.c','tireSlip.c',...
%           'FBsteeringLimitAlpha.c','longitudinalControllerSlipCircle.c','longitudinalControllerSlipCircleAlphaOnly.c',...
%           'holdingSteering.c', 'Brush.c',...
%           'Brush_obs.c', 'estimate_aligningTorque.c', 'c_sfun_mpcacc.c',...
%           'driftkeeping.c', 'drift_speed_controller.c', 'drift_controller_SDSC.c', 'match_scacs2.c',...
%           'stateprediction.c', 'inbounds_control.c', 'lat_err_yaw4_switch_KT.c', 'drift_controller_SSC.c',...
%           'asciiStreamtoString.c','vs330_bin3_rcv.c'};

srcnames={'./sFunctions/uint16ToBytes.c','./sFunctions/int16ToBytes.c',...
    './sFunctions/int32ToBytes.c','./sFunctions/singleToBytes.c',...
    './sFunctions/bits2byte.c','./sFunctions/enu2lla.c'};
      
% Determine the appropriate extension...
extension=['.' mexext];

% Now we need to figure out what to make.
if(nargin==0)
	srclist=curlydir(srcnames);
elseif((nargin==1)&(strcmp(varargin{1},'all')))
		% Note that this option probably won't work, if there are any C
		% files in the current directory that shouldn't be mexed.
		srclist=dir('./sFunctions/*.c');
else
	srclist=curlydir(varargin);
end


ss=length(srclist);

for i=1:ss
    % Now compile anything that looks out of date...
    infile=[srclist(i).folder '/' srclist(i).name];
    outfile=dir([infile(1:end-2) extension]);
    if(size(outfile,1))
        if(datenum(srclist(i).date)<=datenum(outfile(1).date))
            disp([outfile(1).name ' appears to be up-to-date.']);
        else
            disp(['Compiling ' infile]);
            mex('-outdir','./sFunctions',infile);
        end         
    else
        disp(['Compiling ' infile]);
        mex('-outdir','./sFunctions',infile);
    end
end

return

function dirlist=curlydir(names)
% This function works just like dir, except that you pass it a whole list
% of filenames or file patterns.

jj=1;
for ii=1:length(names)
	tmp=dir(names{ii});
	len=length(tmp);
	dirlist(jj:(jj+len-1))=tmp;
	jj=jj+len;
end

return
