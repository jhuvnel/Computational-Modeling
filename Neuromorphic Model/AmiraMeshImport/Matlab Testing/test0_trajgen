%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

dist = 4;
pnt1 = [0;0;0];
pnt2 = [0;0.1;1];

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
vMatrix = [0 0 2;...
           0 2 0;...
           2 2 2];
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
tMatrix = [1;2;3;3];
bndMatrix = [1;...
             2;...
             3];
dMatrix = [1];


%plotTetDomain(tMatrix, vMatrix, 0, '-b');

contMatrix = [0;0;0];
%beginBnd = exampleBndMatrix(:,find(exampleBndID == 3));
%stopBnd = exampleBndMatrix(:,find(exampleBndID == 5));

g = FiberTrajGen(vMatrix, tMatrix, bndMatrix,bndMatrix,bndMatrix,contMatrix);

r = g.rayTriIntersection(0,pnt1,pnt2);

r

