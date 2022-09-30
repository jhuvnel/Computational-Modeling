%this plots the neuron model's selectivity prediction
clear all
currentScaleCorrection = 1;
save currentScaleCorrection;

clear all

%e1ve6 200uS210uA at 2Hz
SimVector = [5.6;23.5;71];      %[LA;LH;LP]
load ch050506B_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonPost2 vs e1ve6 200uS210uA');
figure;
title('Ch050506B MonPost2 vs e1ve6 200uS210uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 210e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonPost2 vs e1ve6 200uS210uA: ' num2str(error) ' degrees'])                                                
clear all;


figure;
%e0ve7 200uS50uA at 2Hz
SimVector = [18;13;69];      %[LA;LH;LP]
load ch050506B_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonPost2 vs e0ve7 200uS50uA');
figure;
title('Ch050506B MonPost2 vs e0ve7 200uS50uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 50e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonPost2 vs e0ve7 200uS50uA: ' num2str(error) ' degrees'])                                                
clear all;

figure;
%e0ve7 200uS100uA at 2Hz
SimVector = [13.5;16.4;70];      %[LA;LH;LP]
load ch050506B_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonPost2 vs e0ve7 200uS100uA');
figure;
title('Ch050506B MonPost2 vs e0ve7 200uS100uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 100e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonPost2 vs e0ve7 200uS100uA: ' num2str(error) ' degrees'])                                                
clear all;

figure;
%e0ve7 200uS120uA at 2Hz
SimVector = [10.7;17.3;55.7];      %[LA;LH;LP]
load ch050506B_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonPost2 vs e0ve7 200uS120uA');
figure;
title('Ch050506B MonPost2 vs e0ve7 200uS120uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 120e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonPost2 vs e0ve7 200uS120uA: ' num2str(error) ' degrees'])                                                
clear all;

figure;
%e0ve7 200uS150uA at 2Hz
SimVector = [8.7;29.2;63.2];      %[LA;LH;LP]
load ch050506B_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonPost2 vs e0ve7 200uS150uA');
figure;
title('Ch050506B MonPost2 vs e0ve7 200uS150uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 150e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonPost2 vs e0ve7 200uS150uA: ' num2str(error) ' degrees'])                                                
clear all;

figure;
%e0ve7 200uS200uA at 2Hz
SimVector = [29;122.1;175.3];      %[LA;LH;LP]
load ch050506B_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('Ch050506B MonPost2 vs e0ve7 200uS200uA');
figure;
title('Ch050506B MonPost2 vs e0ve7 200uS200uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 200e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for ch050506B MonPost2 vs e0ve7 200uS200uA: ' num2str(error) ' degrees'])                                                
clear all;

