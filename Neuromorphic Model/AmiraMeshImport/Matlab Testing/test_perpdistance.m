%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

%define the ray
v0 = [0;0;0];
v1 = [10;0;0];

pnt = [10;8;10];

r = RHMath.perpDistance(v0, v1, pnt);

vR = v0 + (v1-v0)*r;

hold on
plot3(pnt(1),pnt(2),pnt(3), '-og');
plot3(vR(1),vR(2),vR(3), '-or');
plot3([vR(1) pnt(1)],[vR(2) pnt(2)],[vR(3) pnt(3)], '-b');
plot3([v0(1) v1(1)],[v0(2) v1(2)], [v0(3) v1(3)], '-b');
r