%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

pnt = [0;1;10];
id = 2;

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
vMatrix = [0 0 1 2;...
           0 1 0 2;...
           1 1 1 2];
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
tMatrix = [1;2;3;4];
bndMatrix = [1 4 1 1;...
             2 3 2 3;...
             3 2 4 4];
dMatrix = [1];
bndIDMatrix = [1 2 3 4];

g = FiberTrajGen(vMatrix, tMatrix, bndMatrix, bndMatrix);

hold off
hold on
plotTetDomain(tMatrix, vMatrix, 0, '-b');
plotTriSurf(bndMatrix(:,find(bndIDMatrix == id)) ,vMatrix, 0, '-r');

r = g.distToBnd(pnt, id);
plot3(pnt(1),pnt(2),pnt(3),'-og');
plot3(vMatrix(1,r(2)+1),vMatrix(2,r(2)+1),vMatrix(3,r(2)+1), '-or');

disp(['Distance to closest bnd vertex: ' num2str(r(1))])

