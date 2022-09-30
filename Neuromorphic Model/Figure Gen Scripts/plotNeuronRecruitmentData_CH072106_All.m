%this plots the neuron model's selectivity prediction
clear all
currentScaleCorrection = 1;
save currentScaleCorrection;

clear all

%Monopolar LP e0cve6a 100uS260uA
SimVector = [4.9; 18.6; 62.1];      %[LA;LH;LP]
load ch072106_MonPost1_7200B7000N_DAniso2_SCCAxonInsThr_100uS200uA_GBSCCnum1
load ch072106_MonPost1_7200B7000N_DAniso2_USAxonInsThr_100uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH072106 MonPost1 vs e0cve6a 100uS260uA, LH=red,LA=green,LP=blue');
figure;
title('CH072106 MonPost1 vs e0cve6a 100uS260uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 260e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH072106 MonPost1 vs e0cve6a 100uS260uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%Monopolar LP e0cve6a 100uS260uA
SimVector = [4.9; 18.6; 62.1];      %[LA;LH;LP]
load ch072106_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_100uS200uA_GBSCCnum1
load ch072106_MonPost2_7200B7000N_DAniso2_USAxonInsThr_100uS200uA_GBUSnum1
load currentScaleCorrection
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
title('CH072106 MonPost2 vs e0cve6a 100uS260uA, LH=red,LA=green,LP=blue');
figure;
title('CH072106 MonPost2 vs e0cve6a 100uS260uA, actual=yellow, model = cyan');
error = plotNeuralRecruitmentOnSphere(SimVector, 260e-6, supSum, horSum, posSum, current, currentRange);
disp(['Error for CH072106 MonPost2 vs e0cve6a 100uS260uA: ' num2str(error) ' degrees'])                                                
clear all;

