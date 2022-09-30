%this plots all of the axial current flow data for CH050506B
clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
save nodeToAnalyze

%e4ve6 200uS140uA at 2Hz
SimVector = [22.9;19.9;8];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonSup1 vs e4ve6 200uS140uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve6 200uS140uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonSup1 vs e4ve6 200uS140uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%e4ve7 200uS50uA at 2Hz
SimVector = [2.4;0.8;2.5];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonSup1 vs e4ve7 200uS50uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve7 200uS50uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonSup1 vs e4ve7 200uS50uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e4ve7 200uS100uA at 2Hz
SimVector = [44.4;30.3;13.6];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonSup1 vs e4ve7 200uS100uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve7 200uS100uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonSup1 vs e4ve7 200uS100uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e4ve7 200uS120uA at 2Hz
SimVector = [74.1;80.8;35.2];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonSup1 vs e4ve7 200uS120uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e4ve7 200uS120uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonSup1 vs e4ve7 200uS120uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e5ve6 200uS140uA at 2Hz
SimVector = [24.2;20.5;4.7];      %[LA;LH;LP]
load ch050506B_MonSup1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonSup1 vs e5ve6 200uS140uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonSup1 vs e5ve6 200uS140uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonSup1 vs e5ve6 200uS140uA: ' num2str(error) ' degrees'])                                                
clear all;

