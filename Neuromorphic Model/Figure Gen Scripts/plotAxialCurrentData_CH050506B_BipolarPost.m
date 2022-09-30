%this plots all of the axial current flow data for CH050506B
clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
save nodeToAnalyze

%e1ve0 200uS280uA at 2Hz
SimVector = [1.2;2.1;15.8];      %[LA;LH;LP]
load ch050506B_BipPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B BipPost1 vs e1ve0 200uS280uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B BipPost1 vs e1ve0 200uS280uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B BipPost1 vs e1ve0 200uS280uA: ' num2str(error) ' degrees'])                                                
clear all;

