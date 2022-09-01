%this file tests the compute function of an SENN_AxonP, it populates and then
%submits an intracellular current injection to node 1
%for a given time duration and current intensity
clear all;
clear java      %reload the class, incase we messed with it
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');

%initialize parameters, meters and seconds
dt = 1e-7;      %time increment
num_dt = 200000;   %number of time steps
%iE = 1e-9;%-12; %4e-9;    %amount of current injected
%dtE = 20e-6;   %electrode current duration
%start = 1;   %when the stimulus will begin (in number of iterations)
nd = 1.4e-6;     %node diameter
al = 2e-6;     %active node length
pl = 300e-6;    %passive node length
num_n = 50;    %number of nodes

Vrest = -.0846;
traj = [0 0 0; 100 0 0];   %axon will lie along the x axis, starting at the origin
%axon = SENN_AxonP(traj, dt, num_dt);
%axon.populate(num_n, al, pl, nd);
step = (pl+al)/2;
axon = G_AHPAxon_CVStar0265([step; -1], [nd; -1],[al;-1], [pl;-1], num_n, dt, num_dt);


%set external potential
Ve = zeros(1, num_n);   %initialize
waveForm = zeros(1, num_dt);

R = Axon.quickSimulate(axon, num_dt, Ve, waveForm);

state = axon.getState();

axonB = G_AHPAxon_CVStar0265([step; -1], [nd; -1],[al;-1], [pl;-1], 50, dt, num_dt);
axonB.setInitialCondition(state);

axonB.getNumNodes();

