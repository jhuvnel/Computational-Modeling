%this tests the properties of the potassium channel
clear all;

%parameters
nd = 10e-6;     %node diameter
nl = 10e-6;     %node length
dt = 1e-5;      %time increment


channel = F_PotassiumChannel(nd, nl, dt);

%first plot the alpha / beta curves for each gate

dVm = [-.1:.001:.1];    %between -200 and 200 mV
dAh = F_PotassiumChannel.alpha(-.1);
dBh = F_PotassiumChannel.beta(-.1);
for i=-.099:.001:.1
    dAh = [dAh F_PotassiumChannel.alpha(i)];
    dBh = [dBh F_PotassiumChannel.beta(i)];
end
hold on
plot(dVm*1000, dAh,'-r', dVm*1000, dBh, '-g');
title('dynamics of n, alpha in red, beta in green');
uiwait;


dVm = [-.1:.001:.1];    %between -200 and 200 mV
ninf = F_PotassiumChannel.alpha(-.1)/(F_PotassiumChannel.alpha(-.1)+F_PotassiumChannel.beta(-.1));
for i=-.099:.001:.1
    ninf = [ninf (F_PotassiumChannel.alpha(i)/(F_PotassiumChannel.alpha(i)+F_PotassiumChannel.beta(i)))];
end
hold on
plot(dVm*1000, ninf,'-r');
title('Infinite time values of n');
uiwait;

t = [-.005:dt:.15];
Vm = -.0846;
I = channel.current(Vm);
n = channel.n_old;
for i =(-.005+dt):dt:.15
    Ii = channel.current(Vm);
    I = [I Ii];
    n = [n channel.n_old];
    if (i > 0)
        Vm = 0;
    end
end
hold on
plot(t*1000, I);
title('Potassium current (step from Vrest to 0mV at t = 0mS)');

