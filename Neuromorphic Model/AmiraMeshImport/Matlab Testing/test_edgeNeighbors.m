%this file tests findUniqueVert routin in class FiberTrajGen
clear all;


vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
tMatrix = [1;2;3;4];
bndMatrix = [1 2 3 4 5; 2 3 4 1 4; 3 4 1 2 3];
dMatrix = [1];

g = FiberTrajGen(vMatrix, tMatrix, bndMatrix, dMatrix);

g.edgeNeighbors(4,2)
