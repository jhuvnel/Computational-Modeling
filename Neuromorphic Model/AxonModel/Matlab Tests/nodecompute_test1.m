%this file will test a Node's compute function
clear all

%parameters
I = 0;
dt = 1e-6;      %time step amount
num_dt = 5000;    %number of time steps
V = 0;          %the intraceullular voltage of this node
Ve = 0;         %the extraceullular voltage of this node
Ve_L = Ve;       %left extracellular voltage, set these two the node's values (we're only looking at one node here)
V_L = V;        %left intracellular voltage
Ve_R = Ve;
V_R = V;
nd_L = 10e-6;       %node diameters
nd_R = 10e-6;
nd = 10e-6;
nl_L = 10e-6;       %node lengths
nl_R = 10e-6;
nl = 10e-6;
dist_L = 300e-6;     %distance to neighbors
dist_R = 300e-6;

Vout = ones(10,1);
Vrest = -0.0846;

node = SENN_ActiveNode(nd, nl, dt);
t = 1:num_dt;
t = t*dt;
for i = 1:num_dt
    Ve = V;
    Ve_L = V;
    Ve_R = V;
    V_L = V;
    V_R = V/2;
    V = node.compute(Ve, Ve_L, Ve_R, V, V_L, V_R, dist_L, dist_R, nd_L, nd_R, I);
    Vout(i) = V+Vrest;
    if (i > 1000 && i < 1100)
        %Ve = -0.2;
        I = 1e-8;%5.54e-9;%3e-8; %5.540e-9; %inject current on left side
        %Ve_R = 0;       %2nd derivative of potential must be non-zero
    elseif (i > 4000 && i < 4100)
        %Ve = 0;
        I = 3e-9; %5.540e-9; %inject current on left side
        %Ve_R = 0;
    else
        I = 0;
    end
end

plot(t*1000, Vout*1000)