%this plots all of the axial current flow data for CH072106

clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
save nodeToAnalyze

%Monopolar LP e0cve6a 100uS260uA
SimVector = [4.9; 18.6; 62.1];      %[LA;LH;LP]
load ch072106_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('CH072106 MonPost1 vs e0cve6a 100uS260uA, LH=red,LA=green,LP=blue');
figure;
title('CH072106 MonPost1 vs e0cve6a 100uS260uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for CH072106 MonPost1 vs e0cve6a 100uS260uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%Monopolar LP e0cve6a 100uS260uA
SimVector = [4.9; 18.6; 62.1];      %[LA;LH;LP]
load ch072106_MonPost2_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('CH072106 MonPost2 vs e0cve6a 100uS260uA, LH=red,LA=green,LP=blue');
figure;
title('CH072106 MonPost2 vs e0cve6a 100uS260uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for CH072106 MonPost2 vs e0cve6a 100uS260uA: ' num2str(error) ' degrees'])                                                
clear all;

