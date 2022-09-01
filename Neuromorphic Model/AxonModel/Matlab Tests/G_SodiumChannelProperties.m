%this tests the properties of the sodium channel
clear all;
clear java      %reload the class, incase we messed with it
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');

%parameters
nd = 10e-6;     %node diameter
nl = 10e-6;     %node length
dt = 1e-6;      %time increment


channel = G_SodiumChannel(nd, nl, dt);

%first plot the alpha / beta curves for each gate

dVm = [-.1:.001:.1];    %between -200 and 200 mV
dAh = G_SodiumChannel.alpha_h(-.1);
dBh = G_SodiumChannel.beta_h(-.1);
for i=-.099:.001:.1
    dAh = [dAh G_SodiumChannel.alpha_h(i)];
    dBh = [dBh G_SodiumChannel.beta_h(i)];
end
hold on
plot(dVm*1000, dAh,'-r', dVm*1000, dBh, '-g');
title('dynamics of h, alpha in red, beta in green');
uiwait;

dVm = [-.1:.001:.1];    %between -200 and 200 mV
dAm = G_SodiumChannel.alpha_m(-.1);
dBm = G_SodiumChannel.beta_m(-.1);
for i=-.099:.001:.1
    dAm = [dAm G_SodiumChannel.alpha_m(i)];
    dBm = [dBm G_SodiumChannel.beta_m(i)];
end
hold on
plot(dVm*1000, dAm,'-r', dVm*1000, dBm, '-g');
title('dynamics of m, alpha in red, beta in green');
uiwait;

dVm = [-.1:.001:.1];    %between -200 and 200 mV
minf = G_SodiumChannel.alpha_m(-.1)/(F_SodiumChannel.alpha_m(-.1)+F_SodiumChannel.beta_m(-.1));
hinf = G_SodiumChannel.alpha_h(-.1)/(F_SodiumChannel.alpha_h(-.1)+F_SodiumChannel.beta_h(-.1));
for i=-.099:.001:.1
    minf = [minf (G_SodiumChannel.alpha_m(i)/(G_SodiumChannel.alpha_m(i)+G_SodiumChannel.beta_m(i)))];
    hinf = [hinf (G_SodiumChannel.alpha_h(i)/(G_SodiumChannel.alpha_h(i)+G_SodiumChannel.beta_h(i)))];
end
hold on
plot(dVm*1000, minf,'-r', dVm*1000, hinf, '-g');
title('Infinite time values of m (red) and h (green)');
uiwait;

t = [-.005:dt:.010];
Vm = -.0846;
I = channel.current(Vm);
m = channel.m_old;
h = channel.h_old;
for i =(-.005+dt):dt:.01
    Ii = channel.current(Vm);
    I = [I Ii];
    m = [m channel.m_old];
    h = [h channel.h_old];
    if (i > 0)
        Vm = 0;
    end
end
hold on
plot(t*1000, I);
title('Sodium current (step from Vrest to 0mV at t = 0mS)');

