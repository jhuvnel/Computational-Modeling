%% simulateWaveform2022.m
% A script, currently in testing, for simulating a single waveform based on
% a set of axon trajectories and FEM extracellular voltage solutions.
% Requires neuromorphic model java code in the javaclasspath. 

% add dynamic java class path
javaPath = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel';
javaclasspath(javaPath)

% load parameters, FEM solutions, trajectories, waveform, and current
slnFile = 'testSolution20221104.mat';
load(slnFile)

% choose an error file
errorFileTest = 'ErrorFile20221104.txt';

%% Choose a an axon class to simulate
simClassTest = AxonSimulate_G_AHPAxon_CVStar0265();

%% Run one waveform simulation
tic
resultsTest = simulateWaveform(parameterTest,solutionBigCell{1},waveForm,traj_test2,simClassTest,errorFileTest);
toc

%% Testing Abder's saved data
clear simClass1
simClass1 = AxonSimulate_G_AHPAxon_CVStar0265();
horSCC_SimCell{1} = simulateWaveform(parameterCellSCC_1to3,horSCC_PE1_LI1to3_SolutionCell,waveForm, traj, simClass1,0);