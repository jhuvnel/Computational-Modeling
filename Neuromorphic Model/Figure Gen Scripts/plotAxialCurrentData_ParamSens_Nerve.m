%this plots all of the axial current flow technique's sensitivity to the
%nerve transverse conductance parameter against CH050506B's monopolar LP case

clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
figure;
figureHandle = gcf;                                                
save nodeToAnalyze



figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, Nerve = isotropic
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_7200BISON_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA IsoNerve, LH=red,LA=green,LP=blue');
figure(figureHandle);
title('CH050506B MonPost1 vs e0ve7 200uS120uA Varying Nerve Transverse Conductivity, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS120uA IsoNerve: ' num2str(error) ' degrees'])                                                
clear all;





%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, Nerve = 1500
load nodeToAnalyze
figure;
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B1500N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('CH050506B MonPost1 vs e0ve7 200uS120uA 1500N, LH=red,LA=green,LP=blue');
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevUsingRussCirclePlot2(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, [0 0.7 0.7],2, SimVector);
disp(['Error for CH050506B MonPost1 vs e0ve7 200uS120uA 1500N: ' num2str(error) ' degrees'])                                                
clear all


load nodeToAnalyze
figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, Nerve = 7000
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506B MonPost1 vs e0ve7 200uS120uA 7000N, LH=red,LA=green,LP=blue');
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevUsingRussCirclePlot2(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, [0 0.3 0.3], 2, SimVector);
disp(['Error for ch050506B MonPost1 vs e0ve7 200uS120uA 7000N: ' num2str(error) ' degrees'])                                                
clear all;


%fix colors, so repaint over with the original
load nodeToAnalyze
figure;
%Monopolar LP e0ve7 for CH050506B 200uS120uA at 2Hz, Nerve = isotropic
SimVector = [10.7; 17.3; 55.7];      %[LA;LH;LP]
load ch050506B_MonPost1_7200BISON_AxialCurrent
AxialCurrentFlowAndStandardDev;
close;
figure(figureHandle);
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
clear all;

