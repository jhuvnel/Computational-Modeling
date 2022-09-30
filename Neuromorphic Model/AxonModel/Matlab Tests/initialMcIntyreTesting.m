


Vm = [-80:1:80];


alpha_h = (0.34*(-(Vm+104)))./(1-(exp(1).^((Vm+104)/11)));
beta_h = 12.6./(1+(exp(1).^(-(Vm+21.8)/13.4)));

h_inf = alpha_h./(alpha_h+beta_h);

%plot(Vm, alpha_h);
%hold on;
%plot(Vm, beta_h, '-r');
plot(Vm, h_inf);