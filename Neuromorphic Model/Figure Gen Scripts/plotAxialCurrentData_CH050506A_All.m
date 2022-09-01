%this plots all of the axial current flow data for CH050506B
clear all

nodeToAnalyze = 1;      %what node to take the current flow data and plot as a vector
save nodeToAnalyze

%LA both monopolar 200uS140uA at 0.5Hz
SimVector = [45.4;20.3;46.3];      %[LA;LH;LP]
load ch050506A_MonLABoth_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506A LABoth Monopolar 200uS140uA 0.5Hz, LH=red,LA=green,LP=blue');
figure;
title('Ch050506A LABoth Monopolar 200uS140uA 0.5Hz, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506A LABoth Monopolar 200uS140uA 0.5Hz: ' num2str(error) ' degrees'])                                                
clear all;


load nodeToAnalyze
figure;
%LA both monopolar 200uS130uA at 2Hz
SimVector = [12.7; 3.1; 22.5];      %[LA;LH;LP]
load ch050506A_MonLABoth_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506A LABoth Monopolar 200uS130uA 2Hz, LH=red,LA=green,LP=blue');
figure;
title('Ch050506A LABoth Monopolar 200uS130uA 2Hz, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506A LABoth Monopolar 200uS130uA 2Hz: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%bipolar LH at 230uS and 290uA at 2Hz
SimVector = [17.1;51.4;23.3];      %[LA;LH;LP]
load ch050506A_BipHor1_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506A BipHor1 230uS290uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506A BipHor1 230uS290uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for Ch050506A BipHor1 230uS290uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%bipolar LH at 230uS and 290uA at 2Hz
SimVector = [17.1;51.4;23.3];      %[LA;LH;LP]
load ch050506A_BipHor2_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506A BipHor2 230uS290uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506A BipHor2 230uS290uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for Ch050506A BipHor2 230uS290uA: ' num2str(error) ' degrees'])                                                
clear all;

load nodeToAnalyze
figure;
%Both LP monopolar 200uS 100uA at 2Hz
SimVector = [1.5; 0; 9.2];      %[LA;LH;LP]
load ch050506A_MonLPBoth_7200B7000N_DAniso2_AxialCurrent
AxialCurrentFlowAndStandardDev;
title('Ch050506A Both LP monopolar 200uS100uA, LH=red,LA=green,LP=blue');
figure;
title('Ch050506A Both LP monopolar 200uS100uA, actual=yellow, model = cyan');
error = plotAxialCurrentFlowAndStandardDevOnSphere(nodeToAnalyze, horAxialCurrentMeans, posAxialCurrentMeans,...
                                                    supAxialCurrentMeans, SimVector);
disp(['Error for ch050506A Both LP monopolar 200uS100uA: ' num2str(error) ' degrees'])                                                
clear all;

