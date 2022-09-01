%get axial current at one place, axis is defined by the first two points,
%the actual location of evaulation is the third point
%Russell Hayden, 2007

function y = getAxisCurrent(fem, point1, point2, point3)
    lineVect = point2 - point1;           %from point1 to point2
    unitVect = lineVect/norm(lineVect);   %creat a unit vector
    p3 = [point3(1); point3(2); point3(3)];%make sure its a column vector
    currentX = postinterp(fem, 'Jx_dc', p3);
    currentY = postinterp(fem, 'Jy_dc', p3);
    currentZ = postinterp(fem, 'Jz_dc', p3);

    y = dot(unitVect, [currentX;currentY;currentZ]);    
