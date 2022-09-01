
%do the horizontal SCC first
load('MRIFE_HorSCC_100Traj_LocInd_1to3.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_PE1_LI1to3_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_HorSCC_100Traj_LocInd_3to5.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_PE1_LI3to5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_HorSCC_100Traj_LocInd_5to8.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_PE1_LI5to8_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_HorSCC_110Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_PE1_LI6to10_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Half way through Horizontal SCC')
load('MRIFE_HorSCC_300Traj_LocInd_2to5.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_PE1_LI2to5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_HorSCC_300Traj_LocInd_4to7.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_PE1_LI4to7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Horizontal SCC')
%protect against crash
save 'HorSCCDone'
%do posterior SCC
load('MRIFE_PosScc_100Traj_LocInd_1to3.mat');
traj = traj(1:(size(traj,1)/2),:);
posSCC_PE1_LI1to3_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_PosSCC_100Traj_LocInd_3to5.mat');
traj = traj(1:(size(traj,1)/2),:);
posSCC_PE1_LI3to5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_PosSCC_100Traj_LocInd_5to8.mat');
traj = traj(1:(size(traj,1)/2),:);
posSCC_PE1_LI5to8_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_PosSCC_110Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
posSCC_PE1_LI6to10_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_PosSCC_300Traj_LocInd_2to5.mat');
traj = traj(1:(size(traj,1)/2),:);
disp('Half way through Posterior SCC')
posSCC_PE1_LI2to5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_PosSCC_300Traj_LocInd_4to7.mat');
traj = traj(1:(size(traj,1)/2),:);
posSCC_PE1_LI4to7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Posterior SCC')
save 'PosSCCDone'
%do superior SCC
load('MRIFE_SupSCC_100Traj_LocInd_1to3.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_PE1_LI1to3_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_SupSCC_100Traj_LocInd_3to5.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_PE1_LI3to5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_SupSCC_100Traj_LocInd_5to8.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_PE1_LI5to8_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_SupSCC_110Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_PE1_LI6to10_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Half way through Superior SCC')
load('MRIFE_SupSCC_300Traj_LocInd_2to5.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_PE1_LI2to5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_SupSCC_300Traj_LocInd_4to7.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_PE1_LI4to7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Superior SCC')


load('MRIFE_utricle_300Traj_LocInd_1to4.mat');
traj = traj(1:(size(traj,1)/2),:);
utricle_LI1to4_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_utricle_300Traj_LocInd_3to7.mat');
traj = traj(1:(size(traj,1)/2),:);
utricle_LI3to7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_utricle_300Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
utricle_LI6to10_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Utricle')

load('MRIFE_saccule_300Traj_LocInd_1to4.mat');
traj = traj(1:(size(traj,1)/2),:);
saccule_LI1to4_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_saccule_300Traj_LocInd_3to7.mat');
traj = traj(1:(size(traj,1)/2),:);
saccule_LI3to7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('MRIFE_saccule_300Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
saccule_LI6to10_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Sacculus')

save 'AllDone'



