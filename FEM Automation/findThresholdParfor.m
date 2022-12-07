%% findThresholdParfor.m
% Finds the threshold waveform amplitude to activate each axon provided.
% Calls the findThresholdWaveform.m function to run the neuromorphic model.
% Requires a paramter cell, trajectory cell, and solution cells.
% Requires neuromorphic model java code in the javaclasspath. Specify the 
% folder with the neuromorphic model in the javaPath variable. Uses parfor
% to run multiple simulations in parallel using the PC's multiple cores.
% November 2022, Evan Vesper, VNEL


% add dynamic java class path
% note - running javaclasspath again is necessary if you want to update the
% java .class files that Matlab uses, such as if you are debugging them.
% For this to work, you must have no java objects in the Matlab workspace
% and also run javaclasspath(javaPath) to reset the dynamic path. This will
% grab the current version of the .class files in the javaPath location.
% Remember to build the newest version of your java class (using your java
% IDE) before running this.
javaPath = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel';
javaclasspath('-v1') % set to diplay where javaclasspath is looking for classes (optional)
javaclasspath(javaPath) % set dynamic path (necessary if you changed the java classes)
javaclasspath('-dynamic') % display dynamic path (optional)

% load parameters, FEM solutions, trajectories, waveform, and current
slnTestFile = 'testSolution16-Nov-2022.mat';
load(slnTestFile)

slnFullFile = 'fullSolution18-Nov-2022.mat';
load(slnFullFile)

% choose a save location for .mat files and error log
% saveDir = 'C:\Users\Evan\OneDrive - Johns Hopkins\VNEL1DRV\_Vesper\Modeling Results\Matlab Data'; % Matlab can't access 1Drive I think
saveDir = 'C:\Users\Evan\Documents\';
errorFileTest = [sasveDir,'\ErrorFileThresh20221206.txt'];

%% Testing for one FEM solution
parameterTestThresh = parameterTest;
parameterTestThresh{6} = -1; % set to fill condition like Abder did, though I'm not sure why he did it for thresholding and not just a single waveform simulation

% Choose a an axon class to simulate
simClassTest = AxonSimulate_G_AHPAxon_CVStar0265;
% simClassTest = javaObject('AxonSimulate_G_AHPAxon_CVStar0265',[]); % should do same thing as previous 
tic
resultsTestThresh = findThresholdWaveform(parameterTestThresh,solutionBigCell{1},waveForm,traj_test2,simClassTest,errorFileTest);
toc
clear simClassTest

%% Testing threshold finding for all FEM solution sets (1 nerve)
parameterTestThresh = parameterTest;
parameterTestThresh{6} = -1; % set to fill condition like Abder did, though I'm not sure why he did it for thresholding and not just a single waveform simulation

% Choose a an axon class to simulate
nSol = length(param_post);
resultsThresh = cell(1,nSol);
simClass = cell(1,nSol);

tic
for i = 1:nSol
    simClass{i} = AxonSimulate_G_AHPAxon_CVStar0265;
    resultsThresh{i} = findThresholdWaveform(parameterTestThresh,solutionBigCell{i},waveForm,traj_test2,simClass{i},errorFileTest);
end
toc
clear simClass

% %% Run threshold finding for all FEM solution sets
% 
% nSol = length(sol_post);
% nNerve = 3;
% resultsThresh_post = cell(1,nSol);
% resultsThresh_lat = cell(1,nSol);
% resultsThresh_ant = cell(1,nSol);
% resultsThresh_sacc = cell(1,nSol);
% resultsThresh_utr = cell(1,nSol);
% simClass = cell(1,nSol);
% 
% 
% 
% tic
% parfor i = 1:nSol*nNerve
%     % Choose a an axon class to simulate
%     % currently it only uses one axon type
%     simClass{i} = AxonSimulate_G_AHPAxon_CVStar0265;
%     
%     ii = mod(i,nNerve) + 1; % indicates which nerve
% %     iii = ceil(i/nNerve); % indicates which electrode combo/solution
%     switch ii
%         case 1
%             resultsThresh_post{i} = findThresholdWaveform(param_post,sol_post{i},waveForm,traj_post,simClass{i},errorFileTest);
%         case 2
%             resultsThresh_lat{i} = findThresholdWaveform(param_lat,sol_lat{i},waveForm,traj_lat,simClass{i},errorFileTest);
%         case 3
%             resultsThresh_ant{i} = findThresholdWaveform(param_ant,sol_ant{i},waveForm,traj_ant,simClass{i},errorFileTest);
%     end
% %     resultsThresh_sacc{i} = findThresholdWaveform(param_sacc,sol_sacc{i},waveForm,traj_sacc,simClass{i},errorFileTest);
% %     resultsThresh_utr{i} = findThresholdWaveform(param_utr,sol_utr{i},waveForm,traj_utr,simClass{i},errorFileTest);
% end
% 
% % for i = 1:nSol*nNerve
% %     if resultsThresh_post{i} == 0
% %         resultsThresh_post = 
% % end
% toc
% clear simClass

%% Simple parfor

nSol = length(sol_post);
resultsThresh_post = cell(1,nSol);
resultsThresh_lat = cell(1,nSol);
resultsThresh_ant = cell(1,nSol);
resultsThresh_sacc = cell(1,nSol);
resultsThresh_utr = cell(1,nSol);
simClass = cell(1,nSol);

poolobj = parpool;
F = parfevalOnAll(poolobj,@javaaddpath,0,javaPath);
tic
parfor i = 1:nSol
%     javaclasspath(javaPath) % set dynamic path (necessary if you changed the java classes or in a parfor loop)
    simClass{i} = AxonSimulate_G_AHPAxon_CVStar0265;

    resultsThresh_post{i} = findThresholdWaveform(param_post,sol_post{i},waveForm,traj_post,simClass{i},errorFileTest);
    resultsThresh_lat{i} = findThresholdWaveform(param_lat,sol_lat{i},waveForm,traj_lat,simClass{i},errorFileTest);
    resultsThresh_ant{i} = findThresholdWaveform(param_ant,sol_ant{i},waveForm,traj_ant,simClass{i},errorFileTest);
%     resultsThresh_sacc{i} = findThresholdWaveform(param_sacc,sol_sacc{i},waveForm,traj_sacc,simClass{i},errorFileTest);
%     resultsThresh_utr{i} = findThresholdWaveform(param_utr,sol_utr{i},waveForm,traj_utr,simClass{i},errorFileTest);
end
toc
clear simClass
delete(poolobj); % shut down parallel pool
%% Run threshold finding for all FEM solution sets

nSol = length(sol_post);
nNerve = 3; % update based on how many nerves are being simulated

% set up all cells for parfor
resultsThresh_all = cell(1,nSol*nNerve);
simClass_all = cell(1,nSol*nNerve);

sol_all = [sol_post, sol_lat, sol_ant];

param_all = cell(1,nSol*nNerve);
for i = 1:nSol
    param_all{1,i} = param_post;
    param_all{1,i+nSol} = param_lat;
    param_all{1,i+2*nSol} = param_ant;
end

% parallel for loop
tic
poolobj = parpool(16); % create parallel pool object
F = parfevalOnAll(poolobj,@javaaddpath,0,javaPath); % set the pool to add java dynamic path for each worker - necessary if you are using dynamic java path within the parfor
parfor i = 1:nSol*nNerve
    simClass_all{i} = AxonSimulate_G_AHPAxon_CVStar0265;
    % run neuromorphic model thresholding function - I left out traj input
    % since it is just copying the traj into the results cell and I want to
    % save memory
    resultsThresh_all{i} = findThresholdWaveform(param_all{i},sol_all{i},waveForm,[],simClass_all{i},errorFileTest); 
end
%%
resultsThresh_post = resultsThresh_all(1:nSol);
resultsThresh_lat = resultsThresh_all(1+nSol:2*nSol);
resultsThresh_ant = resultsThresh_all(1+2*nSol:3*nSol);
% resultsThresh_sacc = resultsThresh_all(1+3*nSol:4*nSol);
% resultsThresh_utr = resultsThresh_all(1+4*nSol:5*nSol);

toc
% clear aggregate cells since they are just copies and pretty big
% clear simClass_all sol_all param_all resultsThresh_all
delete(poolobj); % shut down parallel pool
%% Save results
fileDate = date;
save([saveDir,'threshResultsTest_',fileDate],'resultsTestThresh','resultsThresh','parameterTestThresh')

%% Save results
fileDate = date;
save([saveDir,'threshResultsFull_',fileDate],'resultsThresh_post','resultsThresh_lat','resultsThresh_ant','resultsThresh_sacc','resultsThresh_utr')

%% For just testing

postSCC_SimCell = resultsThresh_post;
latSCC_SimCell = resultsThresh_lat;
antSCC_SimCell = resultsThresh_ant;

%% Post Processing - Find Recruitment
currentRange = linspace(0,10,500);
currentRangeLen = length(currentRange);
current = 200e-6;

% preallocate memory
numSims = length(antSCC_SimCell);
latSum = cell(1,numSims);
postSum = latSum;
antSum = latSum;
utrSum = latSum;
saccSum = latSum;

antSumNorm = latSum;

% create cumulative sum of fibers recruited vs current
for i = 1:numSims % for every electrode combo
    % preallocate memory
    latSum{i} = zeros(1,currentRangeLen);
    postSum{i} = zeros(1,currentRangeLen);
    antSum{i} = zeros(1,currentRangeLen);
%     utrSum{i} = zeros(1,currentRangeLen);
%     saccSum{i} = zeros(1,currentRangeLen);
    for j = 1:currentRangeLen
        if i == 1
            % add number of axons whose threshold is below this current
            % level and then subtract those who didn't ever get activated
            % (negative threshold)
            latSum{i}(j) = size(find(latSCC_SimCell{i}{4,1} < currentRange(j)),1);
            latSum{i}(j) = latSum{i}(j) - size(find(latSCC_SimCell{i}{4,1} <= 0),1);

            postSum{i}(j) = size(find(postSCC_SimCell{i}{4,1} < currentRange(j)),1);
            postSum{i}(j) = postSum{i}(j) - size(find(postSCC_SimCell{i}{4,1} <= 0),1);
            
            antSum{i}(j) = size(find(antSCC_SimCell{i}{4,1} < currentRange(j)),1);
            antSum{i}(j) = antSum{i}(j) - size(find(antSCC_SimCell{i}{4,1} <= 0),1);
            
%             utrSum{i}(j) = size(find(utricle_SimCell{i}{4,1} < currentRange(j)),1);
%             utrSum{i}(j) = utrSum{i}(j) - size(find(utricle_SimCell{i}{4,1} <= 0),1);
%
%             saccSum{i}(j) = size(find(saccule_SimCell{i}{4,1} < currentRange(j)),1);
%             saccSum{i}(j) = saccSum{i}(j) - size(find(saccule_SimCell{i}{4,1} <= 0),1);
        else
            latSum{i}(j) = latSum{i}(j) + size(find(latSCC_SimCell{i}{4,1} < currentRange(j)),1);
            latSum{i}(j) = latSum{i}(j) - size(find(latSCC_SimCell{i}{4,1} <= 0),1);
        
            postSum{i}(j) = postSum{i}(j) + size(find(postSCC_SimCell{i}{4,1} < currentRange(j)),1);
            postSum{i}(j) = postSum{i}(j) - size(find(postSCC_SimCell{i}{4,1} <= 0),1);
        
            antSum{i}(j) = antSum{i}(j) + size(find(antSCC_SimCell{i}{4,1} < currentRange(j)),1);
            antSum{i}(j) = antSum{i}(j) - size(find(antSCC_SimCell{i}{4,1} <= 0),1);
            
%             utrSum{i}(j) = utrSum{i}(j) + size(find(utricle_SimCell{i}{4,1} < currentRange(j)),1);
%             utrSum{i}(j) = utrSum{i}(j) - size(find(utricle_SimCell{i}{4,1} <= 0),1);
%         
%             saccSum{i}(j) = saccSum{i}(j) + size(find(saccule_SimCell{i}{4,1} < currentRange(j)),1);
%             saccSum{i}(j) = saccSum{i}(j) - size(find(saccule_SimCell{i}{4,1} <= 0),1);
        end
    end
    
    % normalize by total number of axons for that nerve
    postSumNorm{i} = 100*postSum{i}/size(postSCC_SimCell{i}{4,1},1);
    latSumNorm{i} = 100*latSum{i}/size(latSCC_SimCell{i}{4,1},1);
    antSumNorm{i} = 100*antSum{i}/size(antSCC_SimCell{i}{4,1},1);
%     saccSumNorm{i} = 100*saccSum{i}/size(saccule_SimCell{i}{4,1},1);
%     utrSumNorm{i} = 100*utrSum{i}/size(utricle_SimCell{i}{4,1},1);
end
%% Plot activation curves by canal
% Currently this creates one plot per SCC and plots different lines for
% each electrode. Better plot might be to make 1 plot per electrode and
% plot all 3 SCCs on each.
% Posterior SCC
figure
maxNum = 0;
for i = 1:numSims
    plot(currentRange*current,  postSumNorm{i}); 
    hold on
    maxNum = max([maxNum, postSumNorm{i}]);
end
title('Posterior SCC Recruitment');
xlabel('current in amps');
ylabel('% Activation');
legend({'V2\_1 (post. canal)','V2\_3 (ant. canal)','V2\_4 (ant. canal)','V2\_5 (horiz. canal)','V2\_6 (post. canal)','V2\_7 (horiz. canal)'},'Location','southeast')
axis([0 current*max(currentRange) 0 maxNum])

% Lateral SCC
figure
maxNum = 0;
for i = 1:numSims
    plot(currentRange*current,  latSumNorm{i}); 
    hold on
    maxNum = max([maxNum, latSumNorm{i}]);
end
title('Lateral SCC Recruitment');
xlabel('current in amps');
ylabel('% Activation');
legend({'V2\_1 (post. canal)','V2\_3 (ant. canal)','V2\_4 (ant. canal)','V2\_5 (horiz. canal)','V2\_6 (post. canal)','V2\_7 (horiz. canal)'},'Location','southeast')
axis([0 current*max(currentRange) 0 maxNum])

% Anterior SCC
figure
maxNum = 0;
for i = 1:numSims
    plot(currentRange*current,  antSumNorm{i}); 
    hold on
    maxNum = max([maxNum, antSumNorm{i}]);
end
title('Anterior SCC Recruitment');
xlabel('current in amps');
ylabel('% Activation');
legend({'V2\_1 (post. canal)','V2\_3 (ant. canal)','V2\_4 (ant. canal)','V2\_5 (horiz. canal)','V2\_6 (post. canal)','V2\_7 (horiz. canal)'},'Location','southeast')
axis([0 current*max(currentRange) 0 maxNum])

% if (flagNormalizeToNumFibers ~= 1)
%     plot(currentRange*current, horSum, '-r', currentRange*current, posSum, '-b', currentRange*current, supSum, '-g',...
%       currentRange*current, utrSum, ':k', currentRange*current, sacSum, '--k'); 
%     title('Horizontal (red), posterior (blue), superior (green), utricle (..black), saccule(--black)');
%     xlabel('current in amps');
%     ylabel('number of fibers stimulated');
%     maxNum = max([horSum posSum supSum utrSum sacSum]);
%     axis([0 current*max(currentRange) 0 maxNum])
% end
% if (flagNormalizeToNumFibers == 1)
%     horSum = 100*horSum/sccNumFibers;    supSum = 100*supSum/sccNumFibers;    posSum = 100*posSum/sccNumFibers;
%     utrSum = 100*utrSum/otoNumFibers;   sacSum = 100*sacSum/otoNumFibers;
%     plot(currentRange*current, horSum, '-r', currentRange*current, posSum, '-b', currentRange*current, supSum, '-g',...
%       currentRange*current, utrSum, ':k', currentRange*current, sacSum, '--k'); 
%     title('Horizontal (red), posterior (blue), superior (green), utricle (..black), saccule(--black)');
%     xlabel('current in amps');
%     ylabel('% Activation');
%     maxNum = max([horSum posSum supSum utrSum sacSum]);
%     axis([0 current*max(currentRange) 0 maxNum])
% end

%% Plot activation curves by electrode
% all of these electrodes were referenced to electrode 2 in the common crus
electrode_names = {'1 (post. canal)','3 (ant. canal)','4 (ant. canal)','5 (lat. canal)','6 (post. canal)','7 (lat. canal)'};
canal_names = {'Anterior Canal','Lateral Canal','Posterior Canal'};

currVector = currentRange*current*1000;
maxNum = 100;
for i = 1:numSims
    figure
    plot(currVector,  antSumNorm{i}, 'g'); 
    hold on
    plot(currVector,  latSumNorm{i}, 'r'); 
    plot(currVector,  postSumNorm{i}, 'b'); 
    title(['Electrode ', electrode_names{i}]);
    xlabel('Current (mA)');
    ylabel('% Activation');
    legend(canal_names,'Location','southeast')
    axis([0 max(currVector) 0 maxNum])

end
%%

% %temp = rand(150,1);
% parameterCellSCC_6to10{6} = temp;
% 
% %do the horizontal SCC first
% load('MRIFE_HorSCC_100Traj_LocInd_1to3.mat');
% traj = traj(1:(size(traj,1)/2),:);
% simClass1 = AxonSimulate_SENN_AxonI();
% horSCC_SimCell{1} = findThresholdWaveform(parameterCellSCC_1to3,horSCC_PE1_LI1to3_SolutionCell,waveForm, traj, simClass1,0);
% clear simClass1;
% clear traj;