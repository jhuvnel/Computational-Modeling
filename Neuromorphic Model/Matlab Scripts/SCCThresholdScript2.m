%preload the solutions cell workspace and the waveform
%also preload all the parameter Cells

%baselineWav = waveForm*0;

%do the horizontal SCC first
rand('state',sum(100*clock));
temp = rand(150,1);
parameterCellSCC_1to3{6} = temp;
temp = rand(150,1);
parameterCellSCC_2to5{6} = temp;
temp = rand(150,1);
parameterCellSCC_3to5{6} = temp;
temp = rand(150,1);
parameterCellSCC_4to7{6} = temp;
temp = rand(150,1);
parameterCellSCC_5to8{6} = temp;
temp = rand(150,1);
parameterCellSCC_6to10{6} = temp;

load('MRIFE_HorSCC_100Traj_LocInd_1to3.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass1 = AxonSimulate_G_AHPAxon_CVStar0265();
horSCC_SimCell{1} = findThresholdWaveform(parameterCellSCC_1to3,horSCC_PE1_LI1to3_SolutionCell,waveForm, traj, simClass1, 'errorLog.txt');
clear simClass1;
clear traj;
load('MRIFE_HorSCC_100Traj_LocInd_3to5.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass2 = AxonSimulate_G_AHPAxon_CVStar0265();
horSCC_SimCell{2} = findThresholdWaveform(parameterCellSCC_3to5,horSCC_PE1_LI3to5_SolutionCell,waveForm, traj, simClass2, 'errorLog.txt');
clear simClass2;
clear traj;
load('MRIFE_HorSCC_100Traj_LocInd_5to8.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass3 = AxonSimulate_G_AHPAxon_CVStar1483();
horSCC_SimCell{3} = findThresholdWaveform(parameterCellSCC_5to8,horSCC_PE1_LI5to8_SolutionCell,waveForm, traj, simClass3, 'errorLog.txt');
clear simClass3;
clear traj;
load('MRIFE_HorSCC_110Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass4 = AxonSimulate_G_AHPAxon_CVStar5082();
horSCC_SimCell{4} = findThresholdWaveform(parameterCellSCC_6to10,horSCC_PE1_LI6to10_SolutionCell,waveForm, traj,simClass4, 'errorLog.txt');
clear simClass4;
clear traj;
disp('Half way through Horizontal SCC')
load('MRIFE_HorSCC_300Traj_LocInd_2to5.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass5 = AxonSimulate_G_AHPAxon_CVStar1483();
horSCC_SimCell{5} = findThresholdWaveform(parameterCellSCC_2to5,horSCC_PE1_LI2to5_SolutionCell,waveForm,traj,simClass5, 'errorLog.txt');
clear simClass5;
clear traj;
load('MRIFE_HorSCC_300Traj_LocInd_4to7.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass6 = AxonSimulate_G_AHPAxon_CVStar1483();
horSCC_SimCell{6} = findThresholdWaveform(parameterCellSCC_4to7,horSCC_PE1_LI4to7_SolutionCell,waveForm,traj,simClass6, 'errorLog.txt');
clear simClass6;
clear traj;
disp('Done with Horizontal SCC')
%protect against crash
save 'HorSCCDone'
rand('state',sum(100*clock));
temp = rand(150,1);
parameterCellSCC_1to3{6} = temp;
temp = rand(150,1);
parameterCellSCC_2to5{6} = temp;
temp = rand(150,1);
parameterCellSCC_3to5{6} = temp;
temp = rand(150,1);
parameterCellSCC_4to7{6} = temp;
temp = rand(150,1);
parameterCellSCC_5to8{6} = temp;
temp = rand(150,1);
parameterCellSCC_6to10{6} = temp;

%do posterior SCC
load('MRIFE_PosScc_100Traj_LocInd_1to3.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass7 = AxonSimulate_G_AHPAxon_CVStar0265();
posSCC_SimCell{1} = findThresholdWaveform(parameterCellSCC_1to3,posSCC_PE1_LI1to3_SolutionCell,waveForm,traj,simClass7, 'errorLog.txt');
clear simClass7;
clear traj;
load('MRIFE_PosSCC_100Traj_LocInd_3to5.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass8 = AxonSimulate_G_AHPAxon_CVStar0265();
posSCC_SimCell{2} = findThresholdWaveform(parameterCellSCC_3to5,posSCC_PE1_LI3to5_SolutionCell,waveForm,traj,simClass8, 'errorLog.txt');
clear simClass8;
clear traj;
load('MRIFE_PosSCC_100Traj_LocInd_5to8.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass9 = AxonSimulate_G_AHPAxon_CVStar1483();
posSCC_SimCell{3} = findThresholdWaveform(parameterCellSCC_5to8,posSCC_PE1_LI5to8_SolutionCell,waveForm,traj,simClass9, 'errorLog.txt');
clear simClass9;
clear traj;
load('MRIFE_PosSCC_110Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass10 = AxonSimulate_G_AHPAxon_CVStar5082();
posSCC_SimCell{4} = findThresholdWaveform(parameterCellSCC_6to10,posSCC_PE1_LI6to10_SolutionCell,waveForm,traj,simClass10, 'errorLog.txt');
clear simClass10;
clear traj;
load('MRIFE_PosSCC_300Traj_LocInd_2to5.mat');
traj = traj(1:(size(traj,1)/2),:);
disp('Half way through Posterior SCC')
simClass11 = AxonSimulate_G_AHPAxon_CVStar1483();
posSCC_SimCell{5} = findThresholdWaveform(parameterCellSCC_2to5,posSCC_PE1_LI2to5_SolutionCell,waveForm,traj,simClass11, 'errorLog.txt');
clear simClass11;
clear traj;
load('MRIFE_PosSCC_300Traj_LocInd_4to7.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass12 = AxonSimulate_G_AHPAxon_CVStar1483();
posSCC_SimCell{6} = findThresholdWaveform(parameterCellSCC_4to7,posSCC_PE1_LI4to7_SolutionCell,waveForm,traj,simClass12, 'errorLog.txt');
clear simClass12;
clear traj;
disp('Done with Posterior SCC')
save 'PosSCCDone'
rand('state',sum(100*clock));
temp = rand(150,1);
parameterCellSCC_1to3{6} = temp;
temp = rand(150,1);
parameterCellSCC_2to5{6} = temp;
temp = rand(150,1);
parameterCellSCC_3to5{6} = temp;
temp = rand(150,1);
parameterCellSCC_4to7{6} = temp;
temp = rand(150,1);
parameterCellSCC_5to8{6} = temp;
temp = rand(150,1);
parameterCellSCC_6to10{6} = temp;

%do superior SCC
load('MRIFE_SupSCC_100Traj_LocInd_1to3.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass13 = AxonSimulate_G_AHPAxon_CVStar0265();
supSCC_SimCell{1} = findThresholdWaveform(parameterCellSCC_1to3,supSCC_PE1_LI1to3_SolutionCell,waveForm,traj,simClass13, 'errorLog.txt');
clear simClass13;
clear traj;
load('MRIFE_SupSCC_100Traj_LocInd_3to5.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass14 = AxonSimulate_G_AHPAxon_CVStar0265();
supSCC_SimCell{2} = findThresholdWaveform(parameterCellSCC_3to5,supSCC_PE1_LI3to5_SolutionCell,waveForm,traj,simClass14, 'errorLog.txt');
clear simClass14;
clear traj;
load('MRIFE_SupSCC_100Traj_LocInd_5to8.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass15 = AxonSimulate_G_AHPAxon_CVStar1483();
supSCC_SimCell{3} = findThresholdWaveform(parameterCellSCC_5to8,supSCC_PE1_LI5to8_SolutionCell,waveForm,traj,simClass15, 'errorLog.txt');
clear simClass15;
clear traj;
load('MRIFE_SupSCC_110Traj_LocInd_6to10.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass16 = AxonSimulate_G_AHPAxon_CVStar5082();
supSCC_SimCell{4} = findThresholdWaveform(parameterCellSCC_6to10,supSCC_PE1_LI6to10_SolutionCell,waveForm,traj,simClass16, 'errorLog.txt');
clear simClass16;
clear traj;
disp('Half way through Superior SCC')
load('MRIFE_SupSCC_300Traj_LocInd_2to5.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass17 = AxonSimulate_G_AHPAxon_CVStar1483();
supSCC_SimCell{5} = findThresholdWaveform(parameterCellSCC_2to5,supSCC_PE1_LI2to5_SolutionCell,waveForm,traj,simClass17, 'errorLog.txt');
clear simClass17;
clear traj;
load('MRIFE_SupSCC_300Traj_LocInd_4to7.mat');
traj = traj(1:(size(traj,1)/2),:);
simClass18 = AxonSimulate_G_AHPAxon_CVStar1483();
supSCC_SimCell{6} = findThresholdWaveform(parameterCellSCC_4to7,supSCC_PE1_LI4to7_SolutionCell,waveForm,traj,simClass18, 'errorLog.txt');
clear simClass18;
clear traj;
save 'AllDone'
disp('Done with Superior SCC')

