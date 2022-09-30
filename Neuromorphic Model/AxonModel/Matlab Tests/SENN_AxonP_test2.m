%this file tests the compute function of an SENN_AxonP, it populates and then
%submits an intracellular current injection to node 1
%for a given time duration and current intensity
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');
clear java      %reload the class, incase we messed with it

%initialize parameters, meters and seconds
dt = 1e-7;      %time increment
num_dt = 10000;   %number of time steps
iE = 1e-9;%-12; %4e-9;    %amount of current injected
dtE = 20e-6;   %electrode current duration
start = 1;   %when the stimulus will begin (in number of iterations)
nd = 1.4e-6;     %node diameter
al = 1e-6;     %active node length
pl = 300e-6;    %passive node length
num_n = 20;    %number of nodes

Vrest = -.0846;
traj = [0 0 0; 100 0 0];   %axon will lie along the x axis, starting at the origin
%axon = SENN_AxonP(traj, dt, num_dt);
%axon.populate(num_n, al, pl, nd);
step = (pl+al)/2;
axon = SENN_AxonP([step; -1], [nd; -1],[al;-1], [pl;-1], num_n, dt, num_dt);

%set external potential
Ve = zeros(1, num_n);   %initialize


%compute all of the time steps
for i =0:(num_dt-2)         %minus 2 because the first data point is the initial condition
    if (i>start && i<(start+(dtE/dt)))
        axon.inject(iE);
    else
        axon.inject(0);
    end
    axon.compute(Ve);
end

qx = 1:(num_dt);
qx = qx*dt;
temp = axon.V;
plot(qx*10000, (temp(1,:)+Vrest)*1000, '-r',qx*10000, (temp(2,:)+Vrest)*1000, '-g',qx*10000, (temp(3,:)+Vrest)*1000, '-b');
title('Time course of V for node 1 (red) 2 (green) and odd nodes > 2 (blue)');
hold on
plot(qx*10000, (temp(20,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(19,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(17,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(15,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(13,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(11,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(9,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(7,:)+Vrest)*1000, '-b')
plot(qx*10000, (temp(5,:)+Vrest)*1000, '-b')

[Y1, I1] = max(axon.V(5,:));
[Y2, I2] = max(axon.V(7,:));

disp(['Spike Height (mV): ' num2str(Y1*1000)])
time = (I2-I1)*dt;
speed = (pl+al)/time;
disp(['Conduction velocity (m/s): ' num2str(speed)])

