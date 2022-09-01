clear all
currentScaleCorrection = 1;
save currentScaleCorrection;

clear all

%e4ve6 200uS140uA at 2Hz
SimVector = [22.9;19.9;8];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonSup1 vs e4ve6 200uS140uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve6 200uS140uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 140e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonSup1 vs e4ve6 200uS140uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%e4ve7 200uS50uA at 2Hz
SimVector = [2.4;0.8;2.5];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonSup1 vs e4ve7 200uS50uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve7 200uS50uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 50e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonSup1 vs e4ve7 200uS50uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e4ve7 200uS100uA at 2Hz
SimVector = [44.4;30.3;13.6];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonSup1 vs e4ve7 200uS100uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve7 200uS100uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 100e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonSup1 vs e4ve7 200uS100uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e4ve7 200uS120uA at 2Hz
SimVector = [74.1;80.8;35.2];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonSup1 vs e4ve7 200uS120uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve7 200uS120uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 120e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonSup1 vs e4ve7 200uS120uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e5ve6 200uS140uA at 2Hz
SimVector = [24.2;20.5;4.7];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonSup1 vs e5ve6 200uS140uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e5ve6 200uS140uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 140e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonSup1 vs e5ve6 200uS140uA: ' num2str(error) ' degrees'])                                                
clear all;

