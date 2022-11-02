%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

pnt = [0.1;0.1;8];

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
vMatrix = [0 0 1 2;...
           0 1 0 5;...
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


r = RHMath.boundingBox(vMatrix);

disp(['Min/max x: ' num2str(r(1,1)) '  ' num2str(r(2,1))])
disp(['Min/max y: ' num2str(r(1,2)) '  ' num2str(r(2,2))])
disp(['Min/max z: ' num2str(r(1,3)) '  ' num2str(r(2,3))])

