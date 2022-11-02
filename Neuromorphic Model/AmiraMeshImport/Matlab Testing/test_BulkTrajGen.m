%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it

num2Gen = 15;
fileName = 'trajGenTest_';

offset = 0.25;
step = [0.5; 1; -1];
locIndex = [5; 2; 9; 1; -1];       %0 is the periphery, 10 is the center contour line
endDist = 3;
nominalRadius = 2;    %3
maxIter = 100000;
maxOutOfSub = 5;

bndSelect = 3;  %3 is the superior nerve crista


%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
load fullVMatrix;
load fullBndMatrix;
load fullBndIDMatrix;
load fullTMatrix;
load fullDMatrix;
load('superiorNerveContourV2.txt');


%assemble the nerve tet matrix
newTMatrix = fullTMatrix(:, find(fullDMatrix == 4));    %sup nerve = material 4
newTMatrix = [newTMatrix fullTMatrix(:, find(fullDMatrix == 2))]; %paraflocculus = mat 2

disp ('Preprocessing data...')
g = FiberTrajGen(fullVMatrix, newTMatrix, fullBndMatrix(:,find(fullBndIDMatrix==bndSelect)), fullBndMatrix,superiorNerveContourV2);
%g.subdomainTestOff();
numSec = num2Gen * 5;   %about 5 seconds per is pretty good estimate on my machine
disp(['Generating Trajectories.  ETA = ' num2str(numSec) ' seconds'])
r = g.bulkGenerateTrajectory(num2Gen, step, locIndex, offset, endDist, nominalRadius, maxIter, maxOutOfSub);
for i = 1:num2Gen
    saveascii(r{i}, [fileName num2str(i) '.txt'], 10, ' ');
end

%save each one

%plot the contour
%plotTraj(superiorNerveContour, 0, '-ob');
%plotTraj(r, 0, '-*r');
%plotTriSurf(fullBndMatrix(:,find(fullBndIDMatrix==bndSelect)), fullVMatrix, 0, '-g');


