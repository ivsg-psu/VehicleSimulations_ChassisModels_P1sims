%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This script is intended to plot data from the workspace %
% for Craig's roll and relaxation length model            %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(3,1,1)
plot(t,[roll_outs(:,1) SSest(:,15)])
ylabel('Sideslip Angle (rad)');
legend('\beta est','\beta exp');
axis([42 54 -0.05 0.05]);

subplot(3,1,2)
plot(t,[roll_outs(:,2) INS(:,1)-.22/180*pi])
ylabel('Yaw Rate (rad/s)');
legend('r est','r exp');
axis([42 54 -.6 .6]);

subplot(3,1,3)
plot(t,[roll_outs(:,3) SSest(:,5)-.0115])
xlabel('Time (s)');
ylabel('Roll Angle (rad)');
legend('\phi est','\phi exp');
axis([42 54 -0.075 0.075]);