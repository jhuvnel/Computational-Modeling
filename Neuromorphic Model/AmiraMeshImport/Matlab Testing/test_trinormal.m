%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

distSamp = 0.1;

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
vMatrix = [0 1 0 0;...
           0 0 1 0;...
           0 0 0 1];
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
tMatrix = [1;2;3;4];
bndMatrix = [1 4;...
             2 3;...
             3 1];
dMatrix = [1];


g = FiberTrajGen(vMatrix, tMatrix, bndMatrix,bndMatrix,bndMatrix,[0;0;0]);

g.outerTriNormals(:,1)
g.outerTriNormals(:,2)

