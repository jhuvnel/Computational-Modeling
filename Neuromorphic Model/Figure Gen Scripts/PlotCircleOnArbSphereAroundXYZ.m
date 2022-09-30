function h = PlotCircleOnArbSphereAroundXYZ(xyzcolumnvect,r,R,formatstring)
% x,y,z are coordinates of a normal vector in 3 space
% r is the radius for a circle to be draw perpendicular to xyzcolumnvect=[x,y,z] on the unit sphere
% for the Blanks-redo poster, I'll choose r to be:
%
% psi= geometric mean of standard devs of angles from X, Y and Z axes to canal normal
%
%r ~ R * sin (psi in radians), where R = radius of  sphere = 0.5 for my
%plots

%First create an [x y z] matrix defining a circle halo about the z axis at
%R from xy plane
th = 0:pi/50:2*pi;
xcirc = r * cos(th);
ycirc = r * sin(th);
zcirc = R*ones(1,length(th));  %need to plot this on a 0.5 radius sphere, not a unit sphere
XYZcirc=[xcirc; ycirc; zcirc]; %3x100

% now compute azimuth and elevation by which we'll move the circle from the
% z axis to the xyz vector
rho=sqrt(xyzcolumnvect'*xyzcolumnvect);  %(xin*xin + yin*yin + zin*zin);
x=xyzcolumnvect(1);
y=xyzcolumnvect(2);
z=xyzcolumnvect(3);
az_from_xaxis=atan2(y,x);
elev_descending_from_zaxis=acos(z/rho);

XYZcirc=rotZ3(az_from_xaxis)*rotY3(elev_descending_from_zaxis)*XYZcirc;
hold on
h = plot3(XYZcirc(1,:), XYZcirc(2,:), XYZcirc(3,:),formatstring);
hold off


function [rotZ3] =  rotZ3(a)
rotZ3= [cos(a) sin(-a)  0;
       sin(a) cos(a)   0;
       0        0      1];
  return 
   
function [rotY3] =  rotY3(a)
rotY3= [cos(a)  0  sin(a);
         0      1   0;
        -sin(a) 0   cos(a)];
   return
   
function [rotX3] =  rotX3(a)
rotX3= [1       0        0;
       0      cos(a)  -sin(a);
       0      sin(a)  cos(a)];
   return