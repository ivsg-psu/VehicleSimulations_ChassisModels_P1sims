% Control Panel plots only

% This addresses the left steering figure, if it exists. If not, it
% creates a new one.
if ~exist('handleControlsFig','var')
    handleControlsFig = figure('Name','Control Panel','NumberTitle','off');
else
    figure(handleControlsFig)
end

% Switch Key Switch
subplot(5,3,1)
plot(rt_tout,Controls.switch.KeySwitch)
xlabel('Time (s)')
title('Key Switch')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch HV Enable
subplot(5,3,2)
plot(rt_tout,Controls.switch.HVEnable)
xlabel('Time (s)')
title('HV Enable')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch DC/DC On
subplot(5,3,3)
plot(rt_tout,Controls.switch.DCDCOn)
xlabel('Time (s)')
title('DC/DC On')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Utility 1
subplot(5,3,4)
plot(rt_tout,Controls.switch.Utility1)
xlabel('Time (s)')
title('Utility 1')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Utility 2
subplot(5,3,5)
plot(rt_tout,Controls.switch.Utility2)
xlabel('Time (s)')
title('Utility 2')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Utility 3
subplot(5,3,6)
plot(rt_tout,Controls.switch.Utility3)
xlabel('Time (s)')
title('Utility 3')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Cruise Set
subplot(5,3,7)
plot(rt_tout,Controls.switch.CruiseSet)
xlabel('Time (s)')
title('Cruise Set')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Switch Cruise Enable
subplot(5,3,8)
plot(rt_tout,Controls.switch.CruiseEnable)
xlabel('Time (s)')
title('Cruise Enable')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp FNR (F)
subplot(5,3,9)
plot(rt_tout,Controls.lamp.FNRF)
xlabel('Time (s)')
title('Lamp FNR (F)')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp FNR (R)
subplot(5,3,10)
plot(rt_tout,Controls.lamp.FNRR)
xlabel('Time (s)')
title('Lamp FNR (R)')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp GPS OK
subplot(5,3,11)
plot(rt_tout,Controls.lamp.GPSOK)
xlabel('Time (s)')
title('Lamp GPS OK')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp WFT OK
subplot(5,3,12)
plot(rt_tout,Controls.lamp.WFTOK)
xlabel('Time (s)')
title('Lamp WFT OK')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp Drive Fault
subplot(5,3,13)
plot(rt_tout,Controls.lamp.DriveFault)
xlabel('Time (s)')
title('Lamp Drive Fault')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp Steer Fault
subplot(5,3,14)
plot(rt_tout,Controls.lamp.SteerFault)
xlabel('Time (s)')
title('Lamp Steer Fault')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])

% Lamp DC/DC OK
subplot(5,3,15)
plot(rt_tout,Controls.lamp.DCDCOK)
xlabel('Time (s)')
title('Lamp DC/DC OK')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.1 1.1])
