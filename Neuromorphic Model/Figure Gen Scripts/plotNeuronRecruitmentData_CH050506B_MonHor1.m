%this plots the neuron model's selectivity prediction
clear all
currentScaleCorrection = 1;
save currentScaleCorrection;

clear all

%e2ve6 200uS160uA at 2Hz
SimVector = [10;17.2;3.8];      %[LA;LH;LP]
load ch050506B_MonHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonHor1 vs e2ve6 200uS160uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonHor1 vs e2ve6 200uS160uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 160e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonHor1 vs e2ve6 200uS160uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%e2ve7 200uS75uA at 2Hz
SimVector = [1.4;2.4;0.9];      %[LA;LH;LP]
load ch050506B_MonHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonHor1 vs e2ve7 200uS75uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonHor1 vs e2ve7 200uS75uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 75e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonHor1 vs e2ve7 200uS75uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e2ve7 200uS100uA at 2Hz
SimVector = [4.6;9;2.7];      %[LA;LH;LP]
load ch050506B_MonHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonHor1 vs e2ve7 200uS100uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonHor1 vs e2ve7 200uS100uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 100e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonHor1 vs e2ve7 200uS100uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%e2ve7 200uS110uA at 2Hz
SimVector = [9.7;10.1;2.2];      %[LA;LH;LP]
load ch050506B_MonHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonHor1 vs e2ve7 200uS110uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonHor1 vs e2ve7 200uS110uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 110e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonHor1 vs e2ve7 200uS110uA: ' num2str(error) ' degrees'])                                                
clear all;



load nodeToAnalyze
figure;
%e2ve7 200uS120uA at 2Hz
SimVector = [17.4; 35.2; 13.4];      %[LA;LH;LP]
load ch050506B_MonHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonHor1 vs e2ve7 200uS120uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonHor1 vs e2ve7 200uS120uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 120e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonHor1 vs e2ve7 200uS120uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%e3ve6 200uS175uA at 2Hz
SimVector = [13.3; 11.3; 2.5];      %[LA;LH;LP]
load ch050506B_MonHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonHor1 vs e3ve6 200uS175uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonHor1 vs e3ve6 200uS175uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 175e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonHor1 vs e3ve6 200uS175uA: ' num2str(error) ' degrees'])                                                
clear all;
