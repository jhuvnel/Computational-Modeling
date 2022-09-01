%this m-file uses AllVestibFiberRecruitmentVScurrent.m and plotEMAData.m to
%plot the three intensity series of CH050506B vs the recruitment curve

clear all
currentScaleCorrection = 1;
normalizer = 0.2;
save currentScaleCorrection;

clear all


%first do MonPost1 vs posterior intensity series
load currentScaleCorrection
load ch050506B_MonPost1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
%plot left eye data
hold on
title('MonPost1 of Ch050506B RALP Intensity Series (e0ve7), Left Eye EMA data');
%do the largest one first
plotEMAData(normalizer, posSum, 175.3, 200e-6,...  %200uA
                         [29 122.1 175.3], [5.9 7.9 12.2], current, currentRange);
plotEMAData(normalizer, posSum, 63.2, 150e-6,...   %150uA
                         [8.7 29.2 63.2], [2.7 5.9 12.2], current, currentRange);
plotEMAData(normalizer, posSum, 55.7, 120e-6,...   %120uA
                         [10.7 17.3 55.7], [1.9 1.5 4.1], current, currentRange);
plotEMAData(normalizer, posSum, 14.6, 100e-6,...   %100uA
                         [2.8 3.4 14.6], [1.6 1.3 6.1], current, currentRange);
plotEMAData(normalizer, posSum, 2.7, 50e-6,...    %50uA
                         [0.7 0.5 2.7], [1 0.4 1.2], current, currentRange);
                     
                     

clear all          
figure;
%do MonPost2 vs posterior intensity series
load currentScaleCorrection
load ch050506B_MonPost2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonPost2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
%plot left eye data
hold on
title('MonPost2 of Ch050506B RALP Intensity Series (e0ve7), Left Eye EMA data');

plotEMAData(normalizer, posSum, 55.7, 120e-6,...   %120uA
                         [10.7 17.3 55.7], [1.9 1.5 4.1], current, currentRange);
plotEMAData(normalizer, posSum, 2.7, 50e-6,...    %50uA
                         [0.7 0.5 2.7], [1 0.4 1.2], current, currentRange);
plotEMAData(normalizer, posSum, 175.3, 200e-6,...  %200uA
                         [29 122.1 175.3], [5.9 7.9 12.2], current, currentRange);
plotEMAData(normalizer, posSum, 63.2, 150e-6,...   %150uA
                         [8.7 29.2 63.2], [2.7 5.9 12.2], current, currentRange);
plotEMAData(normalizer, posSum, 14.6, 100e-6,...   %100uA
                         [2.8 3.4 14.6], [1.6 1.3 6.1], current, currentRange);
                     
%monopolar LA intensity series
clear all          
figure;
%do MonSup1 vs LA intensity series
load currentScaleCorrection
load ch050506B_MonSup1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonSup1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
%plot left eye data
hold on
title('MonSup1 of Ch050506B LARP Intensity Series (e4ve7), Left Eye EMA data');

plotEMAData(normalizer, supSum, 74.1, 120e-6,...   %120uA
                         [74.1 80.8 35.2], [10.5 7.5 5.4], current, currentRange);
plotEMAData(normalizer, supSum, 2.4, 50e-6,...    %50uA
                         [2.4 0.8 2.5], [0.7 0.6 1.8], current, currentRange);
plotEMAData(normalizer, supSum, 44.4, 100e-6,...   %100uA
                         [44.4 30.3 13.6], [7.3 3.7 2.8], current, currentRange);
plotEMAData(normalizer, supSum, 22.9, 140e-6,...   %140uA
                         [22.9 19.9 8], [2.4 2 2.2], current, currentRange);
                     

                     %monopolar LA intensity series
clear all          
figure;
%do MonSup2 vs LA intensity series
load currentScaleCorrection
load ch050506B_MonSup2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonSup2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
%plot left eye data
hold on
title('MonSup2 of Ch050506B LARP Intensity Series (e4ve7), Left Eye EMA data');

plotEMAData(normalizer, supSum, 74.1, 120e-6,...   %120uA
                         [74.1 80.8 35.2], [10.5 7.5 5.4], current, currentRange);
plotEMAData(normalizer, supSum, 2.4, 50e-6,...    %50uA
                         [2.4 0.8 2.5], [0.7 0.6 1.8], current, currentRange);
plotEMAData(normalizer, supSum, 44.4, 100e-6,...   %100uA
                         [44.4 30.3 13.6], [7.3 3.7 2.8], current, currentRange);
plotEMAData(normalizer, supSum, 22.9, 140e-6,...   %140uA
                         [22.9 19.9 8], [2.4 2 2.2], current, currentRange);

                     
clear all         


%monopolar LH intensity series
clear all          
figure;
%do MonHor1 vs LH intensity series
load currentScaleCorrection
load ch050506B_MonHor1_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor1_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
%plot left eye data
hold on
title('MonHor1 of Ch050506B Z Intensity Series, Left Eye EMA data');

plotEMAData(normalizer, supSum, 9, 100e-6,...   %100uA
                         [4.6 9 2.7], [0.6 0.6 1.7], current, currentRange);
plotEMAData(normalizer, supSum, 10.1, 110e-6,...   %110uA
                         [9.7 10.1  2.2], [1.3 0.7 1.6], current, currentRange);
plotEMAData(normalizer, supSum, 2.4, 75e-6,...   %75uA
                         [1.4 2.4 0.9], [0.4 0.4 1.1], current, currentRange);
plotEMAData(normalizer, supSum, 35.2, 120e-6,...   %120uA
                         [17.4 35.2 13.4], [2.9 3.3 2.5], current, currentRange);

                     



clear all          
figure;
%do MonHor2 vs LH intensity series
load currentScaleCorrection
load ch050506B_MonHor2_7200B7000N_DAniso2_SCCAxonInsThr_200uS200uA_GBSCCnum1
load ch050506B_MonHor2_7200B7000N_DAniso2_USAxonInsThr_200uS200uA_GBUSnum1
AllVestibFiberRecruitmentVScurrent; %plot the recruitment curves
%plot left eye data
hold on
title('MonHor2 of Ch050506B Z Intensity Series, Left Eye EMA data');

plotEMAData(normalizer, supSum, 9, 100e-6,...   %100uA
                         [4.6 9 2.7], [0.6 0.6 1.7], current, currentRange);
plotEMAData(normalizer, supSum, 10.1, 110e-6,...   %110uA
                         [9.7 10.1  2.2], [1.3 0.7 1.6], current, currentRange);
plotEMAData(normalizer, supSum, 2.4, 75e-6,...   %75uA
                         [1.4 2.4 0.9], [0.4 0.4 1.1], current, currentRange);
plotEMAData(normalizer, supSum, 35.2, 120e-6,...   %120uA
                         [17.4 35.2 13.4], [2.9 3.3 2.5], current, currentRange);

                     
clear all         

