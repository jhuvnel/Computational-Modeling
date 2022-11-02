%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

pnt = [0.1;0.1;8];

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

g = FiberTrajGen(vMatrix, tMatrix, bndMatrix, dMatrix);

g.flattenSeedSurface();

newVMatrix = g.seedValues();
hold off
hold on
plotTetDomain(tMatrix, vMatrix, 0, '-b');
plot3(pnt(1),pnt(2),pnt(3), '-o');


r = RHMath.closestNode(pnt, vMatrix);
r = r+1;
plot3(vMatrix(1,r),vMatrix(2,r),vMatrix(3,r),'-ro');


