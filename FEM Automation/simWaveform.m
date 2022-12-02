%% simWaveform.m
% A script, currently in testing, for simulating waveforms based on a set
% of axon trajectories, solution cells, and waveform.
% Requires neuromorphic model java code in the javaclasspath. Specify the 
% folder with the neuromorphic model in the javaPath variable. 
% November 2022, Evan Vesper, VNEL


% add dynamic java class path
% note - running javaclasspath again is necessary if you want to update the
% java .class files that Matlab uses, such as if you are debugging them.
% For this to work, you must have no java objects in the Matlab workspace
% and also run javaclasspath(javaPath) to reset the dynamic path. This will
% grab the current version of the .class files in the javaPath location.
% Remember to build the newest version of your java class (using your java
% IDE) before running this.
javaPath = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel';
javaclasspath('-v1') % set to diplay where javaclasspath is looking for classes (optional)
javaclasspath(javaPath) % set dynamic path (necessary if you changed the java classes)
javaclasspath('-dynamic') % display dynamic path (optional)

% load parameters, FEM solutions, trajectories, waveform, and current
slnFile = 'testSolution16-Nov-2022.mat';
load(slnFile)

% choose an error file
errorFileTest = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\ErrorFile20221117.txt';




%% Run one waveform simulation

% Choose a an axon class to simulate
simClassTest = AxonSimulate_G_AHPAxon_CVStar0265;
% simClassTest = javaObject('AxonSimulate_G_AHPAxon_CVStar0265',[]); % should do same thing as previous 
tic
resultsTest = simulateWaveform(parameterTest,solutionBigCell{1},waveForm,traj_test2,simClassTest,errorFileTest);
toc
clear simClassTest

%% Run waveform simulation for all FEM solution sets

% Choose a an axon class to simulate
nSol = length(solutionBigCell);
results = cell(1,nSol);
simClass = cell(1,nSol);

tic
for i = 1:nSol
    simClass{i} = AxonSimulate_G_AHPAxon_CVStar0265;
    results{i} = simulateWaveform(parameterTest,solutionBigCell{i},waveForm,traj_test2,simClass{i},errorFileTest);
end
toc
clear simClass

%% Save results
fileDate = date;
save(['waveformSimResults_',fileDate],'resultsTest','results','parameterTest')
%% Testing Abder's saved data
% abderDataFile = 'R:\Abder-Hedj\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts\first results workspace';
% load(abderDataFile)
% 
% % simClassRecreate = AxonSimulate_G_AHPAxon_CVStar0265();
% simClassRecreate = AxonSimulate_SENN_AxonI();
% % for some reason runs into an error if no errorFile is provided? Just
% % input one for now
% horSCC_SimCell{1} = simulateWaveform(parameterCellSCC_1to3,horSCC_PE1_LI1to3_SolutionCell,waveForm, [], simClassRecreate,errorFileTest);
% clear simClassRecreate