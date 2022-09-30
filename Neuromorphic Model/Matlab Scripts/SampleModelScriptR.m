
%do the horizontal SCC first
load('rhesus_ntraj_hor_Central Calyx.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_1_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_hor_Intermediate Calyx.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_2_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_hor_Central Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_3_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_hor_Intermediate Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_4_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Half way through Horizontal SCC')
load('rhesus_ntraj_hor_Peripheral Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_hor_Intermediate Bouton.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_6_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_hor_Peripheral Bouton.mat');
traj = traj(1:(size(traj,1)/2),:);
horSCC_7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Horizontal SCC')
%protect against crash
save 'HorSCCDone'


%do posterior SCC
load('rhesus_ntraj_post_Central Calyx.mat');
traj = traj(1:(size(traj,1)/2),:);
postSCC_1_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_post_Intermediate Calyx.mat');
traj = traj(1:(size(traj,1)/2),:);
postSCC_2_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_post_Central Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
postSCC_3_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_post_Intermediate Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
postSCC_4_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Half way through Posterior SCC')
load('rhesus_ntraj_post_Peripheral Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
postSCC_5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_post_Intermediate Bouton.mat');
traj = traj(1:(size(traj,1)/2),:);
postSCC_6_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_post_Peripheral Bouton.mat');
traj = traj(1:(size(traj,1)/2),:);
postSCC_7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Posterior SCC')
%protect against crash
save 'postSCCDone'


%do superior SCC
load('rhesus_ntraj_sup_Central Calyx.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_1_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_sup_Intermediate Calyx.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_2_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_sup_Central Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_3_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_sup_Intermediate Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_4_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Half way through Superior SCC')
load('rhesus_ntraj_sup_Peripheral Dimorphic.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_5_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_sup_Intermediate Bouton.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_6_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
load('rhesus_ntraj_sup_Peripheral Bouton.mat');
traj = traj(1:(size(traj,1)/2),:);
supSCC_7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
clear traj;
disp('Done with Superior SCC')
%protect against crash
save 'supSCCDone'


% load('MRIFE_utricle_300Traj_LocInd_1to4.mat');
% traj = traj(1:(size(traj,1)/2),:);
% utricle_LI1to4_SolutionCell = sampleModelSolution(fem, traj, current, 0);
% clear traj;
% load('MRIFE_utricle_300Traj_LocInd_3to7.mat');
% traj = traj(1:(size(traj,1)/2),:);
% utricle_LI3to7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
% clear traj;
% load('MRIFE_utricle_300Traj_LocInd_6to10.mat');
% traj = traj(1:(size(traj,1)/2),:);
% utricle_LI6to10_SolutionCell = sampleModelSolution(fem, traj, current, 0);
% clear traj;
% disp('Done with Utricle')
% 
% load('MRIFE_saccule_300Traj_LocInd_1to4.mat');
% traj = traj(1:(size(traj,1)/2),:);
% saccule_LI1to4_SolutionCell = sampleModelSolution(fem, traj, current, 0);
% clear traj;
% load('MRIFE_saccule_300Traj_LocInd_3to7.mat');
% traj = traj(1:(size(traj,1)/2),:);
% saccule_LI3to7_SolutionCell = sampleModelSolution(fem, traj, current, 0);
% clear traj;
% load('MRIFE_saccule_300Traj_LocInd_6to10.mat');
% traj = traj(1:(size(traj,1)/2),:);
% saccule_LI6to10_SolutionCell = sampleModelSolution(fem, traj, current, 0);
% clear traj;
% disp('Done with Sacculus')

save 'AllDone'



