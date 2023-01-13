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
tic

%% Define Comsol tags
geom_tag = 'geom1';

dset_fac = 'dset1';
sel_fac_dom = 'geom1_imp1_Facial_Nerve1_dom'; % selection for facial nerve domain
dset_coch = 'dset2';
sel_coch_dom = 'geom1_imp1_Cochlear_Nerve1_dom'; % selection for cochlear nerve domain
dset_vest = 'dset3'; % tag for the dataset containing vestibular nerve flow vector field

% sel_vest_dom = 'geom1_imp1_Vestibular_Nerve1_dom'; % selection for vestibular nerve domain
sel_vest_dom = 'geom1_sel12'; % vestibular nerve domain selection for 20230104_otolith_edit model 

sel_facial_inlet = 'geom1_sel1';
sel_facial_outlet = 'geom1_sel2';
sel_coch_inlet = 'geom1_sel3';
sel_coch_outlet = 'geom1_sel4';
sel_vest_inlet_bnd = 'geom1_sel5'; % boundary selection for vestibular nerve inlet (proximal end of nerve)
sel_vest_outlet_bnd = 'geom1_sel6'; % boundary selection for vestibular nerve outlet (cristas for 3 canals and otolith organs)

% boundary selections for individual crista
sel_post_crista_bnd = 'geom1_sel7'; % posterior canal crista
sel_lat_crista_bnd = 'geom1_sel8'; % lateral canal crista
sel_ant_crista_bnd = 'geom1_sel9'; % anterior canal crista
sel_sacc_crista_bnd = 'geom1_sel10'; % saccule crista
sel_utr_crista_bnd = 'geom1_sel11'; % utricle crista

% tags for vector field data
% velTags = {'cc3.vX','cc3.vY','cc3.vY'}; % velocity field, but this doesn't generate proper trajectories
basisVec1TagsFac = {'cc.e1x','cc.e1y','cc.e1z'}; % facial nerve
basisVec2TagsFac = {'cc.e2x','cc.e2y','cc.e2z'}; % facial nerve
basisVec3TagsFac = {'cc.e3x','cc.e3y','cc.e3z'}; % facial nerve
basisVecTagsFac = [basisVec1TagsFac, basisVec2TagsFac, basisVec3TagsFac];

basisVec1TagsCoch = {'cc2.e1x','cc2.e1y','cc2.e1z'}; % cochlear nerve
basisVec2TagsCoch = {'cc2.e2x','cc2.e2y','cc2.e2z'}; % cochlear nerve
basisVec3TagsCoch = {'cc2.e3x','cc2.e3y','cc2.e3z'}; % cochlear nerve
basisVecTagsCoch = [basisVec1TagsCoch, basisVec2TagsCoch, basisVec3TagsCoch];

basisVec1TagsVest = {'cc3.e1x','cc3.e1y','cc3.e1z'}; % basis vector 1 (along the axon)
basisVec2TagsVest = {'cc3.e2x','cc3.e2y','cc3.e2z'}; % basis vector 2 (orthogonal to other two vectors)
basisVec3TagsVest = {'cc3.e3x','cc3.e3y','cc3.e3z'}; % basis vector 3 (orthogonal to other two vectors)
basisVecTagsVest = [basisVec1TagsVest, basisVec2TagsVest, basisVec3TagsVest];

% tags for electric potential and currents
vTags = {'V2_1','V2_3','V2_4','V2_5','V2_6','V2_7'};
% JTags = {'ec.Jx','ec.Jy','ec.Jz',...
%     'ec2.Jx','ec2.Jy','ec2.Jz',...
%     'ec3.Jx','ec3.Jy','ec3.Jz',...
%     'ec4.Jx','ec4.Jy','ec4.Jz',...
%     'ec5.Jx','ec5.Jy','ec5.Jz',...
%     'ec6.Jx','ec6.Jy','ec6.Jz'};

% tags for electrical currents physics nodes
ecTags = {'ec','ec2','ec3','ec4','ec5','ec6'};
dset_ec = 'dset4'; % dataset for electric currents

% get current date for save file name
fileDate = date;

%% Extract flow information
% get flow vector field values for vestibular nerve
% selection argument pair means fxn will only return vector field data 
% within the selection specified (also the only volume it was actually calculated for)
flow_fac = mpheval(model,basisVec1TagsFac,'dataset',dset_fac,'selection',sel_fac_dom);
flow_coch = mpheval(model,basisVec1TagsCoch,'dataset',dset_coch,'selection',sel_coch_dom);
flow_vest = mpheval(model,basisVec1TagsVest,'dataset',dset_vest,'selection',sel_vest_dom);

% get the mesh data for the facial and cochlear ends
flow_facial_inlet = mpheval(model,basisVec1TagsFac,'dataset',dset_fac,'selection',sel_facial_inlet);
flow_facial_outlet = mpheval(model,basisVec1TagsFac,'dataset',dset_fac,'selection',sel_facial_outlet);
flow_coch_inlet = mpheval(model,basisVec1TagsCoch,'dataset',dset_coch,'selection',sel_coch_inlet);
flow_coch_outlet = mpheval(model,basisVec1TagsCoch,'dataset',dset_coch,'selection',sel_coch_outlet);

% get the mesh data for the crista
flow_post_crista = mpheval(model,basisVec1TagsVest,'dataset',dset_vest,'selection',sel_post_crista_bnd);
flow_lat_crista = mpheval(model,basisVec1TagsVest,'dataset',dset_vest,'selection',sel_lat_crista_bnd);
flow_ant_crista = mpheval(model,basisVec1TagsVest,'dataset',dset_vest,'selection',sel_ant_crista_bnd);
flow_sacc_crista = mpheval(model,basisVec1TagsVest,'dataset',dset_vest,'selection',sel_sacc_crista_bnd);
flow_utr_crista = mpheval(model,basisVec1TagsVest,'dataset',dset_vest,'selection',sel_utr_crista_bnd);
flow_vestinlet = mpheval(model,basisVec1TagsVest,'dataset',dset_vest,'selection',sel_vest_inlet_bnd);

% get voltage and electric current density values for all node points
% within vestibular nerve, for all electrode combinations
% ec_vest = mpheval(model,ecTags,'dataset',dset_ec,'selection',sel_vest_dom);

%%
% reverese direction of flow since we want it going from crista towards
% brainstem - double check how you defined it in Comsol first!!!
flow_fac_fixed = flow_fac;
flow_fac_fixed.d1 = -1*flow_fac.d1;
flow_fac_fixed.d2 = -1*flow_fac.d2;
flow_fac_fixed.d3 = -1*flow_fac.d3;

flow_coch_fixed = flow_coch;
flow_coch_fixed.d1 = -1*flow_coch.d1;
flow_coch_fixed.d2 = -1*flow_coch.d2;
flow_coch_fixed.d3 = -1*flow_coch.d3;

flow_vest_fixed = flow_vest;
flow_vest_fixed.d1 = -1*flow_vest.d1;
flow_vest_fixed.d2 = -1*flow_vest.d2;
flow_vest_fixed.d3 = -1*flow_vest.d3;

% %%
% flow_vest_tocrista = flow_vest;
% %%
% flow_vest_fromcrista = flow_vest;
disp('Flow information extracted.')
toc

%% SCC fiber gen

% [traj_post_pre, p0_post_crista] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_lat_pre, p0_lat_crista] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_ant_pre, p0_ant_crista] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_sacc_pre, p0_sacc_crista] = fiberGenComsolv2(flow_vest_fixed, flow_sacc_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
% [traj_utr_pre, p0_utr_crista] = fiberGenComsolv2(flow_vest_fixed, flow_utr_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('--------Starting SCC fiber generation.--------')
tic
step = [301e-3; 300.5e-3; -1];
% 1 to 3
% this actually is 0-3 I think
numAxons_1to3 = parameterCellSCC_1to3{1}(1);
locIndex = 3*rand(numAxons_1to3,1);

[traj_post_pre_1to3, p0_post_crista_1to3] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_lat_pre_1to3, p0_lat_crista_1to3] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_ant_pre_1to3, p0_ant_crista_1to3] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('Trajs done with locIndex 1 to 3.')

% 2 to 5
% means locIndex can be 2-5
numAxons_2to5 = parameterCellSCC_2to5{1}(1);
locIndex = 3*rand(numAxons_2to5,1) + 2;

[traj_post_pre_2to5, p0_post_crista_2to5] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_lat_pre_2to5, p0_lat_crista_2to5] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_ant_pre_2to5, p0_ant_crista_2to5] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('Trajs done with locIndex 2 to 5.')

% 3 to 5
numAxons_3to5 = parameterCellSCC_3to5{1}(1);
locIndex = 2*rand(numAxons_3to5,1) + 3;

[traj_post_pre_3to5, p0_post_crista_3to5] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_lat_pre_3to5, p0_lat_crista_3to5] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_ant_pre_3to5, p0_ant_crista_3to5] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('Trajs done with locIndex 3 to 5.')

% 4 to 7
numAxons_4to7 = parameterCellSCC_4to7{1}(1);
locIndex = 3*rand(numAxons_4to7,1) + 4;

[traj_post_pre_4to7, p0_post_crista_4to7] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_lat_pre_4to7, p0_lat_crista_4to7] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_ant_pre_4to7, p0_ant_crista_4to7] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('Trajs done with locIndex 4 to 7.')

% 5 to 8
numAxons_5to8 = parameterCellSCC_5to8{1}(1);
locIndex = 3*rand(numAxons_5to8,1) + 5;

[traj_post_pre_5to8, p0_post_crista_5to8] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_lat_pre_5to8, p0_lat_crista_5to8] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_ant_pre_5to8, p0_ant_crista_5to8] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('Trajs done with locIndex 5 to 8.')

% 6 to 10
numAxons_6to10 = parameterCellSCC_6to10{1}(1);
locIndex = 4*rand(numAxons_6to10,1) + 6;

[traj_post_pre_6to10, p0_post_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_post_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_lat_pre_6to10, p0_lat_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_lat_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_ant_pre_6to10, p0_ant_crista_6to10] = fiberGenComsolv2(flow_vest_fixed, flow_ant_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('Trajs done with locIndex 6 to 10.')

toc

%% Utricle and Saccule Fiber Gen
disp('--------Starting utricle and saccule fiber generation.--------')
tic
step = [301e-3; 300.5e-3; -1];
% 1 to 4
numAxons_1to4 = parameterCellUS_1to4{1}(1);
numAxons_3to7 = parameterCellUS_3to7{1}(1);
numAxons_6to10 = parameterCellUS_6to10{1}(1);
numAxons_utr_sacc = sum([numAxons_1to4, numAxons_3to7, numAxons_6to10]);
locIndex = [4*rand(numAxons_1to4,1); 4*rand(numAxons_3to7,1) + 3; 4*rand(numAxons_6to10,1) + 6];

[traj_sacc_pre, p0_sacc_crista] = fiberGenComsolv2(flow_vest_fixed, flow_sacc_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
[traj_utr_pre, p0_utr_crista] = fiberGenComsolv2(flow_vest_fixed, flow_utr_crista, locIndex, step, basisVecTagsVest, model, dset_vest);
disp('Utricle and saccule fibers done.')

toc

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

%% Facial and Cochlear Fiber Gen
disp('--------Starting facial and cochlear fiber generation.--------')

tic
numAxons_fac = 500;
locIndex = 10*rand(numAxons_fac,1);
[traj_fac_pre, p0_fac] = fiberGenComsolv2(flow_fac, flow_facial_inlet, locIndex, step, basisVecTagsFac, model, dset_fac);
disp('Trajs done with facial nerve.')

numAxons_coch = 1000; 
[traj_coch_pre, fiberType1, p0_coch] = fiberGenComsol(flow_coch_fixed,flow_coch_outlet,numAxons_coch,step); % unclear whether axial or distal origin is better
disp('Trajs done with cochlear nerve.')

toc

%% Generate trajectories for all nerve divisions
% step = [301e-3; 300.5e-3; -1];
% % step = [.03; -1];
% % step = [.003; -1];
% numAxons = 100;
% [traj_fac_pre, fiberType1, p0_fac] = fiberGenComsol(flow_fac,flow_facial_inlet,numAxons,step); % facial nerve fibers generate better when originating axially
% [traj_coch_pre, fiberType1, p0_coch] = fiberGenComsol(flow_coch_fixed,flow_coch_outlet,numAxons*2,step); % unclear whether axial or distal origin is better
% % [traj_vestinlet_pre, fiberType1, p0_inlet] = fiberGenComsol(flow_vest,flow_vestinlet,numAxons*5,step); % axial vestibular origin
% 
% [traj_post_pre, fiberType1, p0_post_crista] = fiberGenComsol(flow_vest_fixed,flow_post_crista,numAxons,step);
% [traj_lat_pre, fiberType1, p0_lat_crista] = fiberGenComsol(flow_vest_fixed,flow_lat_crista,numAxons,step);
% [traj_ant_pre, fiberType1, p0_ant_crista] = fiberGenComsol(flow_vest_fixed,flow_ant_crista,numAxons,step);
% [traj_sacc_pre, fiberType1, p0_sacc_crista] = fiberGenComsol(flow_vest_fixed,flow_sacc_crista,numAxons,step);
% [traj_utr_pre, fiberType1, p0_utr_crista] = fiberGenComsol(flow_vest_fixed,flow_utr_crista,numAxons,step);

% remove all the trajectories that aren't long enough (hit the wall of the
% nerve). In the future I need to fix the flow to avoid this happening, or
% change the fiberGenComsol/stream3Comsol function(s) to keep trying new
% starting points until I get the desired number of axons (like a Monte
% Carlo method).
% all_trajs = {raj_post_pre,traj_lat_pre,traj_ant_pre,traj_sacc_pre,traj_utr_pre,traj_vestinlet_pret};
all_trajs = {traj_post_pre,traj_lat_pre,traj_ant_pre,traj_sacc_pre,traj_utr_pre, traj_fac_pre, traj_coch_pre, traj_vestinlet_pre};
% all_trajs = {traj_post_pre,0,0,0,0, traj_fac_pre, traj_coch_pre, traj_vestinlet_pre};

numActualAxonsAll = zeros(length(all_trajs),1);
toKeep = cell(length(all_trajs),1);
all_trajs_out = toKeep;
for i = 1:length(all_trajs)
    toKeep{i} = false(numAxons,1);
    if iscell(all_trajs{i})
        for j = 1:size(all_trajs{i},1)
            arcLens = sqrt(sum( (all_trajs{i}{j,3}(:,2:end) - all_trajs{i}{j,3}(:,1:end-1)).^2 ,1));
            totLen = sum(arcLens);
            if totLen >= 4.5 % length of trajectory must be at least 4.5 mm
                toKeep{i}(j) = true;
            end
        end
        all_trajs_out{i} = all_trajs{i}(toKeep{i},:);
        numActualAxonsAll(i) = size(all_trajs_out{i},1);
    end
    disp([num2str(numActualAxonsAll(i)),'/',num2str(size(all_trajs{i},1)),' axons succesfully generated in nerve ',num2str(i),'.'])
end
disp('----------------------------------------------')

traj_post = all_trajs_out{1};
traj_lat = all_trajs_out{2};
traj_ant = all_trajs_out{3};
traj_sacc = all_trajs_out{4};
traj_utr = all_trajs_out{5};
traj_fac = all_trajs_out{6};
traj_coch = all_trajs_out{7};
traj_vestinlet = all_trajs_out{8};
clear all_trajs all_trajs_out
beep

%%
% save(['trajs_',fileDate],"traj_vestinlet","traj_post","traj_lat","traj_ant","traj_sacc","traj_utr")
save_dir = 'R:\Computational Modeling\Solved model data 20230110\';
save([save_dir,'trajs_',fileDate],"traj_post","traj_lat","traj_ant","traj_sacc","traj_utr","traj_fac","traj_coch")
toc

%% Full FEM sampling along all trajectories
solf_fac = []; sol_coch = []; sol_post = []; sol_lat = []; sol_ant = []; sol_sacc = []; sol_utr = [];

sol_fac = sampleFEM(model,vTags,ecTags,dset_ec,traj_fac,current);
sol_coch = sampleFEM(model,vTags,ecTags,dset_ec,traj_coch,current);
sol_post = sampleFEM(model,vTags,ecTags,dset_ec,traj_post,current);
sol_lat = sampleFEM(model,vTags,ecTags,dset_ec,traj_lat,current);
sol_ant = sampleFEM(model,vTags,ecTags,dset_ec,traj_ant,current);
sol_sacc = sampleFEM(model,vTags,ecTags,dset_ec,traj_sacc,current);
sol_utr = sampleFEM(model,vTags,ecTags,dset_ec,traj_utr,current);

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
f12 = plotFlow(flow_vest_fixed,flow_post_crista,traj_post_pre(toKeep{1},3));
f12.Position = [200 200 560 420];
badTraj = traj_post_pre(~toKeep{1},3);
for i = 1:sum(~toKeep{1})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Post. Crista Origin')
f22 = plotFlow(flow_vest_fixed,flow_lat_crista,traj_lat_pre(toKeep{2},3));
f22.Position = [200 200 560 420];
badTraj = traj_lat_pre(~toKeep{2},3);
for i = 1:sum(~toKeep{2})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Lat. Crista Origin')
f32 = plotFlow(flow_vest_fixed,flow_ant_crista,traj_ant_pre(toKeep{3},3));
f32.Position = [200 200 560 420];
badTraj = traj_ant_pre(~toKeep{3},3);
for i = 1:sum(~toKeep{3})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Ant. Crista Origin')
f42 = plotFlow(flow_vest_fixed,flow_sacc_crista,traj_sacc_pre(toKeep{4},3));
f42.Position = [200 200 560 420];
badTraj = traj_sacc_pre(~toKeep{4},3);
for i = 1:sum(~toKeep{4})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Sacc. Macula Origin')
f52 = plotFlow(flow_vest_fixed,flow_utr_crista,traj_utr_pre(toKeep{5},3));
f52.Position = [200 200 560 420];
badTraj = traj_utr_pre(~toKeep{5},3);
for i = 1:sum(~toKeep{5})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Utr. Macula Origin')

f62 = plotFlow(flow_fac,flow_facial_inlet,traj_fac_pre(toKeep{6},3));
f62.Position = [200 200 560 420];
badTraj = traj_fac_pre(~toKeep{6},3);
for i = 1:sum(~toKeep{6})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Facial Nerve')
f72 = plotFlow(flow_coch_fixed,flow_coch_outlet,traj_coch_pre(toKeep{7},3));
f72.Position = [200 200 560 420];
badTraj = traj_coch_pre(~toKeep{7},3);
for i = 1:sum(~toKeep{7})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Cochlear Nerve')
f82 = plotFlow(flow_vest,flow_vestinlet,traj_vestinlet_pre(toKeep{8},3));
f82.Position = [200 200 560 420];
badTraj = traj_vestinlet_pre(~toKeep{8},3);
for i = 1:sum(~toKeep{8})
    plot3(badTraj{i}(1,:), badTraj{i}(2,:), badTraj{i}(3,:), '-r.')
end
title(gca,'Axial Vestibular Origin')


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
% flows_crista = {flow_vestinlet,flow_post_crista,flow_lat_crista,flow_ant_crista,flow_sacc_crista,flow_utr_crista};
% trajs_crista = {traj_post(:,3),traj_lat(:,3),traj_ant(:,3),traj_sacc(:,3),traj_utr(:,3)};
% f7 = plotMultiFlow(flow_vest_fixed,flows_crista,trajs_crista,'plotFlow',false);
% title(gca,'Specific Crista Innervations')
% 
% clear flows_crista trajs_crista
%%
% toc
%% Save figures
% figs = {f12, f22, f32, f42, f52, f62, f72, f82};
% for i = 1:length(figs)
%     saveas(figs{i},['R:\Computational Modeling\Model as of 20230104\Test traj figures\p003step',num2str(i)])
% %     saveas(figs{i},['R:\Computational Modeling\Model as of 20220908\nerveTrajTest',num2str(i)],'png')
% end
%%
% for i = 11:15
%     saveas(i,['C:\Users\Evan\OneDrive - Johns Hopkins\VNEL1DRV\_Vesper\Modeling\Modeling Results\Traj step size figures\point1umstep',num2str(i)])
% end   