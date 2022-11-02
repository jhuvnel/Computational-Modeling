%test AxonSimulate
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');
clear java      %reload the class, incase we messed with it


maxIter = 20;
Vt = .090;
precision = 0.1;

%get the info to set up the solver
load solutionsCell;
load parameterCell;
load biphasicExampleWaveform;

simObject = AxonSimulate_SENN_AxonP();

disp('Beginning to simulate')
tic
result = findThresholdWaveform(parameterCell, solutionsCell, waveform, cell(2), simObject, 1, maxIter, Vt, precision);
toc