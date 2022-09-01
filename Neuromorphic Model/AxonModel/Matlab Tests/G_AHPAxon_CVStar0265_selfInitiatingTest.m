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
axon = G_AHPAxon_CVStar0265([step; -1], [nd; -1],[al;-1], [pl;-1], num_n, dt, num_dt);


%set external potential
Ve = zeros(1, num_n);   %initialize
waveForm = zeros(1, num_dt);

R = Axon.quickSimulate(axon, num_dt, Ve, waveForm);
intS = find(R == 1);
temp2 = zeros(size(intS,1)-1,1);
temp3 = zeros(size(intS,1)-1,1);
for (i = 1:(size(intS,1)-1))
    temp2(i) = intS(i+1)-intS(i);
    temp2(i) = temp2(i)*dt;
    temp3(i) = temp2(i);
    temp2(i) = 1/temp2(i);
end
lt = temp2(find(temp2<300));
dp = temp3;
%for iterator = 1:9
%    axon = G_AHPAxon_CVStar0265([step; -1], [nd; -1],[al;-1], [pl;-1], num_n, dt, num_dt);
%    R = Axon.quickSimulate(axon, num_dt, Ve, waveForm);
%    intS = find(R == 1);
%    temp2 = zeros(size(intS,1)-1,1);
%    temp3 = zeros(size(intS,1)-1,1);
%    for (i = 1:(size(intS,1)-1))
%        temp2(i) = intS(i+1)-intS(i);
%        temp2(i) = temp2(i)*dt;
%        temp3(i) = temp2(i);
%        temp2(i) = 1/temp2(i);
%    end
%    lt = [lt; temp2(find(temp2<300))];
%    dp = [dp; temp3];
%end


temp = axon.V;
qx = 1:(num_dt);
qx = qx*dt;
plot(qx*1000, (temp(1,:)+Vrest)*1000, '-b');%, qx*1000, (temp(19,:)+Vrest)*1000, '-r');


meanIntS = mean(lt);
stdIntS = std(lt);
disp(['Mean firing rate: ' num2str(meanIntS)])
disp(['Firing rate std dev: ' num2str(stdIntS)])
meanPer = mean(dp);
stdPer = std(dp);
disp(['Mean interval: ' num2str(meanPer)])
disp(['Interval std dev: ' num2str(stdPer)])
disp(['CV: ' num2str(stdPer/meanPer)])
meanInterval = meanPer*1000;
tableInterval = (meanInterval-7.5)/5;
A = (0.84-0.56)*tableInterval + 0.56;
B = (0.97-0.81)*tableInterval + 0.81;
cvStar = ((stdPer/meanPer)/A)^(1/B);   %for a mean interval of 10mS
disp(['CV*: ' num2str(cvStar)])

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

