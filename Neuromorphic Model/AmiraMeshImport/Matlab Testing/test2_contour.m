%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
load vMatrix;
load bndMatrix;
load bndIDMatrix;
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
%tMatrix = [1;2;3;4];
%bndMatrix = [1 4;...
%             2 3;...
%             3 2];
%dMatrix = [1];

subBndMatrix = bndMatrix(:,find(bndIDMatrix == 1));

g = FiberTrajGen(vMatrix, [0;0;0;0], subBndMatrix, [0;0;0]);

g.flattenSeedSurface();

newVMatrix = g.seedValues();
hold off
hold on
plotTriSurf(bndMatrix, newVMatrix, 0, '-r');

g.findContour();
r = g.contourValues();

plotContour(r, newVMatrix, 1, '--')

