%used to calibrate the goldberg channel, I wanted to see how much current
%the sodium and potassium channels could balance without going into an
%action potential

clear all;
clear java;
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');

%initialize parameters, meters and seconds
inj = 100e-9;    %injected current amount (in amps)
nodeLength = 1-6;
nodeDiameter = 1-6;
Vt = 0.09;

dt = 1e-7;      %time increment
num_dt = 100000;   %minimum number of time steps to declare rheobase

Vrest = -.0846;
node = SENN_ActiveNode(nodeDiameter, nodeLength, dt);


Vi = zeros(num_dt,1);
%compute all of the time steps
for i =2:num_dt
	Vi(i) = node.compute(0, 0, 0, Vi(i-1), Vi(i-1), Vi(i-1), 300e-6, 300e-6, nodeDiameter, nodeDiameter, inj);
end
plot(Vi);
Vta = zeros(num_dt,1);
Vta(1:num_dt) = Vt;
hold on;
plot((1:num_dt), Vta, '-r');

