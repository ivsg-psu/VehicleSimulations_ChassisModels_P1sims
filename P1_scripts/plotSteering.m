%% Steering (Left)

% This addresses the left steering figure, if it exists. If not, it
% creates a new one.
if ~exist('handleSteerLeftFig','var') || 0 == isvalid(handleSteerLeftFig)
    handleSteerLeftFig = figure('Name','Steering (Left)','NumberTitle','off','WindowStyle','docked');
else
    figure(handleSteerLeftFig);
end

% Operational State (Flexcase)
subplot(4,2,1)
plot(rt_tout,Steering.Left.state+0.1*Steering.Left.substate,'.')
ylim([-1 4])
set(gca,'ytick',[0 1 2 3]);
set(gca,'yticklabel',{'Fault','Startup','Degraded','Operational'});
title('Operational State (Flexcase)')
xlabel('Time (s)')
ylabel('Coded')

% Status Word
% Might need to alter to use yticks
subplot(4,2,2)
plot(rt_tout,Steering.Left.statusWord)
title('Status Word')
xlabel('Time (s)')
ylabel('Coded')

% Position Target Value
subplot(4,1,2)
plot(rt_tout,[Steering.Left.posTargetVal Steering.Left.posActualVal],'.')
ylim([-60000 60000])
title('Position Values')
legend('Target','Actual')
ylabel('Counts')

% Velocity
subplot(4,1,3)
plot(rt_tout,[Steering.Left.velFeedF Steering.Left.actualVel],'.')
ylim([-200000 200000])
title('Velocity Values')
legend('Target','Actual')
ylabel('Counts/sec')

% Torque
subplot(4,1,4)
plot(rt_tout,[Steering.Left.currentFeedF Steering.Left.torqueActualVal],'.')
ylim([-20 20])
title('Torque Values')
legend('Target','Actual')
xlabel('Time (s)')
ylabel('Nm')

%% Steering (Right)

% This addresses the right steering figure, if it exists. If not, it
% creates a new one.
if ~exist('handleSteerRightFig','var') || 0 == isvalid(handleSteerRightFig)
    handleSteerRightFig = figure('Name','Steering (Right)','NumberTitle','off','WindowStyle','docked');
else
    figure(handleSteerRightFig);
end

% Operational State (Flexcase)
subplot(4,2,1)
plot(rt_tout,Steering.Right.state+0.1*Steering.Right.substate,'.')
ylim([-1 4])
set(gca,'ytick',[0 1 2 3]);
set(gca,'yticklabel',{'Fault','Startup','Degraded','Operational'});
title('Operational State (Flexcase)')
xlabel('Time (s)')
ylabel('Coded')

% Status Word
% Might need to alter to use yticks
subplot(4,2,2)
plot(rt_tout,Steering.Right.statusWord)
title('Status Word')
xlabel('Time (s)')
ylabel('Coded')

% Position Target Value
subplot(4,1,2)
plot(rt_tout,[Steering.Right.posTargetVal Steering.Right.posActualVal],'.')
ylim([-60000 60000])
title('Position Values')
legend('Target','Actual')
ylabel('Counts')

% Velocity Feedforward
subplot(4,1,3)
plot(rt_tout,[Steering.Right.velFeedF Steering.Right.actualVel],'.')
ylim([-200000 200000])
legend('Target','Actual')
title('Velocity Values')
ylabel('Counts/sec')

% Torque
subplot(4,1,4)
plot(rt_tout,[Steering.Right.currentFeedF Steering.Right.torqueActualVal],'.')
ylim([-20 20])
legend('Target','Actual')
title('Torque Values')
xlabel('Time (s)')
ylabel('Nm')
