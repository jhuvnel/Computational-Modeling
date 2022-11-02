%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

tri = [1;2;4];

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
vMatrix = [0 0 1 2 2;...
           0 1 0 2 2;...
           1 1 1 2 0];
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
tMatrix = [1 2;...
           2 3;...
           3 4;...
           4 5];
bndMatrix = [1 4 1;...
             2 3 2;...
             3 2 4];
dMatrix = [1];


%hold off
%hold on
%plotTetDomain(tMatrix, vMatrix, 0, '-b');
%plotTriSurf(tri,vMatrix,0,'-r');

contMatrix = [0;0;0];

g = FiberTrajGen(vMatrix, tMatrix, bndMatrix,bndMatrix,contMatrix);
tri = tri-1;    %convert to java indexing convention
r = g.findUniqueVert(tri(1),tri(2),tri(3), 0);

r