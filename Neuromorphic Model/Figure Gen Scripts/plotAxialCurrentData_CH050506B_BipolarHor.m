%this plots all of the axial current flow data for CH050506B
clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
save nodeToAnalyze

%e3ve2 200uS230uA at 2Hz
SimVector = [10.1;23.5;2.5];      %[LA;LH;LP]
load ch050506B_BipHor1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B BipHor1 vs e3ve2 200uS230uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B BipHor1 vs e3ve2 200uS230uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B BipHor1 vs e3ve2 200uS230uA: ' num2str(error) ' degrees'])                                                
clear all;



