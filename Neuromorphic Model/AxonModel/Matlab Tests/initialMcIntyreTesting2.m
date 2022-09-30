

Vm = [-100:1:100];

alpha_h = ((0.0336*(-(Vm+118)))./(1-(exp(1).^((Vm+118)/11))))*(2.9^(17/10));
beta_h = (2.3./(1+(exp(1).^(-(Vm+35.8)./13.4))))*(2.8^(17/10));

h_inf = alpha_h./(alpha_h+beta_h);

%plot(Vm, alpha_h);
%hold on;
%plot(Vm, beta_h, '-r');
plot(Vm, h_inf);