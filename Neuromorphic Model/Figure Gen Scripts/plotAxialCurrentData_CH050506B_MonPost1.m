%this plots all of the axial current flow data for CH050506B
clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
save nodeToAnalyze

%e1ve6 200uS210uA at 2Hz
SimVector = [5.6;23.5;71];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e1ve6 200uS210uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonPost1 vs e1ve6 200uS210uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e1ve6 200uS210uA: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%e0ve7 200uS50uA at 2Hz
SimVector = [18;13;69];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS50uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonPost1 vs e0ve7 200uS50uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS50uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e0ve7 200uS100uA at 2Hz
SimVector = [13.5;16.4;70];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS100uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonPost1 vs e0ve7 200uS100uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS100uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e0ve7 200uS120uA at 2Hz
SimVector = [10.7;17.3;55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS120uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e0ve7 200uS150uA at 2Hz
SimVector = [8.7;29.2;63.2];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS150uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonPost1 vs e0ve7 200uS150uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS150uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%e0ve7 200uS200uA at 2Hz
SimVector = [29;122.1;175.3];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS200uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506B MonPost1 vs e0ve7 200uS200uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS200uA: ' num2str(error) ' degrees'])                                                
clear all;

