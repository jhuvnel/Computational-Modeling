%find the approximate numerical second derivative for the vector "data" 
%step is the distance (or time) between data points
%First and Last element of the returned vector are not defined, so they are
%set to the second and second-to-last values respectively

function y = secondDerivative(data, step)
    temp = 0;
    for i = 2:(max(size(data))-1)
        temp(i) = (data(i+1)-(2*data(i))+data(i-1))/(step*step);
    end
    temp(1) = temp(2);
    temp(max(size(data))) = temp(max(size(data))-1);
    y=temp;
    