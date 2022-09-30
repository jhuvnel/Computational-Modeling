%this function calculates and returns an array of the cumulative posson distribution
% function of given parameters lambda and sample time (Poisson rate = lambda*sampleTime)
% lambda = rate of a poisson process, sampleTime = time increments in which one samples
% that poisson process
% precision = how close the CDF should get before finishing (a small number will
% result in a very large array)
%
function y = poissonDistributionArray(lambda, sampleTime, precision)
    %you can save memory by calculating this once, and then feeding the same
	%array pointer to all Java classes that use it (so they all share the same array
	%instead of each having a copy)
	rate = sampleTime*lambda;	%calculate the poisson rate
	%calculate the first value
	tempValue = exp(-rate);
	result = tempValue;
    lastValue = tempValue;
	iterator = 0;
	flagDone = 0;
    while (flagDone==0)		%iterate until we reach precision
		%calculate the value of the distribution
		iterator = iterator + 1;
		tempValue = exp(-rate) * (rate^iterator);
        tempValue = tempValue/factorial(iterator);
        %add it with the previous element
        tempValue = tempValue + lastValue;
        result = [result; tempValue];
        if ((tempValue + precision) > 1)
            flagDone = 1;
        end
        lastValue = tempValue;
    end
    y = result;
		

	

