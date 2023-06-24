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
clear simClass_all simClass
javaPath = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel';
javaclasspath('-v1') % set to diplay where javaclasspath is looking for classes (optional)
javaclasspath(javaPath) % set dynamic path (necessary if you changed the java classes)
javaclasspath('-dynamic') % display dynamic path (optional)

% load parameters, FEM solutions, trajectories, waveform, and current

% slnTestFile = 'testSolution16-Nov-2022.mat';
% load(slnTestFile)

% slnFullFile = 'R:\Computational Modeling\Model as of 20230104\19-April-2023\fullSolution20-Apr-2023.mat';
% load(slnFullFile)

% choose a save location for .mat files and error log
% saveDir = 'C:\Users\Evan\OneDrive - Johns Hopkins\VNEL1DRV\_Vesper\Modeling Results\Matlab Data'; % Matlab can't access 1Drive I think
fileDate = date;
saveDir = 'R:\Computational Modeling\Model as of 20230104\19-April-2023\';
errorFileTest = [saveDir,'\ErrorFileThresh',fileDate,'new.txt'];

%% Testing for one FEM solution
parameterTestThresh = paramCellFac;
nTestAxons = 50;
parameterTestThresh{1} =[nTestAxons;1;nTestAxons];
parameterTestThresh{6} = -1; % set to fill condition like Abder did, though I'm not sure why he did it for thresholding and not just a single waveform simulation

% Choose a an axon class to simulate
simClassTest = AxonSimulate_G_AHPAxon_CVStar0265;
% simClassTest = javaObject('AxonSimulate_G_AHPAxon_CVStar0265',[]); % should do same thing as previous 
tic
try
% resultsTestThresh = findThresholdWaveform(parameterTestThresh,solutionBigCell{1},waveForm,traj_test2,simClassTest,errorFileTest);
resultsTestThresh = findThresholdWaveform(parameterTestThresh,sol_fac{1}(1:nTestAxons,:),waveForm,[],simClassTest,errorFileTest);
% resultsTestThresh = findThresholdWaveform(parameterTestThresh,sol_post{1}(35,:),waveForm,[],simClassTest,errorFileTest);
catch ME
    errorObjs{i} =  ME;
    if (strcmp(ME.identifier,'MATLAB:Java:GenericException'))
        i = 1;
        warning(['Error encountered in axonGroup ', num2str(i), ' java: array index out of bounds exception.'])
    else
        warning(['Unkown error encountered in axonGroup ', num2str(i), ' findThresholdWaveform.'])
    end
end
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

for i = 1:nSol
    simClass{i} = AxonSimulate_G_AHPAxon_CVStar0265;
end

poolobj = parpool;
F = parfevalOnAll(poolobj,@javaaddpath,0,javaPath);
tic
parfor i = 1:nSol
%     javaclasspath(javaPath) % set dynamic path (necessary if you changed the java classes or in a parfor loop)
    

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
% nSol = length(sol_post);
% nNerve = 3; % update based on how many nerves are being simulated
% 
% % set up all cells for parfor
% resultsThresh_all = cell(1,nSol*nNerve);
% simClass_all = cell(1,nSol*nNerve);
% 
% sol_all = [sol_post, sol_lat, sol_ant];
% 
% param_all = cell(1,nSol*nNerve);
% for i = 1:nSol
%     param_all{1,i} = param_post;
%     param_all{1,i+nSol} = param_lat;
%     param_all{1,i+2*nSol} = param_ant;
% end
% 
% % parallel for loop
% tic
% poolobj = parpool(16); % create parallel pool object
% F = parfevalOnAll(poolobj,@javaaddpath,0,javaPath); % set the pool to add java dynamic path for each worker - necessary if you are using dynamic java path within the parfor
% parfor i = 1:nSol*nNerve
%     simClass_all{i} = AxonSimulate_G_AHPAxon_CVStar0265;
%     % run neuromorphic model thresholding function - I left out traj input
%     % since it is just copying the traj into the results cell and I want to
%     % save memory
%     resultsThresh_all{i} = findThresholdWaveform(param_all{i},sol_all{i},waveForm,[],simClass_all{i},errorFileTest); 
% end
%
% resultsThresh_post = resultsThresh_all(1:nSol);
% resultsThresh_lat = resultsThresh_all(1+nSol:2*nSol);
% resultsThresh_ant = resultsThresh_all(1+2*nSol:3*nSol);
% % resultsThresh_sacc = resultsThresh_all(1+3*nSol:4*nSol);
% % resultsThresh_utr = resultsThresh_all(1+4*nSol:5*nSol);
% 
% toc
% % clear aggregate cells since they are just copies and pretty big
% % clear simClass_all sol_all param_all resultsThresh_all
% delete(poolobj); % shut down parallel pool

% %% Save test results
% fileDate = date;
% save([saveDir,'threshResultsTest_',fileDate],'resultsTestThresh','resultsThresh','parameterTestThresh')

%% Run threshold finding for all FEM solution sets w/ Bands
nBandSCC = 6;
nBandUS = 3;
nSol = length(sol_post);
nNerve = 7; % number of nerves - 5 vestibular + 1 facial + 1 cochlear
nAxonGroups = (3*nBandSCC + 2*nBandUS + 2); % update based on how many nerves are being simulated - 3 SCC, 2 oto, 1 facial, 1 cochlear
nSims = nAxonGroups*nSol;
% set up all cells for parfor
% resultsThresh_all_parfor = cell(1,nSims);
simClass_all = cell(1,nSims);

sol_all = [sol_post, sol_lat, sol_ant, sol_sacc, sol_utr, sol_fac, sol_coch];
paramToSolMap = zeros(1,nSims);
% sol_all = cell(1,nSims);

% have to put all the parameter cells into one variable for slicing in
% parfor. Have to do the same thing with the simClasses
param_all = cell(1,nSims);
for i = 1:nSol
    % posterior canal
    param_all{1,nAxonGroups*(i-1)+1} = bigParamCellSCC{1,1};
    param_all{1,nAxonGroups*(i-1)+2} = bigParamCellSCC{1,2};
    param_all{1,nAxonGroups*(i-1)+3} = bigParamCellSCC{1,3};
    param_all{1,nAxonGroups*(i-1)+4} = bigParamCellSCC{1,4};
    param_all{1,nAxonGroups*(i-1)+5} = bigParamCellSCC{1,5};
    param_all{1,nAxonGroups*(i-1)+6} = bigParamCellSCC{1,6};
    simClass_all{1,nAxonGroups*(i-1)+1} = AxonSimulate_G_AHPAxon_CVStar0265;
    simClass_all{1,nAxonGroups*(i-1)+2} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+3} = AxonSimulate_G_AHPAxon_CVStar0265;
    simClass_all{1,nAxonGroups*(i-1)+4} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+5} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+6} = AxonSimulate_G_AHPAxon_CVStar5082;
    paramToSolMap(nAxonGroups*(i-1)+(1:6)) = i;

    

    % lateral canal
    param_all{1,nAxonGroups*(i-1)+1+nBandSCC} = bigParamCellSCC{2,1};
    param_all{1,nAxonGroups*(i-1)+2+nBandSCC} = bigParamCellSCC{2,2};
    param_all{1,nAxonGroups*(i-1)+3+nBandSCC} = bigParamCellSCC{2,3};
    param_all{1,nAxonGroups*(i-1)+4+nBandSCC} = bigParamCellSCC{2,4};
    param_all{1,nAxonGroups*(i-1)+5+nBandSCC} = bigParamCellSCC{2,5};
    param_all{1,nAxonGroups*(i-1)+6+nBandSCC} = bigParamCellSCC{2,6};
    simClass_all{1,nAxonGroups*(i-1)+1+nBandSCC} = AxonSimulate_G_AHPAxon_CVStar0265;
    simClass_all{1,nAxonGroups*(i-1)+2+nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+3+nBandSCC} = AxonSimulate_G_AHPAxon_CVStar0265;
    simClass_all{1,nAxonGroups*(i-1)+4+nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+5+nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+6+nBandSCC} = AxonSimulate_G_AHPAxon_CVStar5082;
    paramToSolMap(nAxonGroups*(i-1)+(1:6)+nBandSCC) = i + nSol;

    % anterior canal
    param_all{1,nAxonGroups*(i-1)+1+2*nBandSCC} = bigParamCellSCC{3,1};
    param_all{1,nAxonGroups*(i-1)+2+2*nBandSCC} = bigParamCellSCC{3,2};
    param_all{1,nAxonGroups*(i-1)+3+2*nBandSCC} = bigParamCellSCC{3,3};
    param_all{1,nAxonGroups*(i-1)+4+2*nBandSCC} = bigParamCellSCC{3,4};
    param_all{1,nAxonGroups*(i-1)+5+2*nBandSCC} = bigParamCellSCC{3,5};
    param_all{1,nAxonGroups*(i-1)+6+2*nBandSCC} = bigParamCellSCC{3,6};
    simClass_all{1,nAxonGroups*(i-1)+1+2*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar0265;
    simClass_all{1,nAxonGroups*(i-1)+2+2*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+3+2*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar0265;
    simClass_all{1,nAxonGroups*(i-1)+4+2*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+5+2*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+6+2*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar5082;
    paramToSolMap(nAxonGroups*(i-1)+(1:6)+2*nBandSCC) = i + 2*nSol;

    % saccule
    param_all{1,nAxonGroups*(i-1)+1+3*nBandSCC} = bigParamCellUS{1,1};
    param_all{1,nAxonGroups*(i-1)+2+3*nBandSCC} = bigParamCellUS{1,2};
    param_all{1,nAxonGroups*(i-1)+3+3*nBandSCC} = bigParamCellUS{1,3};
    simClass_all{1,nAxonGroups*(i-1)+1+3*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar0265; % The otolith axon groups aren't accurate (need A, B1, B2, B3, C groups)
    simClass_all{1,nAxonGroups*(i-1)+2+3*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+3+3*nBandSCC} = AxonSimulate_G_AHPAxon_CVStar1483;
    paramToSolMap(nAxonGroups*(i-1)+(1:3)+3*nBandSCC) = i + 3*nSol;

    % utricle
    param_all{1,nAxonGroups*(i-1)+1+3*nBandSCC+nBandUS} = bigParamCellUS{2,1};
    param_all{1,nAxonGroups*(i-1)+2+3*nBandSCC+nBandUS} = bigParamCellUS{2,2};
    param_all{1,nAxonGroups*(i-1)+3+3*nBandSCC+nBandUS} = bigParamCellUS{2,3};
    simClass_all{1,nAxonGroups*(i-1)+1+3*nBandSCC+nBandUS} = AxonSimulate_G_AHPAxon_CVStar0265;
    simClass_all{1,nAxonGroups*(i-1)+2+3*nBandSCC+nBandUS} = AxonSimulate_G_AHPAxon_CVStar1483;
    simClass_all{1,nAxonGroups*(i-1)+3+3*nBandSCC+nBandUS} = AxonSimulate_G_AHPAxon_CVStar1483;
    paramToSolMap(nAxonGroups*(i-1)+(1:3)+3*nBandSCC+nBandUS) = i + 4*nSol;


    % facial
    paramCellFac{6} = -1; % set to fill condition since facial initial conditions seem to have problems
    param_all{1,nAxonGroups*(i-1)+1+3*nBandSCC+2*nBandUS} = paramCellFac;
    % Set to regularly firing model... CVStar0265
    simClass_all{1,nAxonGroups*(i-1)+1+3*nBandSCC+2*nBandUS} = AxonSimulate_G_AHPAxon_CVStar0265;
    paramToSolMap(nAxonGroups*(i-1)+1+3*nBandSCC+2*nBandUS) = i + 5*nSol;

    % cochlear
    param_all{1,nAxonGroups*(i-1)+2+3*nBandSCC+2*nBandUS} = paramCellCoch;
    simClass_all{1,nAxonGroups*(i-1)+2+3*nBandSCC+2*nBandUS} = AxonSimulate_G_AHPAxon_CVStar5082;
    paramToSolMap(nAxonGroups*(i-1)+2+3*nBandSCC+2*nBandUS) = i + 6*nSol;

end
sol_all_parfor = cell(1,nSims);

% for i = 1:nSims
%     sol_all_parfor{1,i} = sol_all{paramToSolMap(i)};
% end

% set up solution cell array for parfor
for i = 1:nSims
%     axonGroup = mod(i,nAxonGroups) + 1; % which set of axons this is
    extract = param_all{i}{10}(2):param_all{i}{10}(3);
    sol_all_parfor{1,i} = sol_all{paramToSolMap(i)}(extract,:);
end
%% Debugging
% find max number of nodes in each axon group and all axons together
maxNodes = 0;
iNodes = zeros(1,nSims);
for i = 1:nSims
    iNodes(i) = max(cellfun(@length, sol_all_parfor{i}(:,2)));
    if maxNodes < iNodes(i)
        maxNodes = iNodes(i);
    end
end
disp(maxNodes)
%% Debugging
test_sacc3_inds = [24 50 76 102 128 154];

test_fac_inds = [25 51 77 102 129 154];
resultsThresh_all_parfor_test = cell(size(test_sacc3_inds));

% for iter = 1:length(test_sacc3_inds)
for iter = 1
    % run neuromorphic model thresholding function - I left out traj input
    % since it is just copying the traj into the results cell and I want to
    % save memory
%     i = test_sacc3_inds(iter);
    i = test_fac_inds(iter);
%     i = 1;
    resultsThresh_all_parfor_test{iter} = findThresholdWaveform(param_all{i},sol_all_parfor{i},waveForm,[],simClass_all{i},errorFileTest);
end
%%
poolobj = parpool(16); % create parallel pool object
F = parfevalOnAll(poolobj,@javaaddpath,0,javaPath); % set the pool to add java dynamic path for each worker - necessary if you are using dynamic java path within the parfor

%% parallel for loop
tic
errorObjs = cell(1,nSims);
resultsThresh_all_parfor = cell(1,nSims);

parfor i = 1:nSims
    % something doesn't like the simClass_all array that I made... so I
    % will just use a single variable for the simClass. This includes some
    % hardcoding in the axonGroups that take each fiber type
    % 0 is cochlear,
    axonGroup = mod(i,nAxonGroups) + 1;
    if any(axonGroup == [1 3 7 9 13 15 19 22 25]) % regularly firing
        simClass = AxonSimulate_G_AHPAxon_CVStar0265;
    elseif any(axonGroup == [2 4 5 8 10 11 14 16 17 20 21 23 24]) % intermediately firing
        % 25 corresponds to facial fibers. remove 25 if you want to set
        % them to a different axon class (like SENN_AxonI)
        simClass = AxonSimulate_G_AHPAxon_CVStar1483;
    elseif any(axonGroup == [0 6 12 18]) % irregularly firing
        simClass = AxonSimulate_G_AHPAxon_CVStar5082;
    else % passive insulated axon
        simClass = AxonSimulate_SENN_AxonI;
    end
    % run neuromorphic model thresholding function - I left out traj input
    % since it is just copying the traj into the results cell and I don't
    % want it more complicated

%     resultsThresh_all{i} = findThresholdWaveform(param_all{i},sol_all_parfor{i},waveForm,[],simClass,errorFileTest); 

    try
        resultsThresh_all_parfor{i} = findThresholdWaveform(param_all{i},sol_all_parfor{i},waveForm,[],simClass,errorFileTest); 
    catch ME
        errorObjs{i} =  ME;
        warning(['Error encountered in axonGroup ', num2str(i),'.\n',errorObjs{i}.message])
%         if (strcmp(ME.identifier,'MATLAB:Java:GenericException'))
%             warning(['Error encountered in axonGroup ', num2str(i), ' java: array index out of bounds exception. Retrying with 1 less axon.'])
%             try % retry
%                 % remove one axon from the end, this seems to help
%                 param_all{i}{1} = param_all{i}{1} - [1;0;1]; 
%                 sol_all_parfor{i} = sol_all_parfor{i}(1:end-1,:);
%                 
%                 resultsThresh_all{i} = findThresholdWaveform(param_all{i},sol_all_parfor{i},waveForm,[],simClass,errorFileTest); 
%             catch ME2
%                 errorObjs2{i} = ME2;
%                 warning('Error encountered again. Skipping this axonGroup.')
%             end
%         else
%             warning(['Unkown error encountered in axonGroup ', num2str(i), ' findThresholdWaveform.'])
%         end
    end
end
tNeuromorphic_parfor = toc;
fprintf('Full neuromorphic model computational time with 16 parallel workers: %f \n', tNeuromorphic_parfor)
beep

%% Just facial and cochlear nerves
errorObjs_fac_coch = cell(nSol*2,1);
resultsThresh_fac_coch = cell(nSol*2,1);
% param_fac_coch = [param]
% facial_simCell = cell(nSol,1);
parfor i = 1:nSol*2
    try
        if i/nSol > 1 % cochlear
            simClass = AxonSimulate_G_AHPAxon_CVStar0265;
            resultsThresh_fac_coch{i} = findThresholdWaveform(paramCellCoch,sol_coch{i},waveForm,[],simClass,errorFileTest);
        else % facial
            simClass = AxonSimulate_G_AHPAxon_CVStar0265;
            resultsThresh_fac_coch{i} = findThresholdWaveform(paramCellFac,sol_fac{i},waveForm,[],simClass,errorFileTest);
        end
    catch ME
        errorObjs_fac_coch{i} =  ME;
        warning(['Error encountered in axonGroup ', num2str(i),'.\n',errorObjsFac{i}.message])
    end
end
%% Pack results back into original sol_all format for whole nerves
resultsThresh_all = cell(1,nSol*nNerve);
for i = 1:nSims
    if ~isempty(resultsThresh_all_parfor{i})
        if isempty(resultsThresh_all{paramToSolMap(i)})
            % if this is the first band/group of axons added to this cell, just
            % copy the axon group results cell
            resultsThresh_all(paramToSolMap(i)) = resultsThresh_all_parfor(i);
        else
           % if an axon group has already been added to this nerve's cell,
           % append axons in the next axon group inside the nerve cell
           % append parameter cell... only need to changes elements 1, 5, 6, 10
           temp_param_cell = resultsThresh_all{paramToSolMap(i)}{1};
           temp_param_cell{1} = ... % nerve axon numbers
               [temp_param_cell{1}(1) + resultsThresh_all_parfor{i}{1}{1}(1);
               1;
               temp_param_cell{1}(1) + resultsThresh_all_parfor{i}{1}{1}(1)];
           temp_param_cell{5} = [temp_param_cell{5}; resultsThresh_all_parfor{i}{1}{5}]; % fiber diams
           temp_param_cell{6} = [temp_param_cell{6}; resultsThresh_all_parfor{i}{1}{6}]; % inital state array
           temp_param_cell{10} = [temp_param_cell{10}, resultsThresh_all_parfor{i}{1}{10}]; % band axon numbers - will now contain a column for each band/axon group
    
           resultsThresh_all{paramToSolMap(i)}{1} = temp_param_cell;
    
           % append threshold current
           resultsThresh_all{paramToSolMap(i)}{4} = [resultsThresh_all{paramToSolMap(i)}{4}; resultsThresh_all_parfor{i}{4}];
           % append AP initiation node and time point
           resultsThresh_all{paramToSolMap(i)}{5} = [resultsThresh_all{paramToSolMap(i)}{5}; resultsThresh_all_parfor{i}{5}];
    
        end
    end
end

postSCC_SimCell = resultsThresh_all(1:nSol);
latSCC_SimCell = resultsThresh_all(1+nSol:2*nSol);
antSCC_SimCell = resultsThresh_all(1+2*nSol:3*nSol);
saccule_SimCell = resultsThresh_all(1+3*nSol:4*nSol);
utricle_SimCell = resultsThresh_all(1+4*nSol:5*nSol);
facial_SimCell = resultsThresh_all(1+5*nSol:6*nSol);
cochlear_SimCell = resultsThresh_all(1+6*nSol:7*nSol);



% clear aggregate cells since they are just copies and pretty big
% clear simClass_all sol_all param_all resultsThresh_all
 

%% Save results
fileDate = date;
save([saveDir,'threshResultsFull_',fileDate],'postSCC_SimCell','latSCC_SimCell','antSCC_SimCell','utricle_SimCell','saccule_SimCell','facial_SimCell','cochlear_SimCell', 'errorObjs','tNeuromorphic_parfor')

%% Post Processing - Find Recruitment
currentRange = linspace(0,10,500); % this is the range of current scaling to threshold values for
currentRangeLen = length(currentRange);
current = 200e-6;

% preallocate variables
numEl = length(antSCC_SimCell); % number of electrodes
latSum = cell(1,numEl);
postSum = latSum;
antSum = latSum;
saccSum = latSum;
utrSum = latSum;
facSum = latSum;
cochSum = latSum;

postSumNorm = latSum;
latSumNorm = latSum;
antSumNorm = latSum;
utrSumNorm = latSum;
saccSumNorm = latSum;
facSumNorm = latSum;
cochSumNorm = latSum;

% create cumulative sum of fibers recruited vs current
for i = 1:numEl % for every electrode combo
    % preallocate memory
    latSum{i} = zeros(1,currentRangeLen);
    postSum{i} = zeros(1,currentRangeLen);
    antSum{i} = zeros(1,currentRangeLen);
    saccSum{i} = zeros(1,currentRangeLen);
    utrSum{i} = zeros(1,currentRangeLen);
    facSum{i} = zeros(1,currentRangeLen);
    cochSum{i} = zeros(1,currentRangeLen);
        for j = 1:currentRangeLen
            % if condition just skips the current cell if it is empty (i.e.
            % there was an error when solving for the threshold and nothing
            % was returned)
            if ~isempty(latSCC_SimCell{i})
            % add number of axons whose threshold is below this current
            % level and then subtract those who didn't ever get activated
            % (negative threshold)
                latSum{i}(j) = latSum{i}(j) + size(find(latSCC_SimCell{i}{4,1} < currentRange(j)),1);
                latSum{i}(j) = latSum{i}(j) - size(find(latSCC_SimCell{i}{4,1} <= 0),1);
            end
            
            if ~isempty(postSCC_SimCell{i})
                postSum{i}(j) = postSum{i}(j) + size(find(postSCC_SimCell{i}{4,1} < currentRange(j)),1);
                postSum{i}(j) = postSum{i}(j) - size(find(postSCC_SimCell{i}{4,1} <= 0),1);
            end
            
            if ~isempty(antSCC_SimCell{i})
                antSum{i}(j) = antSum{i}(j) + size(find(antSCC_SimCell{i}{4,1} < currentRange(j)),1);
                antSum{i}(j) = antSum{i}(j) - size(find(antSCC_SimCell{i}{4,1} <= 0),1);
            end
            
            if ~isempty(saccule_SimCell{i})
                saccSum{i}(j) = saccSum{i}(j) + size(find(saccule_SimCell{i}{4,1} < currentRange(j)),1);
                saccSum{i}(j) = saccSum{i}(j) - size(find(saccule_SimCell{i}{4,1} <= 0),1);
            end

            if ~isempty(utricle_SimCell{i})
                utrSum{i}(j) = utrSum{i}(j) + size(find(utricle_SimCell{i}{4,1} < currentRange(j)),1);
                utrSum{i}(j) = utrSum{i}(j) - size(find(utricle_SimCell{i}{4,1} <= 0),1);
            end

%             if ~isempty(facial_SimCell{i})
%                 facSum{i}(j) = facSum{i}(j) + size(find(facial_SimCell{i}{4,1} < currentRange(j)),1);
%                 facSum{i}(j) = facSum{i}(j) - size(find(facial_SimCell{i}{4,1} <= 0),1);
%             end
% 
%             if ~isempty(cochlear_SimCell{i})
%                 cochSum{i}(j) = cochSum{i}(j) + size(find(cochlear_SimCell{i}{4,1} < currentRange(j)),1);
%                 cochSum{i}(j) = cochSum{i}(j) - size(find(cochlear_SimCell{i}{4,1} <= 0),1);
%             end
        end
    
    % normalize by total number of axons for that nerve
    postSumNorm{i} = 100*postSum{i}/size(postSCC_SimCell{i}{4,1},1);
    latSumNorm{i} = 100*latSum{i}/size(latSCC_SimCell{i}{4,1},1);
    antSumNorm{i} = 100*antSum{i}/size(antSCC_SimCell{i}{4,1},1);
    saccSumNorm{i} = 100*saccSum{i}/size(saccule_SimCell{i}{4,1},1);
    utrSumNorm{i} = 100*utrSum{i}/size(utricle_SimCell{i}{4,1},1);
%     facSumNorm{i} = 100*facSum{i}/size(facial_SimCell{i}{4,1},1);
%     cochSumNorm{i} = 100*cochSum{i}/size(cochlear_SimCell{i}{4,1},1);
end

% Plot activation curves by electrode
% all of these electrodes were referenced to electrode 2 in the common crus
trajColors = {'r','g','b',[0.8500 0.3250 0.0980],[165,42,42]/245,'c',[0.4940 0.1840 0.5560]};
electrode_names_full = {'1 (post. canal)','3 (ant. canal)','4 (ant. canal)','5 (lat. canal)','6 (post. canal)','7 (lat. canal)'};
electrode_names = {'1','3','4','5','6','7'};
nerve_names = {'Lateral Canal','Anterior Canal','Posterior Canal','Saccule','Utricle','Facial','Cochlear'};
currVector = currentRange*current*1e6; % uA
normalCurrentRange = [currVector(2) 300]; % uA, used to plot a shaded region indicating standard range of currents used in monkeys
maxNum = 100; % sets y-axis limit in plots (max activation)

% Individual figure per electrode
% maxNum = 100;
% for i = 1:numEl
%     figure
%     plot(currVector,  antSumNorm{i}, 'g'); 
%     hold on
%     plot(currVector,  latSumNorm{i}, 'r'); 
%     plot(currVector,  postSumNorm{i}, 'b'); 
%     plot(currVector,  saccSumNorm{i}, '--'); 
%     plot(currVector,  utrSumNorm{i}, '--'); 
% %     plot(currVector,  facSumNorm{i}, ':'); 
%     plot(currVector,  cochSumNorm{i}, ':'); 
%     title(['Electrode ', electrode_names{i}]);
%     xlabel('Current (mA)');
%     ylabel('% Fibers Activated');
%     legend(nerve_names,'Location','southeast')
%     axis([0 max(currVector) 0 maxNum])
% 
% end

% % Subplot format
% el2TileMap = ...
%     [2, 1, 4;
%     3, 5, 6]';
% figure('Units','Inches','Position',[2 2 14 8])
% ph = cell(7,1);
% th = tiledlayout(2,3);
% for i = 1:numEl
%     nexttile
% 
%     ph{1} = plot(currVector,  antSumNorm{el2TileMap(i)},'LineWidth',1,'Color',trajColors{1}); 
%     hold on
%     ph{2} = plot(currVector,  latSumNorm{el2TileMap(i)},'LineWidth',1,'Color',trajColors{2}); 
%     ph{3} = plot(currVector,  postSumNorm{el2TileMap(i)},'LineWidth',1,'Color',trajColors{3}); 
%     ph{4} = plot(currVector,  saccSumNorm{el2TileMap(i)}, '--','LineWidth',1,'Color',trajColors{4}); 
%     ph{5} = plot(currVector,  utrSumNorm{el2TileMap(i)}, '--','LineWidth',1,'Color',trajColors{5}); 
%     ph{6} = plot(currVector,  facSumNorm{el2TileMap(i)}, ':','LineWidth',1,'Color',trajColors{6}); 
%     ph{7} = plot(currVector,  cochSumNorm{el2TileMap(i)}, ':','LineWidth',1,'Color',trajColors{7});
% %     ph{8} = area(normalCurrentRange, [1 1]*maxNum, 'FaceColor', [1 1 1]*0.9, 'LineStyle','none');
% %     ph{8} = plot(normalCurrentRange, [1 1]*.97*maxNum, 'Color', [1 1 1]*0.7, 'LineWidth', 3); 
% %     uistack(ph{8},'bottom')
%     set(gca,'Layer','top')
% 
%     switch i
%         case {1,4}
%             ph{1}.LineWidth = 3; % bold target canal
%         case {2,5}
%             ph{3}.LineWidth = 3; % bold target canal
%         case {3,6}
%             ph{2}.LineWidth = 3; % bold target canal
%     end
% 
%     title(['Electrode ', electrode_names{el2TileMap(i)}]);
% 
%     axis([0 max(currVector) 0 maxNum])
% %     axis([0 max(currVector)/2 0 maxNum])
% 
% end
% legend([ph{1} ph{2} ph{3} ph{4} ph{5} ph{6} ph{7}], nerve_names,'Location','northwestoutside','NumColumns',2) % apply legend to last plot
% legend('boxoff')
% 
% % add title and axis labels to entire tiledlayout
% title(th, 'Recruitment by Electrode')
% xlabel(th, 'Current Amplitude [uA]');
% ylabel(th, '% Fibers Activated');
% 
% saveas(gcf,[saveDir,'recruitmentTiles_',fileDate])
%%
% Subplot format with log current scale

el2TileMap = ...
    [2, 1, 4;
    3, 5, 6]';

figure('Units','Inches','Position',[1 0.5 14 8])
ph = cell(7,1);
th = tiledlayout(2,3);
for i = 1:numEl
    nexttile
    

    ph{1} = semilogx(currVector,  antSumNorm{el2TileMap(i)},'LineWidth',1,'Color',trajColors{1}); 
    hold on
    ph{2} = semilogx(currVector,  latSumNorm{el2TileMap(i)},'LineWidth',1,'Color',trajColors{2}); 
    ph{3} = semilogx(currVector,  postSumNorm{el2TileMap(i)},'LineWidth',1,'Color',trajColors{3}); 
    ph{4} = semilogx(currVector,  saccSumNorm{el2TileMap(i)}, '--','LineWidth',1,'Color',trajColors{4}); 
    ph{5} = semilogx(currVector,  utrSumNorm{el2TileMap(i)}, '--','LineWidth',1,'Color',trajColors{5}); 
    ph{6} = semilogx(currVector,  facSumNorm{el2TileMap(i)}, ':','LineWidth',1,'Color',trajColors{6}); 
%     ph{6} = semilogx(currVector,  facSumNorm{el2TileMap(i)}, ':','LineWidth',1); 
    ph{7} = semilogx(currVector,  cochSumNorm{el2TileMap(i)}, ':','LineWidth',1,'Color',trajColors{7});

%     ph{1} = semilogx(currVector,  antSumNorm{el2TileMap(i)}, 'g','LineWidth', 1); 
%     hold on
%     ph{2} = semilogx(currVector,  latSumNorm{el2TileMap(i)}, 'r','LineWidth', 1); 
%     ph{3} = semilogx(currVector,  postSumNorm{el2TileMap(i)}, 'b','LineWidth',1); 
%     ph{4} = semilogx(currVector,  saccSumNorm{el2TileMap(i)}, '--','LineWidth',1); 
%     ph{5} = semilogx(currVector,  utrSumNorm{el2TileMap(i)}, '--','LineWidth',1); 
%     ph{6} = semilogx(currVector,  facSumNorm{el2TileMap(i)}, ':','LineWidth',1); 
%     ph{7} = semilogx(currVector,  cochSumNorm{el2TileMap(i)}, ':','LineWidth',1); 
    % plot standard range of used current
%     ph{8} = area(normalCurrentRange, [1 1]*maxNum, 'FaceColor', [1 1 1]*0.9, 'LineStyle','none');
    ph{8} = semilogx(normalCurrentRange, [1 1]*.97*maxNum, 'Color', [1 1 1]*0.7, 'LineWidth', 3); 
    uistack(ph{8},'bottom')
    set(gca,'Layer','top')
    
    
    switch i
        case {1,4}
            ph{1}.LineWidth = 3; % bold target canal
        case {2,5}
            ph{3}.LineWidth = 3; % bold target canal
        case {3,6}
            ph{2}.LineWidth = 3; % bold target canal
    end

    title(['Electrode ', electrode_names{el2TileMap(i)}]);

    axis([0 max(currVector) 0 maxNum])

end
ylim([0 200])
legend([ph{1} ph{2} ph{3} ph{4} ph{5} ph{6} ph{7}], nerve_names,'Location','northwest','NumColumns',2) % apply legend to last plot
legend('boxoff')

% add title and axis labels to entire tiledlayout
title(th, 'Recruitment by Electrode')
xlabel(th, 'Current Amplitude [uA]');
ylabel(th, '% Fibers Activated');

saveas(gcf,[saveDir,'recruitmentTilesLog_',fileDate])

%% Plot activation curves by canal
% Currently this creates one plot per SCC and plots different lines for
% each electrode. Better plot might be to make 1 plot per electrode and
% plot all 3 SCCs on each.
% Posterior SCC
figure
maxNum = 0;
for i = 1:numEl
    plot(currVector,  postSumNorm{i}); 
    hold on
    maxNum = max([maxNum, postSumNorm{i}]);
end
title('Posterior SCC Recruitment');
xlabel('current in amps');
ylabel('% Activation');
legend({'V2\_1 (post. canal)','V2\_3 (ant. canal)','V2\_4 (ant. canal)','V2\_5 (horiz. canal)','V2\_6 (post. canal)','V2\_7 (horiz. canal)'},'Location','southeast')
axis([0 max(currVector) 0 maxNum])

% Lateral SCC
figure
maxNum = 0;
for i = 1:numEl
    plot(currVector,  latSumNorm{i}); 
    hold on
    maxNum = max([maxNum, latSumNorm{i}]);
end
title('Lateral SCC Recruitment');
xlabel('current in amps');
ylabel('% Activation');
legend({'V2\_1 (post. canal)','V2\_3 (ant. canal)','V2\_4 (ant. canal)','V2\_5 (horiz. canal)','V2\_6 (post. canal)','V2\_7 (horiz. canal)'},'Location','southeast')
axis([0 max(currVector) 0 maxNum])

% Anterior SCC
figure
maxNum = 0;
for i = 1:numEl
    plot(currVector,  antSumNorm{i}); 
    hold on
    maxNum = max([maxNum, antSumNorm{i}]);
end
title('Anterior SCC Recruitment');
xlabel('current in amps');
ylabel('% Activation');
legend({'V2\_1 (post. canal)','V2\_3 (ant. canal)','V2\_4 (ant. canal)','V2\_5 (horiz. canal)','V2\_6 (post. canal)','V2\_7 (horiz. canal)'},'Location','southeast')
axis([0 max(currVector) 0 maxNum])

% if (flagNormalizeToNumFibers ~= 1)
%     plot(currentRange*current, horSum, '-r', currentRange*current, posSum, '-b', currentRange*current, supSum, '-g',...
%       currentRange*current, utrSum, ':k', currentRange*current, sacSum, '--k'); 
%     title('Horizontal (red), posterior (blue), superior (green), utricle (..black), saccule(--black)');
%     xlabel('current in amps');
%     ylabel('number of fibers stimulated');
%     maxNum = max([horSum posSum supSum utrSum sacSum]);
%     axis([0 max(currVector) 0 maxNum])
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
%     axis([0 max(currVector) 0 maxNum])
% end


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