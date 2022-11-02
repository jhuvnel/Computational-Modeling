%this file tests findUniqueVert routin in class FiberTrajGen
clear all;


vMatrix = [0 1 0 0; 0 0 1 0; 0 0 0 1];
tMatrix = [1;2;3;4];
bndMatrix = [1 2 3 4; 2 3 4 1; 3 4 1 2];
dMatrix = [1];

g = FiberTrajGen(vMatrix, tMatrix, bndMatrix, dMatrix);

g.tMatrix
tMatrix
