%this file tests the compute function of Axon, it populates and then
%submits a monopolar electrode extracellularly for a given time duration
%and current intensity
clear all;

%initialize parameters, meters and seconds
iE = -10e-6;    %electrode current output
dtE = 50e-6;   %electrode current duration
start = 100;   %when the stimulus will begin (in number of iterations)

dt = 1e-7;      %time increment
num_dt = 10000;   %number of time steps
loc = [0,0,50e-6];    %monopolar electrode at
nd = 3e-6;     %node diameter
al = 3e-6;     %active node length
pl = 175e-6;    %passive node length
num_n = 20;    %number of nodes

Vrest = -.0846;
traj = [0 0 0; 100 0 0];   %axon will lie along the x axis, starting at the origin
axon = SENN_AxonI(traj, dt, num_dt);
axon.populate(num_n, al, pl, nd);


%set external potential
Ve = zeros(1, num_n);   %initialize
Ve0 = Ve;       %before electrode turned on
for j=1:num_n
    distE = axon.position(j,1:3) - loc;
    distE = distE.^2;
    distE2 = (distE(1)+distE(2)+distE(3))^0.5;
    Ve(j) = 3*iE/(4*pi*distE2);
end


%compute all of the time steps
VeCurr = Ve0;
for i =0:(num_dt-2)         %minus 2 because the first data point is the initial condition
    if (i>start && i<(start+(dtE/dt)))
        VeCurr = Ve;
    else
        VeCurr = Ve0;
    end
    axon.compute(VeCurr);
end

qx = 1:(num_dt);
qx = qx*dt;
temp = axon.V;
plot(qx*10000, (temp(1,:)+Vrest)*1000, '-r',qx*10000, (temp(2,:)+Vrest)*1000, '-g',qx*10000, (temp(3,:)+Vrest)*1000, '-b');
title('Time course of V for node 1 (red) 2 (green) and odd nodes > 2 (blue)');
hold on
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
