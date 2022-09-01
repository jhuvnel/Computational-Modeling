%create a poisson process with a given step size and rate
clear all;
deltaT = 0.1;   %0.1mS
lambda = 550; %2.65e5 second axon in table 1 of smith/goldberg
numCounts = 200;    %number of counts to calculate for
numStart = 100;
numEnd = 300;

result = zeros(numCounts+1,1);
for i = 0:numCounts
    result(i+1) = (((lambda*deltaT)^i)*exp(-lambda*deltaT))/factorial(i);
end
plot(result);
figure
resultCDF = poissonDistributionArray(lambda, deltaT, .005);
plot(resultCDF, '-r');

