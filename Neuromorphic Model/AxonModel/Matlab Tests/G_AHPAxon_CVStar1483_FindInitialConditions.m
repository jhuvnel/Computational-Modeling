%this file is used to create a set of initial conditions for a given axon class
clear all;
clear java      %reload the class, incase we messed with it
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
%initialize parameters, meters and seconds
dt = 1e-7;      %time increment
num_dt = 300000;   %number of time steps
nd = 2.2e-6;     %node diameter
al = [2e-6; 1e-6; -1];     %active node length
pl = [300e-6; -1];      %passive node length
step = [151e-6; 150.5e-6; -1];
num_n = 50;    %number of nodes
axon = G_AHPAxon_CVStar1483(step, [nd; -1], al, pl, num_n, dt, num_dt);


Vrest = -.0846;
%set external potential
Ve = zeros(1, num_n);   %initialize
waveForm = zeros(1, num_dt);

result = Axon.quickSimulate(axon, num_dt, Ve, waveForm);

apTimes = result{num_dt+1,:};
plot(apTimes);
%figure;
%plot(qx*1000, R);


%qx = 1:(num_dt);
%qx = qx*dt;
%temp = axon.V;
%plot(qx*10000, (temp(1,:)+Vrest)*1000, '-r',qx*10000, (temp(2,:)+Vrest)*1000, '-g',qx*10000, (temp(3,:)+Vrest)*1000, '-b');
%title('Time course of V for node 1 (red) 2 (green) and odd nodes > 2 (blue)');
%hold on
%plot(qx*10000, (temp(20,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(19,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(17,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(15,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(13,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(11,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(9,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(7,:)+Vrest)*1000, '-b')
%plot(qx*10000, (temp(5,:)+Vrest)*1000, '-b')

%[Y1, I1] = max(axon.V(5,:));
%[Y2, I2] = max(axon.V(7,:));

%disp(['Spike Height (mV): ' num2str(Y1*1000)])
%time = (I2-I1)*dt;
%speed = (pl+al)/time;
%disp(['Conduction velocity (m/s): ' num2str(speed)])

