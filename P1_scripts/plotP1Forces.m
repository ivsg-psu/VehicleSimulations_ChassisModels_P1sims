% Script to plot P1 wheel forces from Mich. Sci. WFTs
% Author: Craig Beal
% Date: 8/9/18

% Need to have the data loaded
if ~exist('Fx_LF','var')
    error('Load the data using loadP1data.m before running plotP1Forces.m')
end

% Check to see if there is an axis linking vector. If not, create a null
% vector to add to.
if ~exist('linkHands','var')
    linkHands = [];
end

if ~exist('fHand40','var')
    fHand40 = figure('Name','P1 Tire Forces','NumberTitle','off');
else
    figure(fHand40) 
end
subplot(321)
plot(t,[Fx_LF Fx_RF])
linkHands = [linkHands; gca];
ylabel('Longitudinal Force')
legend('LF','RF')
subplot(323)
plot(t,[Fy_LF Fy_RF])
linkHands = [linkHands; gca];
ylabel('Lateral Force')
subplot(325)
plot(t,[Fz_LF Fz_RF])
linkHands = [linkHands; gca];
ylabel('Vertical Force')
subplot(322)
plot(t,[Mx_LF Mx_RF])
ylabel('Overturning Moment')
linkHands = [linkHands; gca];
subplot(324)
plot(t,[My_LF My_RF])
linkHands = [linkHands; gca];
ylabel('Wheelspin Moment')
subplot(326)
plot(t,[Mz_LF Mz_RF])
linkHands = [linkHands; gca];
ylabel('Aligning Moment')


linkaxes(linkHands,'x')

return;
%%
if ~exist('fHand41','var')
    fHand41 = figure('Name','P1 Tire Forces','NumberTitle','off');
else
    figure(fHand41) 
end
subplot(321)
plot(delta_LF,Fx_LF,delta_RF,Fx_RF)
ylabel('Longitudinal Force')
legend('LF','RF')
subplot(323)
plot(delta_LF,Fy_LF,delta_RF, Fy_RF)
ylabel('Lateral Force')
subplot(325)
plot(delta_LF,Fz_LF,delta_RF, Fz_RF)
ylabel('Vertical Force')
subplot(322)
plot(delta_LF,Mx_LF,delta_RF, Mx_RF)
ylabel('Overturning Moment')
subplot(324)
plot(delta_LF,My_LF,delta_RF, My_RF)
ylabel('Wheelspin Moment')
subplot(326)
plot(delta_LF,Mz_LF,delta_RF, Mz_RF)
ylabel('Aligning Moment')