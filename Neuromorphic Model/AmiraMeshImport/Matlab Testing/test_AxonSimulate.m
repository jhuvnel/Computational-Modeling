%test AxonSimulate
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');
clear java      %reload the class, incase we messed with it

%get the info to set up the solver
load solutionsCell;
load parameterCell;
load biphasicExampleWaveform;

simObject = AxonSimulate_SENN_AxonP();
simObject = initAxonSimulate(parameterCell, solutionsCell, simObject);

disp('Beginning to simulate')
tic
result = simObject.compute(waveform*100, -1);
toc
