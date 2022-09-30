%find the rotation matrix to go from material coordinates to simulation
%world coordinates (rotates the material x-axis (nerve longitudinal axis) to the vector the two points create).  
%So the final matrix to be typed into COMSOL is:
%(this matrix (y))*(anisotropic material matrix)*(transpose of this matrix(y'))
%Author: Russell Hayden, russhayden@hotmail.com, 2007

function y = AnisoRotationMatrix(point1, point2)
    vector = point2 - point1;       %from point1 to point2
    vector = vector/norm(vector);   %creat a unit vector

    %calculate the rotation axis
    Raxis = cross([1,0,0],vector);
    if (norm(Raxis) == 0)
        y = [1,0,0;0,1,0;0,0,1];  %incase we are already along the x-axis
        return;
    end
    Raxis = Raxis/norm(Raxis);
    x = Raxis(1); y = Raxis(2); z = Raxis(3);
    
    %now calculate the angle to rotate through
    theta = acos(vector(1));        %dot product with unit x-vector
    
    %now create rotation matrix (nice read about this on wikipedia.com)
    c11 = cos(theta) + (1-cos(theta))*x*x;
    c12 = (1-cos(theta))*y*x + sin(theta)*z;
    c13 = (1-cos(theta))*z*x - sin(theta)*y;
    c21 = (1-cos(theta))*x*y - sin(theta)*z;
    c22 = cos(theta) + (1-cos(theta))*y*y;
    c23 = (1-cos(theta))*z*y + sin(theta)*x;
    c31 = (1-cos(theta))*x*z + sin(theta)*y;
    c32 = (1-cos(theta))*y*z - sin(theta)*x;
    c33 = cos(theta) + (1-cos(theta))*z*z;
    
    y = [c11, c21, c31; c12, c22, c32; c13, c23, c33];
    
