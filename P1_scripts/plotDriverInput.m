% Driver Input Plots only

% This addresses the motor feedback figure, if it exists. If not, it
% creates a new one.
if ~exist('handleDriverInputFig','var')
    handleDriverInputFig = figure('Name','Driver Input','NumberTitle','off');
else
    figure(handleDriverInputFig);
end

% Brake Switches
subplot(6,2,1)
plot(rt_tout,Driver.brakeSwitchA)
xlabel('Time (s)')
title('Brake Switch')
yticks([0 1])
yticklabels({'Off' 'On'})
ylim([-0.5 1.5])

% Switch FNR (F)
subplot(6,2,3)
plot(rt_tout,Driver.switchFNRF+Driver.switchFNRR)
xlabel('Time (s)')
title('Switch FNR')
yticks([-1 0 1])
yticklabels({'REV' 'N' 'FWD'})
ylim([-1.5 1.5])

% Accelerator Potentiometer
subplot(3,2,2)
plot(rt_tout,Driver.accel_pedal)
ylim([0 5])
title('Accelerator')
ylabel('Pedal Voltage (V)')
xlabel('Time (s)')

% Handwheel Angle Potentiometer
subplot(3,2,3)
plot(rt_tout,Driver.steering_angle_pot*180/pi)
ylim([-270 270])
ylabel('Meas. Pos. (deg)')
xlabel('Time (s)')
title('Handwheel Pot')

% Handwheel Encoder
subplot(3,2,4)
% Then plot both wrapped and unwrapped versions for comparison
plot(rt_tout,Driver.steering_encoder,rt_tout,Driver.unwrapped_encoder)
ylim([-200000 200000])
legend('Raw Signal','Unwrapped')
ylabel('Meas. Position (counts)')
xlabel('Time (s)')
title('Handwheel Encoder')

% Now plot the processed handwheel signals
subplot(313)
%subplot(3,2,5)
plot(rt_tout,Driver.handwheel_primary*180/pi,...
    rt_tout,Driver.handwheel_secondary*180/pi);
ylim([-270 270])
legend('Primary','Secondary')
ylabel('Meas. Pos. (deg)')
xlabel('Time (s)')