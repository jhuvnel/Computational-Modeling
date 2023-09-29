%% FEM_data_output2.m
% Generates data for Jan abstract submissions!
% Script for extracting voltage and nerve vector field data from an FEM
% model. The voltage will be used to find an extracellular voltage at each
% node on an axon. The vector fields generated from the curvilinear
% coordinates flow method are used to generate trajectories for axons
% within each nerve. Must have the Matlab-Comsol API running and the solved
% model open, with the modelClient saved in the worskpace variable model.
% Should also have the voltage tags saved as a cell array in case the
% number of electrode pairs is not always the same.
% January 2023, Evan Vesper, VNEL

%% Define Comsol tags
geom_tag = 'geom1';

% dset_fac = 'dset1';
sel_fac_dom = 'geom1_sel17'; % selection for facial nerve domain
% dset_coch = 'dset1';
sel_coch_dom = 'geom1_sel18'; % selection for cochlear nerve domain
% dset_IVN = 'dset1'; % tag for the dataset containing vestibular nerve flow vector field
% dset_SVN = 'dset1'; % tag for the dataset containing vestibular nerve flow vector field

sel_IVN_dom = 'geom1_sel19'; % IVN domain selection
sel_SVN_dom = 'geom1_sel20'; % SVN domain selection


sel_facial_inlet = 'geom1_sel22';
sel_facial_outlet = 'geom1_sel21';
sel_coch_inlet = 'geom1_sel24';
sel_coch_outlet = 'geom1_sel23';
sel_IVN_inlet_bnd = 'geom1_csel2_bnd'; % boundary selection for vestibular nerve inlet (proximal end of nerve)
sel_IVN_outlet_bnd = 'geom1_sel25'; % boundary selection for vestibular nerve outlet (cristas for 3 canals and otolith organs)
sel_SVN_inlet_bnd = 'geom1_csel3_bnd'; % boundary selection for vestibular nerve inlet (proximal end of nerve)
sel_SVN_outlet_bnd = 'geom1_sel28'; % boundary selection for vestibular nerve outlet (cristas for 3 canals and otolith organs)

% boundary selections for individual crista
sel_post_crista_bnd = 'geom1_sel26'; % posterior canal crista
sel_lat_crista_bnd = 'geom1_sel29'; % lateral canal crista
sel_ant_crista_bnd = 'geom1_sel30'; % anterior canal crista
sel_sacc_crista_bnd = 'geom1_sel27'; % saccule crista
sel_utr_crista_bnd = 'geom1_sel31'; % utricle crista

% tags for vector field data
basisVec1TagsFac = {'cc.e1x','cc.e1y','cc.e1z'}; % facial nerve
basisVec2TagsFac = {'cc.e2x','cc.e2y','cc.e2z'}; % facial nerve
basisVec3TagsFac = {'cc.e3x','cc.e3y','cc.e3z'}; % facial nerve
basisVecTagsFac = [basisVec1TagsFac, basisVec2TagsFac, basisVec3TagsFac];

basisVec1TagsCoch = {'cc2.e1x','cc2.e1y','cc2.e1z'}; % cochlear nerve
basisVec2TagsCoch = {'cc2.e2x','cc2.e2y','cc2.e2z'}; % cochlear nerve
basisVec3TagsCoch = {'cc2.e3x','cc2.e3y','cc2.e3z'}; % cochlear nerve
basisVecTagsCoch = [basisVec1TagsCoch, basisVec2TagsCoch, basisVec3TagsCoch];

basisVec1TagsIVN = {'cc3.e1x','cc3.e1y','cc3.e1z'}; % basis vector 1 (along the axon)
basisVec2TagsIVN = {'cc3.e2x','cc3.e2y','cc3.e2z'}; % basis vector 2 (orthogonal to other two vectors)
basisVec3TagsIVN = {'cc3.e3x','cc3.e3y','cc3.e3z'}; % basis vector 3 (orthogonal to other two vectors)
basisVecTagsIVN = [basisVec1TagsIVN, basisVec2TagsIVN, basisVec3TagsIVN];

basisVec1TagsSVN = {'cc4.e1x','cc4.e1y','cc4.e1z'}; % basis vector 1 (along the axon)
basisVec2TagsSVN = {'cc4.e2x','cc4.e2y','cc4.e2z'}; % basis vector 2 (orthogonal to other two vectors)
basisVec3TagsSVN = {'cc4.e3x','cc4.e3y','cc4.e3z'}; % basis vector 3 (orthogonal to other two vectors)
basisVecTagsSVN = [basisVec1TagsSVN, basisVec2TagsSVN, basisVec3TagsSVN];

% tags for electric potential and currents
% vTags = {'V1_1','V1_2','V1_3','V1_4','V1_5','V1_6','V1_7','V1_8','V1_9','V1_10','V1_11','V1_12','V1_13','V1_14','V15','V16'};
vTags = voltageTags; % from FEM_analysis script
% vTags = {'V1_1','V1_2','V1_3','V1_4','V1_5','V1_6'};
% JTags = {'ec.Jx','ec.Jy','ec.Jz',...
%     'ec2.Jx','ec2.Jy','ec2.Jz',...
%     'ec3.Jx','ec3.Jy','ec3.Jz',...
%     'ec4.Jx','ec4.Jy','ec4.Jz',...
%     'ec5.Jx','ec5.Jy','ec5.Jz',...
%     'ec6.Jx','ec6.Jy','ec6.Jz'};
% ITags = {'I_1','I_2','I_3','I_4','I_5','I_6'};

% tags for electrical currents physics nodes
% ecTags = {'ec','ec2','ec3','ec4','ec5','ec6'};
% dset_ec = 'dset2'; % dataset for electric currents

% get current date for save file name
fileDate = date;

% load tags
data_path = 'R:\Computational Modeling\Model as of 20230623\Results 20230816\';
tag_file = 'FEM_tags.mat';
load([data_path,tag_file])

% Import total current delivered to electrodes
% ITable_file = [model_name(1:end-4),'_delivered_currents.txt'];
% currents = readmatrix([data_path,ITable_file],'NumHeaderLines',5,'OutputType','double','Delimiter','    ');
currents = abs(currents); % take abs value of currents since they should all be positive. If Comsol thinks the surfaces are facing the other direction it would flip the sign on the current

% add paths of arclength and interparc functions for fiberGenComsolv2
addpath('C:\Users\Evan\Documents\GitHub\Computational-Modeling\FEM Automation\Utility Scripts\arclength','C:\Users\Evan\Documents\GitHub\Computational-Modeling\FEM Automation\Utility Scripts\interparc');

%% Extract flow information
tic
disp('Extracting flow information.')
% get flow vector field values for vestibular nerve
% selection argument pair means fxn will only return vector field data 
% within the selection specified (also the only volume it was actually calculated for)
flow_fac = mpheval(model,basisVec1TagsFac,'dataset',dset_fac,'selection',sel_fac_dom);
flow_coch = mpheval(model,basisVec1TagsCoch,'dataset',dset_coch,'selection',sel_coch_dom);
flow_IVN = mpheval(model,basisVec1TagsIVN,'dataset',dset_IVN,'selection',sel_IVN_dom);
flow_SVN = mpheval(model,basisVec1TagsSVN,'dataset',dset_SVN,'selection',sel_SVN_dom);

% get the mesh data for the facial and cochlear ends
flow_facial_inlet = mpheval(model,basisVec1TagsFac,'dataset',dset_fac,'selection',sel_facial_inlet);
flow_facial_outlet = mpheval(model,basisVec1TagsFac,'dataset',dset_fac,'selection',sel_facial_outlet);
flow_coch_inlet = mpheval(model,basisVec1TagsCoch,'dataset',dset_coch,'selection',sel_coch_inlet);
flow_coch_outlet = mpheval(model,basisVec1TagsCoch,'dataset',dset_coch,'selection',sel_coch_outlet);

% get the mesh data for the crista
flow_post_crista = mpheval(model,basisVec1TagsIVN,'dataset',dset_IVN,'selection',sel_post_crista_bnd);
flow_lat_crista = mpheval(model,basisVec1TagsSVN,'dataset',dset_SVN,'selection',sel_lat_crista_bnd);
flow_ant_crista = mpheval(model,basisVec1TagsSVN,'dataset',dset_SVN,'selection',sel_ant_crista_bnd);
flow_sacc_crista = mpheval(model,basisVec1TagsIVN,'dataset',dset_IVN,'selection',sel_sacc_crista_bnd);
flow_utr_crista = mpheval(model,basisVec1TagsSVN,'dataset',dset_SVN,'selection',sel_utr_crista_bnd);

flow_IVN_inlet = mpheval(model,basisVec1TagsIVN,'dataset',dset_IVN,'selection',sel_IVN_inlet_bnd);
flow_IVN_outlet = mpheval(model,basisVec1TagsIVN,'dataset',dset_IVN,'selection',sel_IVN_outlet_bnd);
flow_SVN_inlet = mpheval(model,basisVec1TagsSVN,'dataset',dset_SVN,'selection',sel_SVN_inlet_bnd);
flow_SVN_outlet = mpheval(model,basisVec1TagsSVN,'dataset',dset_SVN,'selection',sel_SVN_outlet_bnd);

% get voltage and electric current density values for all node points
% within vestibular nerve, for all electrode combinations
% ec_vest = mpheval(model,ecTags,'dataset',dset_ec,'selection',sel_vest_dom);

% reverese direction of flow since we want it going from crista towards
% brainstem - double check how you defined it in Comsol first!!!
flow_fac_fixed = flow_fac;
% flow_fac_fixed.d1 = -1*flow_fac.d1;
% flow_fac_fixed.d2 = -1*flow_fac.d2;
% flow_fac_fixed.d3 = -1*flow_fac.d3;

flow_coch_fixed = flow_coch;
% flow_coch_fixed.d1 = -1*flow_coch.d1;
% flow_coch_fixed.d2 = -1*flow_coch.d2;
% flow_coch_fixed.d3 = -1*flow_coch.d3;

flow_IVN_fixed = flow_IVN;
flow_SVN_fixed = flow_SVN;
% flow_vest_fixed.d1 = -1*flow_IVN.d1;
% flow_vest_fixed.d2 = -1*flow_IVN.d2;
% flow_vest_fixed.d3 = -1*flow_IVN.d3;

% %%
% flow_vest_tocrista = flow_vest;
% %%
% flow_vest_fromcrista = flow_vest;
disp('Flow information extracted.')
toc

%% SCC fiber gen
disp('--------Starting SCC fiber generation.--------')
tic
% The step size is the step in between each active node (of Ranvier) and
% the passive node (myelinated internode). So, it should be half the
% distance between the active nodes.
% step = [301e-3; 300.5e-3; -1];
step = [(parameterCellSCC_6to10{3}([1 2]) + (parameterCellSCC_6to10{4}(1)*[1;1]))*1000/2; -1];


numAxons_1to3 = parameterCellSCC_1to3{1}(1);
numAxons_2to5 = parameterCellSCC_2to5{1}(1);
numAxons_3to5 = parameterCellSCC_3to5{1}(1);
numAxons_4to7 = parameterCellSCC_4to7{1}(1);
numAxons_5to8 = parameterCellSCC_5to8{1}(1);
numAxons_6to10 = parameterCellSCC_6to10{1}(1);
numAxons_SCC = sum([numAxons_1to3, numAxons_2to5, numAxons_3to5, numAxons_4to7, numAxons_5to8, numAxons_6to10]);
% may want to generate new random locIndeces for each nerve
locIndex_SCC = [3*rand(numAxons_1to3,1); 3*rand(numAxons_2to5,1) + 2; 2*rand(numAxons_3to5,1) + 3; 3*rand(numAxons_4to7,1) + 4; 3*rand(numAxons_5to8,1) + 5; 4*rand(numAxons_6to10,1) + 6;];

[traj_post_pre, p0_post] = fiberGenComsolv2(flow_IVN_fixed, flow_post_crista, locIndex_SCC, step, basisVecTagsIVN, model, dset_IVN);
disp('Trajs done with posterior canal.')
[traj_lat_pre, p0_lat] = fiberGenComsolv2(flow_SVN_fixed, flow_lat_crista, locIndex_SCC, step, basisVecTagsSVN, model, dset_SVN);
disp('Trajs done with lateral canal.')
[traj_ant_pre, p0_ant] = fiberGenComsolv2(flow_SVN_fixed, flow_ant_crista, locIndex_SCC, step, basisVecTagsSVN, model, dset_SVN);
disp('Trajs done with anterior canal.')

toc

% Utricle and Saccule Fiber Gen
disp('--------Starting utricle and saccule fiber generation.--------')
tic

numAxons_1to4 = parameterCellUS_1to4{1}(1);
numAxons_3to7 = parameterCellUS_3to7{1}(1);
numAxons_6to10 = parameterCellUS_6to10{1}(1);
numAxons_utr_sacc = sum([numAxons_1to4, numAxons_3to7, numAxons_6to10]);
locIndex_utr_sacc = [4*rand(numAxons_1to4,1); 4*rand(numAxons_3to7,1) + 3; 4*rand(numAxons_6to10,1) + 6];

[traj_sacc_pre, p0_sacc] = fiberGenComsolv2(flow_IVN_fixed, flow_sacc_crista, locIndex_utr_sacc, step, basisVecTagsIVN, model, dset_IVN);
[traj_utr_pre, p0_utr] = fiberGenComsolv2(flow_SVN_fixed, flow_utr_crista, locIndex_utr_sacc, step, basisVecTagsSVN, model, dset_SVN);
disp('Utricle and saccule fibers done.')

toc

% Facial and Cochlear Fiber Gen
disp('--------Starting facial and cochlear fiber generation.--------')
tic
% step = [250.75e-3; -1];
step = [200.75e-3; -1];


numAxons_fac = 500;
locIndex_fac = 10*rand(numAxons_fac,1);
[traj_fac_pre, p0_fac] = fiberGenComsolv2(flow_fac, flow_facial_inlet, locIndex_fac, step, basisVecTagsFac, model, dset_fac);
disp('Trajs done with facial nerve.')

step = [(parameterCellSCC_6to10{3}([1 2]) + (parameterCellSCC_6to10{4}(1)*[1;1]))*1000/2; -1];
numAxons_coch = 1000; 
[traj_coch_pre, fiberType1, p0_coch] = fiberGenComsol(flow_coch_fixed,flow_coch_inlet,numAxons_coch,step); % unclear whether axial or distal origin is better
disp('Trajs done with cochlear nerve.')

toc

%% SCC fiber gen
% % [traj_post_pre, p0_post_crista] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% % [traj_lat_pre, p0_lat_crista] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% % [traj_ant_pre, p0_ant_crista] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% % [traj_sacc_pre, p0_sacc_crista] = fiberGenComsolv2(flow_vest_fixed, flow_sacc_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% % [traj_utr_pre, p0_utr_crista] = fiberGenComsolv2(flow_vest_fixed, flow_utr_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('--------Starting SCC fiber generation.--------')
% tic
% step = [301e-3; 300.5e-3; -1];
% % 1 to 3
% % this actually is 0-3 I think
% numAxons_1to3 = parameterCellSCC_1to3{1}(1);
% locIndex = 3*rand(numAxons_1to3,1);
% 
% [traj_post_pre_1to3, p0_post_crista_1to3] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_lat_pre_1to3, p0_lat_crista_1to3] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_ant_pre_1to3, p0_ant_crista_1to3] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 1 to 3.')
% 
% % 2 to 5
% % means locIndex can be 2-5
% numAxons_2to5 = parameterCellSCC_2to5{1}(1);
% locIndex = 3*rand(numAxons_2to5,1) + 2;
% 
% [traj_post_pre_2to5, p0_post_crista_2to5] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_lat_pre_2to5, p0_lat_crista_2to5] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_ant_pre_2to5, p0_ant_crista_2to5] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 2 to 5.')
% 
% % 3 to 5
% numAxons_3to5 = parameterCellSCC_3to5{1}(1);
% locIndex = 2*rand(numAxons_3to5,1) + 3;
% 
% [traj_post_pre_3to5, p0_post_crista_3to5] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_lat_pre_3to5, p0_lat_crista_3to5] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_ant_pre_3to5, p0_ant_crista_3to5] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 3 to 5.')
% 
% % 4 to 7
% numAxons_4to7 = parameterCellSCC_4to7{1}(1);
% locIndex = 3*rand(numAxons_4to7,1) + 4;
% 
% [traj_post_pre_4to7, p0_post_crista_4to7] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_lat_pre_4to7, p0_lat_crista_4to7] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_ant_pre_4to7, p0_ant_crista_4to7] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 4 to 7.')
% 
% % 5 to 8
% numAxons_5to8 = parameterCellSCC_5to8{1}(1);
% locIndex = 3*rand(numAxons_5to8,1) + 5;
% 
% [traj_post_pre_5to8, p0_post_crista_5to8] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_lat_pre_5to8, p0_lat_crista_5to8] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_ant_pre_5to8, p0_ant_crista_5to8] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 5 to 8.')
% 
% % 6 to 10
% numAxons_6to10 = parameterCellSCC_6to10{1}(1);
% locIndex = 4*rand(numAxons_6to10,1) + 6;
% 
% [traj_post_pre_6to10, p0_post_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_lat_pre_6to10, p0_lat_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_ant_pre_6to10, p0_ant_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 6 to 10.')
% 
% toc
%%
% disp('--------Starting utricle and saccule fiber generation.--------')
% tic
% step = [301e-3; 300.5e-3; -1];
% % 1 to 4
% numAxons_1to4 = parameterCellUS_1to4{1}(1);
% locIndex = 4*rand(numAxons_1to4,1);
% 
% [traj_sacc_pre_1to4, p0_sacc_crista_1to4] = fiberGenComsolv2(flow_vest_fixed, flow_sacc_crista, numAxons_1to4, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_utr_pre_1to4, p0_utr_crista_1to4] = fiberGenComsolv2(flow_vest_fixed, flow_utr_crista, numAxons_1to4, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 1 to 4.')
% 
% % 3 to 7
% numAxons_3to7 = parameterCellUS_3to7{1}(1);
% locIndex = 4*rand(numAxons_3to7,1) + 3;
% 
% [traj_sacc_pre_3to7, p0_sacc_crista_3to7] = fiberGenComsolv2(flow_vest_fixed, flow_sacc_crista, numAxons_3to7, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_utr_pre_3to7, p0_utr_crista_3to7] = fiberGenComsolv2(flow_vest_fixed, flow_utr_crista, numAxons_3to7, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 3 to 7.')
% 
% % 6 to 10
% numAxons_6to10 = parameterCellUS_6to10{1}(1);
% locIndex = 4*rand(numAxons_6to10,1) + 6;
% 
% [traj_sacc_pre_6to10, p0_sacc_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_sacc_crista, numAxons_6to10, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_utr_pre_6to10, p0_utr_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_utr_crista, numAxons_6to10, locIndex, step, basisVecTagsVest, model, dset_vest);
% disp('Trajs done with locIndex 6 to 10.')
% 
% toc

%% Check which trajectories failed and trim nodes
% Remove all the trajectories that aren't long enough (hit the wall of the
% nerve). In the future I need to fix the flow to avoid this happening, or
% change the fiberGenComsol/stream3Comsol function(s) to keep trying new
% starting points until I get the desired number of axons (like a Monte
% Carlo method).
% Also remove extra nodes if there are more than 40, since the neuromorphic
% model can't assign initial conditions to axons that are longer than 40
% nodes long. Note - nodes include nodes of Ranvier and internodes! (active
% and passive nodes).
all_trajs = {traj_post_pre,traj_lat_pre,traj_ant_pre,traj_sacc_pre,traj_utr_pre, traj_fac_pre, traj_coch_pre};

minTrajLen = 3; % mm, minimum length of axon trajectory
maxNodes = 40; % maximum number of nodes

numActualAxonsAll = zeros(length(all_trajs),1);
toKeep = cell(length(all_trajs),1);
all_trajs_out = toKeep;
for i = 1:length(all_trajs)
    toKeep{i} = false(length(all_trajs{i}),1);
    if iscell(all_trajs{i})
        for j = 1:size(all_trajs{i},1)
            % calculate length of axon
            arcLens = sqrt(sum( (all_trajs{i}{j,3}(:,2:end) - all_trajs{i}{j,3}(:,1:end-1)).^2 ,1));
            totLen = sum(arcLens);
            if totLen >= minTrajLen % length of trajectory must be at least x mm
                toKeep{i}(j) = true;
                nNodes = length(all_trajs{i}{j,3}(1,:));
                if nNodes > maxNodes % too many nodes

                    if i == 6 % for facial nerve only...
                        % This alternates removing nodes from either end of the axon so
                        % that the center (which is nearest the canals and electrodes) is
                        % preserved.
                        side = 0;
                        while nNodes > maxNodes
                            if side == 1
                                all_trajs{i}{j,3} = all_trajs{i}{j,3}(:,1:end-1); % remove last node
                                all_trajs{i}{j,2} = all_trajs{i}{j,2}(1:end-1);
                                side = 0; % alternate side
                            else
                                all_trajs{i}{j,3} = all_trajs{i}{j,3}(:,2:end); % remove first node
                                all_trajs{i}{j,2} = all_trajs{i}{j,2}(1:end-1);
                                side = 1; % alternate side
                            end
                            
                            nNodes = length(all_trajs{i}{j,3}(1,:)); % recalculate number of nodes
                        end

                    else % all other nerves
                        all_trajs{i}{j,3} = all_trajs{i}{j,3}(:,1:maxNodes); % take off extra nodes at end
                        all_trajs{i}{j,2} = all_trajs{i}{j,2}(1:maxNodes);
                    end

                end
            end
        end
        all_trajs_out{i} = all_trajs{i}(toKeep{i},:);
        numActualAxonsAll(i) = size(all_trajs_out{i},1);
    end
    disp([num2str(numActualAxonsAll(i)),'/',num2str(size(all_trajs{i},1)),' axons successfully generated in nerve ',num2str(i),'.'])
end
disp('----------------------------------------------')

traj_post = all_trajs_out{1};
traj_lat = all_trajs_out{2};
traj_ant = all_trajs_out{3};
traj_sacc = all_trajs_out{4};
traj_utr = all_trajs_out{5};
traj_fac = all_trajs_out{6};
traj_coch = all_trajs_out{7};
clear all_trajs all_trajs_out

beep


%%
% save(['trajs_',fileDate],"traj_vestinlet","traj_post","traj_lat","traj_ant","traj_sacc","traj_utr")
save_dir = 'R:\Computational Modeling\Model as of 20230623\Results 20230816\';
% save([save_dir,'trajs_',fileDate],"traj_post","traj_lat","traj_ant","traj_sacc","traj_utr","traj_fac","traj_coch")
save([save_dir,'trajs_',fileDate],"traj_post","traj_lat","traj_ant",...
    "traj_sacc","traj_utr", "traj_post_pre","traj_lat_pre",...
    "traj_ant_pre","traj_sacc_pre","traj_utr_pre","traj_fac",...
    "traj_coch","traj_fac_pre","traj_coch_pre", "toKeep")

%% Full FEM sampling along all trajectories
tic
% sol_post = []; sol_lat = []; sol_ant = []; sol_sacc = []; sol_utr = []; sol_fac = []; sol_coch = [];

% This is only extracting the monopolar stimulation cases
sol_post = sampleFEM(model,vTags,ecTags,dset_ec,traj_post,currents);
sol_lat = sampleFEM(model,vTags,ecTags,dset_ec,traj_lat,currents);
sol_ant = sampleFEM(model,vTags,ecTags,dset_ec,traj_ant,currents);
sol_sacc = sampleFEM(model,vTags,ecTags,dset_ec,traj_sacc,currents);
sol_utr = sampleFEM(model,vTags,ecTags,dset_ec,traj_utr,currents);
sol_fac = sampleFEM(model,vTags,ecTags,dset_ec,traj_fac,currents);
sol_coch = sampleFEM(model,vTags,ecTags,dset_ec,traj_coch,currents);

%
save([save_dir,'MonopolarSolution',fileDate],'sol_post','sol_lat','sol_ant','sol_sacc',...
    'sol_utr','sol_fac','sol_coch','waveForm','currents', 'StimElectrodeNames', 'RefElectrodeNames')
toc

%% Create electrode combinations by superimposing voltage fields
% Creates bipolar stimulation cases by adding/subtracting voltage values
% from monopolar cases.

% only the bipolar cases that I simulated in COMSOL
sol_bipolar_comsol = [sol_post(15:16); sol_lat(15:16); sol_ant(15:16); sol_sacc(15:16); sol_utr(15:16); sol_fac(15:16); sol_coch(15:16)];
sol_test = electrodeSuperposition(sol_post{15}, sol_post{16});

% Save bipolar test results
save([save_dir,'BipolarComsolSolution',fileDate],'sol_bipolar_comsol','sol_test',...
    'waveForm','currents', 'StimElectrodeNames', 'RefElectrodeNames')

% Generating all electrode combinations
[sol_post, ~, ~] = electrodeCombosNancy(sol_post, StimElectrodeNames, RefElectrodeNames);
[sol_lat, ~, ~] = electrodeCombosNancy(sol_lat, StimElectrodeNames, RefElectrodeNames);
[sol_ant, ~, ~] = electrodeCombosNancy(sol_ant, StimElectrodeNames, RefElectrodeNames);
[sol_sacc, ~, ~] = electrodeCombosNancy(sol_sacc, StimElectrodeNames, RefElectrodeNames);
[sol_utr, ~, ~] = electrodeCombosNancy(sol_utr, StimElectrodeNames, RefElectrodeNames);
[sol_fac, ~, ~] = electrodeCombosNancy(sol_fac, StimElectrodeNames, RefElectrodeNames);
[sol_coch, StimElectrodeNames, RefElectrodeNames] = electrodeCombosNancy(sol_coch, StimElectrodeNames, RefElectrodeNames);

% Save results
save([save_dir,'AllComboSolution',fileDate],'sol_post','sol_lat','sol_ant','sol_sacc',...
    'sol_utr','sol_fac','sol_coch','waveForm','currents', 'StimElectrodeNames', 'RefElectrodeNames')

%% Create parameter cells for aggregated traj cell arrays
Vthresh = 0.085; % activation threshold relative to resting membrane potential, V
% Make generic template for an individual parameter cell
parameterCellTemplate = cell(10,1);
parameterCellTemplate{1} = [0; 0; 0]; % [number of axons, first axon, last axon]
parameterCellTemplate{2} = 1e-7; % timestep, s
parameterCellTemplate{3} = [2e-6; 1e-6;-1]; % active node (nodes of Ranvier) lengths, m
parameterCellTemplate{4} = [300e-6; -1]; % passive node (internode) lengths, m
parameterCellTemplate{5} = []; % fiber diameters at each node, m
parameterCellTemplate{6} = []; % initial state array
parameterCellTemplate{7} = Vthresh; % activation threshold voltage, V
parameterCellTemplate{8} = [100; 300]; % limit on fine threshold
parameterCellTemplate{9} = 0.01; % precision for finding thresholds, i.e. 0.01 = 1%
parameterCellTemplate{10} = [];


%%% SCCs %%%

% Define number of axons in each band
% [1to3, 2to5, 3to5, 4to7, 5to8, 6to10]
numAxons_SCC = [50, 150, 50, 150, 50, 55];
tempSCC = cumsum(numAxons_SCC);

% Define fiber diameters for each band
fiberDiams_SCC = [1.4, 2.21, 1.4, 2.23, 2.49, 2.81]*1e-6; % m

bigParamCellSCC = cell(3,6); % create a new cell array to hold all the parameter cells... nCanal x nBandSCC size
for i = 1:3

    for j = 1:6
        % first copy parameter cells
        bigParamCellSCC{i,j} = parameterCellTemplate;
        
        % assign fiber diameters
        bigParamCellSCC{i,j}{5} = ones(numAxons_SCC(j), 1)*[fiberDiams_SCC(j), -1];
    end

    % now put in the correct axons this parameter cell will refer to
    % the 10th cell keeps track of total number of axons in all bands as
    % you count up
    bigParamCellSCC{i,1}{10} = [sum(toKeep{i}(1:tempSCC(1))); 1; tempSCC(1) - sum(~toKeep{i}(1:tempSCC(1)))];
    bigParamCellSCC{i,2}{10} = [sum(toKeep{i}(tempSCC(1)+1 : tempSCC(2))); bigParamCellSCC{i,1}{10}(3) + 1; bigParamCellSCC{i,1}{10}(3) + sum(toKeep{i}(tempSCC(1)+1 : tempSCC(2)))];
    bigParamCellSCC{i,3}{10} = [sum(toKeep{i}(tempSCC(2)+1 : tempSCC(3))); bigParamCellSCC{i,2}{10}(3) + 1; bigParamCellSCC{i,2}{10}(3) + sum(toKeep{i}(tempSCC(2)+1 : tempSCC(3)))];
    bigParamCellSCC{i,4}{10} = [sum(toKeep{i}(tempSCC(3)+1 : tempSCC(4))); bigParamCellSCC{i,3}{10}(3) + 1; bigParamCellSCC{i,3}{10}(3) + sum(toKeep{i}(tempSCC(3)+1 : tempSCC(4)))];
    bigParamCellSCC{i,5}{10} = [sum(toKeep{i}(tempSCC(4)+1 : tempSCC(5))); bigParamCellSCC{i,4}{10}(3) + 1; bigParamCellSCC{i,4}{10}(3) + sum(toKeep{i}(tempSCC(4)+1 : tempSCC(5)))];
    bigParamCellSCC{i,6}{10} = [sum(toKeep{i}(tempSCC(5)+1 : tempSCC(6))); bigParamCellSCC{i,5}{10}(3) + 1; bigParamCellSCC{i,5}{10}(3) + sum(toKeep{i}(tempSCC(5)+1 : tempSCC(6)))];

    bigParamCellSCC{i,1}{1} = [sum(toKeep{i}(1:tempSCC(1))); 1; tempSCC(1) - sum(~toKeep{i}(1:tempSCC(1)))];
    bigParamCellSCC{i,2}{1} = [sum(toKeep{i}(tempSCC(1)+1 : tempSCC(2))); 1; sum(toKeep{i}(tempSCC(1)+1 : tempSCC(2)))];
    bigParamCellSCC{i,3}{1} = [sum(toKeep{i}(tempSCC(2)+1 : tempSCC(3))); 1; sum(toKeep{i}(tempSCC(2)+1 : tempSCC(3)))];
    bigParamCellSCC{i,4}{1} = [sum(toKeep{i}(tempSCC(3)+1 : tempSCC(4))); 1; sum(toKeep{i}(tempSCC(3)+1 : tempSCC(4)))];
    bigParamCellSCC{i,5}{1} = [sum(toKeep{i}(tempSCC(4)+1 : tempSCC(5))); 1; sum(toKeep{i}(tempSCC(4)+1 : tempSCC(5)))];
    bigParamCellSCC{i,6}{1} = [sum(toKeep{i}(tempSCC(5)+1 : tempSCC(6))); 1; sum(toKeep{i}(tempSCC(5)+1 : tempSCC(6)))];

    for j = 1:6
        % now put in random initial conditions
        bigParamCellSCC{i,j}{6} = rand(bigParamCellSCC{i,j}{1}(1),1);
    end

end

%%% US %%%
% Define number of axons in each band
% [1to4, 3to7, 6to10]
numAxons_US = [150, 150, 150];
tempUS = cumsum(numAxons_US);

% Define fiber diameters for each band
fiberDiams_US = [1.4, 2.21, 2.23]*1e-6; % m

bigParamCellUS = cell(2,3); % nOtolith x nBandUS

for i = 4:5 % iterator for toKeep
    ii = i - 3; % iterator for bigParamCellUS
    
    for j = 1:3
        % first copy parameter cells
        bigParamCellUS{ii,j} = parameterCellTemplate;

        % assign fiber diameters
        bigParamCellUS{ii,j}{5} = ones(numAxons_US(j), 1)*[fiberDiams_US(j), -1];
    end

    % now put in the correct axons this parameter cell will refer to
    bigParamCellUS{ii,1}{10} = [sum(toKeep{i}(1:tempUS(1))); 1; tempUS(1) - sum(~toKeep{i}(1:tempUS(1)))];
    bigParamCellUS{ii,2}{10} = [sum(toKeep{i}(tempUS(1)+1 : tempUS(2))); bigParamCellUS{ii,1}{10}(3) + 1; bigParamCellUS{ii,1}{10}(3) + sum(toKeep{i}(tempUS(1)+1 : tempUS(2)))];
    bigParamCellUS{ii,3}{10} = [sum(toKeep{i}(tempUS(2)+1 : tempUS(3))); bigParamCellUS{ii,2}{10}(3) + 1; bigParamCellUS{ii,2}{10}(3) + sum(toKeep{i}(tempUS(2)+1 : tempUS(3)))];

    bigParamCellUS{ii,1}{1} = [sum(toKeep{i}(1:tempUS(1))); 1; tempUS(1) - sum(~toKeep{i}(1:tempUS(1)))];
    bigParamCellUS{ii,2}{1} = [sum(toKeep{i}(tempUS(1)+1 : tempUS(2))); 1; sum(toKeep{i}(tempUS(1)+1 : tempUS(2)))];
    bigParamCellUS{ii,3}{1} = [sum(toKeep{i}(tempUS(2)+1 : tempUS(3))); 1; sum(toKeep{i}(tempUS(2)+1 : tempUS(3)))];

    for j = 1:3
        % now put in random initial conditions
        bigParamCellUS{ii,j}{6} = rand(bigParamCellUS{ii,j}{1}(1),1);
    end
end

%%% US with 7 bands %%%
% nBandUS = 7;
% numAxons_1to4A = 100;
% numAxons_1to4B1 = 50;
% numAxons_3to7B1 = 100;
% numAxons_3to7B2 = 50;
% numAxons_6to10B2 = 50;
% numAxons_6to10B3 = 50;
% numAxons_6to10C = 50;
% 
% tempUS = cumsum([numAxons_1to4A, numAxons_1to4B1, numAxons_3to7B1, numAxons_3to7B2, numAxons_6to10B2, numAxons_6to10B3, numAxons_6to10C]);
% 
% bigParamCellUS = cell(2,nBandUS); % nOtolith x nBandUS
% 
% for i = 4:5 % iterator for toKeep
%     ii = i - 3; % iterator for bigParamCellUS
%     
%     % first copy parameter cells
%     bigParamCellUS{ii,1} = parameterCellUS_1to4_typeA;
%     bigParamCellUS{ii,2} = parameterCellUS_1to4_typeB1;
% 
%     bigParamCellUS{ii,3} = parameterCellUS_3to7_typeB1;
%     bigParamCellUS{ii,4} = parameterCellUS_3to7_typeB2;
% 
%     bigParamCellUS{ii,5} = parameterCellUS_6to10_typeB2;
%     bigParamCellUS{ii,6} = parameterCellUS_6to10_typeB3;
%     bigParamCellUS{ii,7} = parameterCellUS_6to10_typeC;
% 
%     
%     % now put in the correct axons this parameter cell will refer to
%     bigParamCellUS{ii,1}{10} = [sum(toKeep{i}(1:tempUS(1))); 1; tempUS(1) - sum(~toKeep{i}(1:tempUS(1)))];
%     bigParamCellUS{ii,2}{10} = [sum(toKeep{i}(tempUS(1)+1 : tempUS(2))); bigParamCellUS{ii,1}{10}(3) + 1; bigParamCellUS{ii,1}{10}(3) + sum(toKeep{i}(tempUS(1)+1 : tempUS(2)))];
%     bigParamCellUS{ii,3}{10} = [sum(toKeep{i}(tempUS(2)+1 : tempUS(3))); bigParamCellUS{ii,2}{10}(3) + 1; bigParamCellUS{ii,2}{10}(3) + sum(toKeep{i}(tempUS(2)+1 : tempUS(3)))];
%     bigParamCellUS{ii,4}{10} = [sum(toKeep{i}(tempUS(3)+1 : tempUS(4))); bigParamCellUS{ii,3}{10}(3) + 1; bigParamCellUS{ii,3}{10}(3) + sum(toKeep{i}(tempUS(3)+1 : tempUS(4)))];
%     bigParamCellUS{ii,5}{10} = [sum(toKeep{i}(tempUS(4)+1 : tempUS(5))); bigParamCellUS{ii,4}{10}(3) + 1; bigParamCellUS{ii,4}{10}(3) + sum(toKeep{i}(tempUS(4)+1 : tempUS(5)))];
%     bigParamCellUS{ii,6}{10} = [sum(toKeep{i}(tempUS(5)+1 : tempUS(6))); bigParamCellUS{ii,5}{10}(3) + 1; bigParamCellUS{ii,5}{10}(3) + sum(toKeep{i}(tempUS(5)+1 : tempUS(6)))];
%     bigParamCellUS{ii,7}{10} = [sum(toKeep{i}(tempUS(6)+1 : tempUS(7))); bigParamCellUS{ii,6}{10}(3) + 1; bigParamCellUS{ii,6}{10}(3) + sum(toKeep{i}(tempUS(6)+1 : tempUS(7)))];
% 
%     
%     bigParamCellUS{ii,1}{1} = [sum(toKeep{i}(1:tempUS(1))); 1; tempUS(1) - sum(~toKeep{i}(1:tempUS(1)))];
%     bigParamCellUS{ii,2}{1} = [sum(toKeep{i}(tempUS(1)+1 : tempUS(2))); 1; sum(toKeep{i}(tempUS(1)+1 : tempUS(2)))];
%     bigParamCellUS{ii,3}{1} = [sum(toKeep{i}(tempUS(2)+1 : tempUS(3))); 1; sum(toKeep{i}(tempUS(2)+1 : tempUS(3)))];
%     bigParamCellUS{ii,4}{1} = [sum(toKeep{i}(tempUS(3)+1 : tempUS(4))); 1; sum(toKeep{i}(tempUS(3)+1 : tempUS(4)))];
%     bigParamCellUS{ii,5}{1} = [sum(toKeep{i}(tempUS(4)+1 : tempUS(5))); 1; sum(toKeep{i}(tempUS(4)+1 : tempUS(5)))];
%     bigParamCellUS{ii,6}{1} = [sum(toKeep{i}(tempUS(5)+1 : tempUS(6))); 1; sum(toKeep{i}(tempUS(5)+1 : tempUS(6)))];
%     bigParamCellUS{ii,7}{1} = [sum(toKeep{i}(tempUS(6)+1 : tempUS(7))); 1; sum(toKeep{i}(tempUS(6)+1 : tempUS(7)))];
% 
%     % set axon diameters - these depend on fiber type and species!!!
%     bigParamCellUS{ii,1}{5} = ones(bigParamCellUS{ii,1}{1}(1),1)*[1.4e-6, -1];
%     bigParamCellUS{ii,2}{5} = ones(bigParamCellUS{ii,2}{1}(1),1)*[2.21e-6, -1];
%     bigParamCellUS{ii,3}{5} = ones(bigParamCellUS{ii,3}{1}(1),1)*[2.21e-6, -1];
%     bigParamCellUS{ii,4}{5} = ones(bigParamCellUS{ii,4}{1}(1),1)*[2.23e-6, -1];
%     bigParamCellUS{ii,5}{5} = ones(bigParamCellUS{ii,5}{1}(1),1)*[2.23e-6, -1];
%     bigParamCellUS{ii,6}{5} = ones(bigParamCellUS{ii,6}{1}(1),1)*[2.49e-6, -1];
%     bigParamCellUS{ii,7}{5} = ones(bigParamCellUS{ii,7}{1}(1),1)*[2.81e-6, -1];
% 
%     % now put in random initial conditions
%     for j = 1:nBandUS
%         bigParamCellUS{ii,j}{6} = rand(bigParamCellUS{ii,j}{1}(1),1);
%     end
% end

%%% Facial and Cochlear Nerves %%%
% Facial and cochlear fibers are simpler since, at least right now, I am
% not varying fiber parameters.

% Facial
paramCellFac = cell(9,1);
paramCellFac{1} = [numActualAxonsAll(6); 1; numActualAxonsAll(6)]; % [number of axons, first axon, last axon]
paramCellFac{2} = 1e-7; % timestep, s
paramCellFac{3} = [1.5e-6; 1.5e-6;-1]; % active node (nodes of Ranvier) lengths, m
paramCellFac{4} = [500e-6; -1]; % passive node (internode) lengths, m
paramCellFac{5} = ones(paramCellFac{1}(1),1)*[8e-6, -1]; % fiber diameters at each node, m
paramCellFac{6} = rand(paramCellFac{1}(1),1); % initial state array
paramCellFac{7} = Vthresh; % activation threshold voltage, V
paramCellFac{8} = [100; 300]; % limit on fine threshold
paramCellFac{9} = 0.01; % precision for finding thresholds, i.e. 0.01 = 1%
paramCellFac{10} = paramCellFac{1};

% Cochlear
paramCellCoch = cell(9,1);
paramCellCoch{1} = [numActualAxonsAll(7); 1; numActualAxonsAll(7)]; % [number of axons, first axon, last axon]
paramCellCoch{2} = 1e-7; % timestep, s
paramCellCoch{3} = [2e-6; 1e-6;-1]; % active node (nodes of Ranvier) lengths, m
paramCellCoch{4} = [300e-6; -1]; % passive node (internode) lengths, m
paramCellCoch{5} = ones(paramCellCoch{1}(1),1)*[3e-6, -1]; % fiber diameters at each node, m
paramCellCoch{6} = rand(paramCellCoch{1}(1),1); % initial state array
paramCellCoch{7} = Vthresh; % activation threshold voltage, V
paramCellCoch{8} = [100; 300]; % limit on fine threshold
paramCellCoch{9} = 0.01; % precision for finding thresholds, i.e. 0.01 = 1%
paramCellCoch{10} = paramCellCoch{1};

%
save([save_dir,'params',fileDate],'bigParamCellSCC','bigParamCellUS','paramCellFac','paramCellCoch')
%% Generate Parameter cells for each nerve
% Vthresh = 0.085; % aactivation threshold relative to resting membrane potential, V
% 
% param_post = cell(9,1);
% param_post{1} = [numActualAxonsAll(1); 1; numActualAxonsAll(1)]; % [number of axons, first axon, last axon]
% param_post{2} = 1e-7; % timestep, s
% param_post{3} = [2e-6; 1e-6;-1]; % active node (nodes of Ranvier) lengths, m
% param_post{4} = [300e-6; -1]; % passive node (internode) lengths, m
% param_post{5} = ones(numAxons,1)*[1.4e-6, -1]; % fiber diameters at each node, m
% param_post{6} = rand(150,1); % initial state array
% param_post{7} = Vthresh; % activation threshold voltage, V
% param_post{8} = [100; 300]; % limit on fine threshold
% param_post{9} = 0.01; % precision for finding thresholds, i.e. 0.01 = 1%
% 
% % This copies the same parameters for all nerves, except it makes sure 
% param_lat = param_post;
% param_lat{1} = [numActualAxonsAll(2); 1; numActualAxonsAll(2)];
% param_lat{6} = rand(150,1);
% param_ant = param_post;
% param_ant{1} = [numActualAxonsAll(3); 1; numActualAxonsAll(3)];
% param_ant{6} = rand(150,1);
% param_sacc = param_post;
% param_sacc{1} = [numActualAxonsAll(4); 1; numActualAxonsAll(4)];
% param_sacc{6} = rand(150,1);
% param_utr = param_post;
% param_utr{1} = [numActualAxonsAll(5); 1; numActualAxonsAll(5)];
% param_utr{6} = rand(150,1);
% 
% %% Create parameter cell
% % NOTE: the java Axon models expect everything in meters, not mm so make
% % sure to convert internode distances, diameters, etc...
% numActualAxons = size(solutionBigCell{1},1);
% Vthresh = 0.085; % aactivation threshold relative to resting membrane potential, V
% 
% parameterTest = cell(9,1);
% parameterTest{1} = [numActualAxons; 1; numActualAxons]; % [number of axons, first axon, last axon]
% parameterTest{2} = 1e-7; % timestep, s
% parameterTest{3} = [2e-6; 1e-6;-1]; % active node (nodes of Ranvier) lengths, m
% parameterTest{4} = [300e-6; -1]; % passive node (internode) lengths, m
% parameterTest{5} = ones(numActualAxons,1)*[1.4e-6, -1]; % fiber diameters at each node, m
% parameterTest{6} = rand(150,1); % initial state array
% parameterTest{7} = Vthresh; % activation threshold voltage, V
% parameterTest{8} = [100; 300]; % limit on fine threshold
% parameterTest{9} = 0.01; % precision for finding thresholds, i.e. 0.01 = 1%


% %% Save parameter cell, trajectory cell, solution cell, waveform, and total current for simulation...
% save(['testSolution',fileDate],'parameterTest','traj_test2','solutionBigCell','waveForm','current')
% 
% 
% %% Save parameter cell, solution cells, waveform, and total current for simulation...
% save(['fullSolution',fileDate],'param_post','param_lat','param_ant',...
%     'param_sacc','param_utr','sol_post','sol_lat','sol_ant','sol_sacc',...
%     'sol_utr','waveForm','current')
%% Plot everything
% plot crista origin results
f12 = plotFlow(flow_IVN_fixed,flow_post_crista,traj_post_pre(toKeep{1},3));
f12.Position = [200 200 560 420];
badTraj = traj_post_pre(~toKeep{1},3);
% for i = 1:sum(~toKeep{1})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
title(gca,'Post. Crista Origin')
f22 = plotFlow(flow_SVN_fixed,flow_lat_crista,traj_lat_pre(toKeep{2},3));
f22.Position = [200 200 560 420];
badTraj = traj_lat_pre(~toKeep{2},3);
% for i = 1:sum(~toKeep{2})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
title(gca,'Lat. Crista Origin')
f32 = plotFlow(flow_SVN_fixed,flow_ant_crista,traj_ant_pre(toKeep{3},3));
f32.Position = [200 200 560 420];
badTraj = traj_ant_pre(~toKeep{3},3);
% for i = 1:sum(~toKeep{3})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
title(gca,'Ant. Crista Origin')
f42 = plotFlow(flow_IVN_fixed,flow_sacc_crista,traj_sacc_pre(toKeep{4},3));
f42.Position = [200 200 560 420];
badTraj = traj_sacc_pre(~toKeep{4},3);
% for i = 1:sum(~toKeep{4})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
title(gca,'Sacc. Macula Origin')
f52 = plotFlow(flow_SVN_fixed,flow_utr_crista,traj_utr_pre(toKeep{5},3));
f52.Position = [200 200 560 420];
badTraj = traj_utr_pre(~toKeep{5},3);
% for i = 1:sum(~toKeep{5})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
title(gca,'Utr. Macula Origin')

f62 = plotFlow(flow_fac,flow_facial_inlet,traj_fac_pre(toKeep{6},3));
f62.Position = [200 200 560 420];
badTraj = traj_fac_pre(~toKeep{6},3);
% for i = 1:sum(~toKeep{6})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
title(gca,'Facial Nerve')
f72 = plotFlow(flow_coch_fixed,flow_coch_outlet,traj_coch_pre(toKeep{7},3));
f72.Position = [200 200 560 420];
badTraj = traj_coch_pre(~toKeep{7},3);
% for i = 1:sum(~toKeep{7})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
title(gca,'Cochlear Nerve')
% f82 = plotFlow(flow_IVN,flow_IVN_inlet,traj_vestinlet_pre(toKeep{8},3));
% f82.Position = [200 200 560 420];
% badTraj = traj_vestinlet_pre(~toKeep{8},3);
% for i = 1:sum(~toKeep{8})
%     plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
% end
% title(gca,'Axial Vestibular Origin')


%% Plot incomplete trajectories
% % plot vestibular inlet results
% f1 = plotFlow(flow_vest,flow_vestinlet,traj_vestinlet(:,3));
% title(gca,'Vest. Inlet Origin')
% 
% % plot crista origin results
% f2 = plotFlow(flow_vest_fixed,flow_post_crista,traj_post(:,3));
% title(gca,'Post. Crista Origin')
% f3 = plotFlow(flow_vest_fixed,flow_lat_crista,traj_lat(:,3));
% title(gca,'Lat. Crista Origin')
% f4 = plotFlow(flow_vest_fixed,flow_ant_crista,traj_ant(:,3));
% title(gca,'Ant. Crista Origin')
% f5 = plotFlow(flow_vest_fixed,flow_sacc_crista,traj_sacc(:,3));
% title(gca,'Sacc. Crista Origin')
% f6 = plotFlow(flow_vest_fixed,flow_utr_crista,traj_utr(:,3));
% title(gca,'Utr. Crista Origin')
%%
% plot all the crista trajectories together
flows_crista = {flow_IVN_inlet,flow_post_crista,flow_lat_crista,...
    flow_ant_crista,flow_sacc_crista,flow_utr_crista,flow_facial_inlet,...
    flow_facial_outlet,flow_coch_inlet,flow_coch_outlet};
% just pull out ~10% of the trajs so that they are distinguishable
trajs_crista = {traj_ant(1:10:end,3),traj_lat(1:10:end,3),traj_post(1:10:end,3),...
    traj_sacc(1:10:end,3),traj_utr(1:10:end,3),...
    traj_fac(1:10:end,3),traj_coch(1:10:end,3)};
f7 = plotMultiFlow(flow_IVN_fixed,flows_crista,trajs_crista,'plotFlow',false);
grid on
axis equal
f7.Units = 'inches';
f7.Position = [1 1 8 4.667];
title(gca,'Axons Generated for Each Nerve')
xlabel('x [mm]')
ylabel('y [mm]')
zlabel('z [mm]')

clear flows_crista trajs_crista

%% Dummy figure with proper legend
figure('Units','inches','Position',[1 1 6 6])
% red green blue orange brown yellow purple
trajColors = {'r','g','b',[0.8500 0.3250 0.0980],[165,42,42]/245,'c',[0.4940 0.1840 0.5560]};
nerve_names = {'Anterior Canal','Lateral Canal','Posterior Canal','Saccule','Utricle','Facial','Cochlear'};
temp1 = 1:8;
temp2 = 2:9;
for i = 1:7
    plot(temp1(i:i+1),temp2(i:i+1),'.-','Color',trajColors{i})
    hold on
end
legend(nerve_names,'Location','eastoutside')
%%
% toc
%% Save figures
figs = {f12, f22, f32, f42, f52, f62, f72};
% figs = {f12, f22, f32, f42, f52};
% figs = 2:2:10;
for i = 1:length(figs)
    saveas(figs{i},[save_dir,'traj_',num2str(i)])
%     saveas(figs{i},['R:\Computational Modeling\Model as of 20220908\nerveTrajTest',num2str(i)],'png')
%     saveas(figs,['R:\Computational Modeling\Model with curvilinear coordinates only\finemesh_2d_',num2str(i)])

end
%%
% for i = 11:15
%     saveas(i,['C:\Users\Evan\OneDrive - Johns Hopkins\VNEL1DRV\_Vesper\Modeling\Modeling Results\Traj step size figures\point1umstep',num2str(i)])
% end   