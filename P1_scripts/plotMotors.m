% Motor plots only

% This addresses the motor feedback figure, if it exists. If not, it
% creates a new one.
if ~exist('handleDriveMotorFig','var') || 0 == isvalid(handleDriveMotorFig)
    handleDriveMotorFig = figure('Name','Drive Motors','NumberTitle','off','WindowStyle','docked');
else
    figure(handleDriveMotorFig);
end

MLblue = [0, 0.4470, 0.7410];
MLred = [0.8500, 0.3250, 0.0980];
MLyellow = [0.8500, 0.3250, 0.0980];
% Torque
subplot(2,2,1)
cla
hold on
plot(rt_tout,Motor.Left.Command.reqMotorTorqueL,'-.','color',MLblue,'linewidth',2);
plot(rt_tout,Motor.Left.Feedback.trueMotorTorqueL,'-','color',MLblue);
plot(rt_tout,Motor.Right.Command.reqMotorTorqueR,'-.','color',MLred,'linewidth',2);
plot(rt_tout,Motor.Right.Feedback.trueMotorTorqueR,'-','color',MLred);
title('Accurate Feedback: Torque')
xlabel('Time (s)')
ylabel('Torque (Nm)')
legend('Left Command','Left Actual','Right Command', 'Right Actual')
grid on
axis auto
ylim([-30 350])

% Voltage
subplot(2,2,2)
plot(rt_tout,Motor.Left.Feedback.trueMotorVoltageL,...
    rt_tout,Motor.Right.Feedback.trueMotorVoltageR)
title('Accurate Feedback: Voltage')
xlabel('Time (s)')
ylabel('Voltage (V)')
legend('Left','Right')
grid on
ylim([270 350])

% Current
subplot(2,2,3)
plot(rt_tout,Motor.Left.Feedback.trueMotorCurrentL,...
    rt_tout,Motor.Right.Feedback.trueMotorCurrentR)
title('Accurate Feedback: Current')
xlabel('Time (s)')
ylabel('Current (A)')
legend('Left','Right')
grid on
ylim([-30 150])

% Speed
subplot(2,2,4)
cla
hold on
plot(rt_tout,Motor.Left.Command.limMotorSpeedFL,'-.','color',MLblue,'linewidth',2);
plot(rt_tout,Motor.Left.Command.limMotorSpeedRL,'-.','color',MLblue,'linewidth',2);
plot(rt_tout,Motor.Left.Feedback.trueMotorSpeedL,'-','color',MLblue);
plot(rt_tout,Motor.Right.Command.limMotorSpeedFR,':','color',MLred,'linewidth',2);
plot(rt_tout,Motor.Right.Command.limMotorSpeedRR,':','color',MLred,'linewidth',2);
plot(rt_tout,Motor.Right.Feedback.trueMotorSpeedR,'-','color',MLred);
title('Accurate Feedback: Speed')
xlabel('Time (s)')
ylabel('Speed (rpm)')
legend('Left Upper Lim','Left Lower Lim','Left Actual','Right Upper Lim', 'Right Lower Lim','Right Actual')
grid on
axis auto
ylim([-1000 5500])