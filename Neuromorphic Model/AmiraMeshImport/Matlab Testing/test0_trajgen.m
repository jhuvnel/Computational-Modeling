%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

offset = 0.2;
step = 0.25;
locIndex = 5;
endDist = 0.3;
nominalRadius = 1;
maxIter = 10000;


vMatrix = [1 1 1 0 0   -1  0;...
           0 1 0 0 0   0   1;...
           0 0 1 0 0.5 0.5 0.5];

tMatrix = [1;...
           2;...
           3;...
           4];

       
contMatrix =     [2     1   -1;...
                  0.3 0.3 0.3;...
                  0.3 0.3 0.3];
       
       
bndStartMatrix = [1;...
             2;...
             3];

bndMatrix = [1 5;...
             2 6;...
             3 7];


g = FiberTrajGen(vMatrix, tMatrix, bndStartMatrix, bndMatrix,contMatrix);

r = g.generateTrajectory(step, locIndex, offset, endDist, nominalRadius, maxIter);



%plot the contour
plotTraj(contMatrix, 0, '-ob');
plotTraj(r, 0, '-*r');
plotTriSurf(bndMatrix, vMatrix, 0, '-b');
plotTriSurf(bndStartMatrix, vMatrix, 0, '-g');

