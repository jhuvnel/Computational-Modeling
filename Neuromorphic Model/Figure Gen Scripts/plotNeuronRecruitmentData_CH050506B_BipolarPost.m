%this plots all of the axial current flow data for CH050506B
clear all
currentScaleCorrection = 1;
save currentScaleCorrection;

clear all

%e1ve0 200uS280uA at 2Hz
SimVector = [1.2;2.1;15.8];      %[LA;LH;LP]
load ch050506B_BipPost1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_BipPost1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B BipPost1 vs e1ve0 200uS280uA');
figure;
title('Ch050506B BipPost1 vs e1ve0 200uS280uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 280e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B BipPost1 vs e1ve0 200uS280uA: ' num2str(error) ' degrees'])                                                
clear all;

