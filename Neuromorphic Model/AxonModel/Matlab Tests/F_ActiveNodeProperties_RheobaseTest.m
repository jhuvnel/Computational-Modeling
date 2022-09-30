clear all;
clear java;
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');

%initialize parameters, meters and seconds
inj = 0.231e-9;    %injected current amount (in amps)
nodeLength = 2e-6;
nodeDiameter = 1.8e-6;
Vt = 0.09;

dt = 1e-7;      %time increment
num_dt = 100000;   %minimum number of time steps to declare rheobase

Vrest = -.0846;
node = SENN_ActiveNode(nodeDiameter, nodeLength, dt);
node2 = SENN_ActiveNode(nodeDiameter, nodeLength, dt);


Vi = zeros(num_dt,1);
Vi2 = zeros(num_dt,1);
apFlag = false;
%compute all of the time steps
for i =2:num_dt
	Vi(i) = node.compute(0, 0, 0, Vi(i-1), Vi(i-1), Vi2(i-1), 300e-6, 300e-6, nodeDiameter, nodeDiameter, inj);
	Vi2(i) = node2.compute(0, 0, 0, Vi2(i-1), Vi(i-1), Vi2(i-1), 300e-6, 300e-6, nodeDiameter, nodeDiameter, 0);
end
plot(Vi);
Vta = zeros(num_dt,1);
Vta(1:num_dt) = Vt;
hold on;
plot((1:num_dt), Vta, '-r');

