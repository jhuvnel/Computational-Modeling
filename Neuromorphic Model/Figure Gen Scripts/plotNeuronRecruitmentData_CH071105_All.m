%this plots the neuron model's selectivity prediction
%NOTE: WE DID NOT USE FILE6 because its about the same as FILE5
clear all
currentScaleCorrection = 1;
save currentScaleCorrection;

clear all

%Monopolar LP e1ve7 200uS250uA
SimVector = [23;13.3;42.1];      %[LA;LH;LP]
load Ch071105_MonPost1e1ve7_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load Ch071105_MonPost1e1ve7_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonPost1 vs e1ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonPost1 vs e1ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonPost1 vs e1ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%Monopolar LP e1ve7 200uS250uA
SimVector = [23;13.3;42.1];      %[LA;LH;LP]
load ch071105_MonPost2e0ve7_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonPost2e0ve7_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonPost2 vs e1ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonPost2 vs e1ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonPost2 vs e1ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%LH monopolar e2ve7 200uS250uA
SimVector = [0.4; 3.3; 1.7];      %[LA;LH;LP]
load ch071105_MonHor1e2ve7_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonHor1e2ve7_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonHor1 vs e2ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonHor1 vs e2ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonHor1 vs e2ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%LH monopolar e2ve7 200uS250uA
SimVector = [0.4; 3.3; 1.7];      %[LA;LH;LP]
load ch071105_MonHor2e3ve7_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonHor2e3ve7_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonHor2 vs e2ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonHor2 vs e2ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonHor2 vs e2ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%LH monopolar e3ve7 200uS250uA
SimVector = [2.2;1.8; 6.9];      %[LA;LH;LP]
load ch071105_MonHor1e2ve7_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonHor1e2ve7_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonHor1 vs e3ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonHor1 vs e3ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonHor1 vs e3ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%LH monopolar e3ve7 200uS250uA
SimVector = [2.2;1.8; 6.9];      %[LA;LH;LP]
load ch071105_MonHor2e3ve7_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonHor2e3ve7_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonHor2 vs e3ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonHor2 vs e3ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonHor2 vs e3ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%Monopolar superior e4ve7 200uS250uA
SimVector = [13.5;2.1; 1.8];      %[LA;LH;LP]
load ch071105_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonSup1 vs e4ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonSup1 vs e4ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonSup1 vs e4ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%Monopolar superior e4ve7 200uS250uA
SimVector = [13.5;2.1; 1.8];      %[LA;LH;LP]
load ch071105_MonSup2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonSup2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonSup2 vs e4ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonSup2 vs e4ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonSup2 vs e4ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%Monopolar superior e5ve7 200uS250uA
SimVector = [9.7; 2.7; 1.6];      %[LA;LH;LP]
load ch071105_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonSup1 vs e5ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonSup1 vs e5ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonSup1 vs e5ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%Monopolar superior e5ve7 200uS250uA
SimVector = [9.7; 2.7; 1.6];      %[LA;LH;LP]
load ch071105_MonSup2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch071105_MonSup2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH071105 MonSup2 vs e5ve7 200uS250uA, LH=red,LA=green,LP=blue');
figure;
title('CH071105 MonSup2 vs e5ve7 200uS250uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 250e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH071105 MonSup2 vs e5ve7 200uS250uA: ' num2str(error) ' degrees'])                                                
clear all;
