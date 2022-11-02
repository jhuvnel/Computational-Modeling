%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
%load vMatrix;
%load bndMatrix;
%load bndIDMatrix;
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
%tMatrix = [1;2;3;4];
%bndMatrix = [1 4;...
%             2 3;...
%             3 2];
%dMatrix = [1];

load ExampleGrid;

contMatrix = [0;0;0];
beginBnd = exampleBndMatrix(:,find(exampleBndID == 3));
stopBnd = exampleBndMatrix(:,find(exampleBndID == 5));

g = FiberTrajGen(exampleVMatrix, exampleTMatrix, beginBnd,stopBnd,exampleBndMatrix,contMatrix);

%downsample the surface
DSbndMatrix = exampleBndMatrix(:,1:10:size(exampleBndMatrix,2));
plotTriSurf(DSbndMatrix, exampleVMatrix, 0, '-b');




