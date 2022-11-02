%this file tests findUniqueVert routin in class FiberTrajGen
clear all;


%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
vMatrix = [1 0 -1 1;...
           1 10 -3 2;...
           1 5 1 8]
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
tMatrix = [1;2;3;4];
bndMatrix = [1 2 3 4 ; 2 3 4 1; 3 4 1 2];
dMatrix = [1];

g = FiberTrajGen(vMatrix, tMatrix, bndMatrix, dMatrix);

%g.edgeNeighbors(4,2)
