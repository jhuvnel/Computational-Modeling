%this test was created to test the sodium synaptic input characteristics of
%the goldberg channel

clear all;
clear java      %reload the class, incase we messed with it
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');

numIters = 100000;
node = G_AHPChannel_CVStar0265(10e-6, 2e-6, 1e-7);

%node.gk0 = 0;

result = zeros(numIters, 1);
for i=1:numIters
    result(i) = node.current(0);
end

plot(result);
