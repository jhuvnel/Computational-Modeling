%this file tests the compute function of an SENN_AxonP, it populates and then
%submits an intracellular current injection to node 1
%for a given time duration and current intensity
clear all;
clear java      %reload the class, incase we messed with it
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');

%initialize parameters, meters and seconds
dt = 1e-7;      %time increment
num_dt = 1000000;   %number of time steps
%iE = 1e-9;%-12; %4e-9;    %amount of current injected
%dtE = 20e-6;   %electrode current duration
%start = 1;   %when the stimulus will begin (in number of iterations)
nd = 1.4e-6;     %node diameter
al = 2e-6;     %active node length
pl = 300e-6;    %passive node length
num_n = 20;    %number of nodes

Vrest = -.0846;
traj = [0 0 0; 100 0 0];   %axon will lie along the x axis, starting at the origin
%axon = SENN_AxonP(traj, dt, num_dt);
%axon.populate(num_n, al, pl, nd);
step = (pl+al)/2;

nodeA = G_AHPNode_CVStar0265(nd, al, dt);
for i = 1:80
    if i ~= 21
        vv = 0;
    else
        vv = 0.12;
    end
    nodeA.compute(0,0,0,vv,0,0,1,1,1,1);
end

state = nodeA.getState();

nodeB = G_AHPNode_CVStar0265(nd, al, dt);
nodeB.setState(state);

nodeB.isActive();

