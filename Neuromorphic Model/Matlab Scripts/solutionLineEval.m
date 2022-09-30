%find the values of axial current along a line specified by the vector
%pointing from point1 to point2, values returned starting from point1 (i.e.
%element 1 is point 1, and the last element is near point2)
%dist = the length along the line to evaluate the next point
%don't make dist too small, 10 points can take about 45 seconds!
%fem = femstructure (with solution already included)
%Russell Hayden, 2007

function y = solutionLineEval(fem, point1, point2, dist)
    lineVect = point2 - point1;           %from point1 to point2
    lineLength = norm(lineVect);          
    unitVect = lineVect/norm(lineVect);   %creat a unit vector
    unitVect = [unitVect(1); unitVect(2); unitVect(3)];%make sure column vect
    p1 = [point1(1); point1(2); point1(3)];%make sure its a column vector
    
    AxialCurrent = 0;
    i = 0;
    while (i*dist < lineLength)
        currentDist = i*dist;
        currentPoint = unitVect*currentDist +p1;
        currentX = postinterp(fem, 'Jx_dc', currentPoint);
        currentY = postinterp(fem, 'Jy_dc', currentPoint);
        currentZ = postinterp(fem, 'Jz_dc', currentPoint);
        AxialCurrent(1, i+1) = dot(unitVect, [currentX;currentY;currentZ]);
        AxialCurrent(2, i+1) = currentDist;
        disp([num2str(i+1) ' of ' num2str(floor(lineLength/dist)+1) ' points calculated.'])
        i = i+1;
    end
    
    y = AxialCurrent;
        
