%% simulateWaveform2022.m
% A script, currently in testing, for simulating a single waveform based on
% a set of axon trajectories and FEM extracellular voltage solutions.
% Requires neuromorphic model java code in the javaclasspath. 

% add dynamic java class path
javaPath = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel';
javaclasspath(javaPath)

% import AxonModel.*

% load parameters, FEM solutions, trajectories, waveform, and current
slnFile = 'testSolution20221104.mat';
load(slnFile)

% choose an error file
errorFileTest = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\Matlab Scripts\ErrorFile20221111_2.txt';

%% Choose a an axon class to simulate


%% Run one waveform simulation

simClassTest = AxonSimulate_G_AHPAxon_CVStar0265();
tic
resultsTest = simulateWaveform(parameterTest,solutionBigCell{1},waveForm,traj_test2,simClassTest,errorFileTest);
toc
clear simClassTest

%% Testing Abder's saved data

% simClassRecreate = AxonSimulate_G_AHPAxon_CVStar0265();
simClassRecreate = AxonSimulate_SENN_AxonI();
% for some reason runs into an error if no errorFile is provided? Just
% input one for now
horSCC_SimCell{1} = simulateWaveform(parameterCellSCC_1to3,horSCC_PE1_LI1to3_SolutionCell,waveForm, traj, simClassRecreate,errorFileTest);
clear simClassRecreate