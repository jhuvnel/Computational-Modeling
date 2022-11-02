%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

distSamp = 0.1;

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
vMatrix = [0 0 1 2;...
           0 1 0 2;...
           1 1 1 2];
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
tMatrix = [1;2;3;4];
bndMatrix = [1 4;...
             2 3;...
             3 2];
dMatrix = [1];


hold off
hold on
plotTetDomain(tMatrix, vMatrix, 0, '-b');

g = MeshRework();
tMatrix = tMatrix-1;
g.tMatrix = tMatrix;

pnts = g.gridSampleComsol(distSamp, vMatrix);

for i = 1:size(pnts,2)
    plot3(pnts(1,i),pnts(2,i), pnts(3,i),'-*r');
end

