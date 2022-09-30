%this plots the neuron model's selectivity prediction
clear all
currentScaleCorrection = 1;
save currentScaleCorrection;

clear all

%e3ve2 200uS230uA at 2Hz
SimVector = [10.1;23.5;2.5];      %[LA;LH;LP]
load ch050506B_BipHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_BipHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B BipHor1 vs e3ve2 200uS230uA');
figure;
title('Ch050506B BipHor1 vs e3ve2 200uS230uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 230e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B BipHor1 vs e3ve2 200uS230uA: ' num2str(error) ' degrees'])                                                
clear all;



