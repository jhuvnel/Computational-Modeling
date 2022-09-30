%this plots all of the axial current flow technique's sensitivity to the
%bone conductance parameter against CH050506B's monopolar LP case

clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
figure;
figureHandle = gcf;                                                
save nodeToAnalyze



figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, bone = 875 ohm-cm
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_875B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA 875B, LH=red,LA=green,LP=blue');
figure(figureHandle);
title('CH050506B MonPost1 vs e0ve7 200uS120uA Varying Bone Conductivity, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS120uA 875B: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, bone = 1750 ohm-cm
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_1750B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA 1750B, LH=red,LA=green,LP=blue');
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevUsingRussCirclePlot2(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, [0 0.8 0.8],2, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS120uA 1750B: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, bone = 3500 ohm-cm
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_3500B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA 3500B, LH=red,LA=green,LP=blue');
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevUsingRussCirclePlot2(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, [0 0.6 0.6],2, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS120uA 3500B: ' num2str(error) ' degrees'])                                                
clear all;




%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, bone = 7200 ohm-cm
load nodeToAnalyze
figure;
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('CH050506B MonPost1 vs e0ve7 200uS120uA 7200B, LH=red,LA=green,LP=blue');
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevUsingRussCirclePlot2(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, [0 0.4 0.4],2, SimVector);
disp(['Error for CH050506B MonPost1 vs e0ve7 200uS120uA 7200B: ' num2str(error) ' degrees'])                                                
clear all


load nodeToAnalyze
figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, bone = 14400 ohm-cm
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_14400B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA 14400B, LH=red,LA=green,LP=blue');
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevUsingRussCirclePlot2(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, [0 0.2 0.2], 2, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS120uA 14400B: ' num2str(error) ' degrees'])                                                
clear all;


%fix colors, so repaint over with the original
load nodeToAnalyze
figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, bone = 875 ohm-cm
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_875B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA 875B, LH=red,LA=green,LP=blue');
close;
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
clear all;

