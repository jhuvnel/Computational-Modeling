%% FEM_data_output.m
% Script for extracting voltage and nerve vector field data from an FEM
% model. The voltage will be used to find an extracellular voltage at each
% node on an axon. The vector fields generated from the curvilinear
% coordinates flow method are used to generate trajectories for axons
% within each nerve. Must have the Matlab-Comsol API running and the solved
% model open, with the modelClient saved in the worskpace variable model.
% Should also have the voltage tags saved as a cell array in case the
% number of electrode pairs is not always the same.
% October 2022, Evan Vesper, VNEL
tic

%% Define Comsol tags
geom_tag = 'geom1';
dset_vest = 'dset3'; % tag for the dataset containing vestibular nerve flow vector field
sel_vest_dom = 'geom1_imp1_Vestibular_Nerve1_dom'; % selection for vestibular nerve domain
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
basisVecTags = {'cc3.e1x','cc3.e1y','cc3.e1z'}; % basis vector 1 (along the axon)
basisVecTagsFac = {'cc2.e1x','cc2.e1y','cc2.e1z'}; % facial nerve
basisVecTagsCoch = {'cc.e1x','cc.e1y','cc.e1z'}; % cochlear nerve
dset_facial = 'dset2';
dset_coch = 'dset1';
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

%% Extract flow information
% get flow vector field values for vestibular nerve
% selection argument pair means fxn will only return vector field data 
% within the selection specified (also the only volume it was actually calculated for)
flow_vest = mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_vest_dom); % lowercase

flow_post_crista = mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_post_crista_bnd);
flow_lat_crista = mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_lat_crista_bnd);
flow_ant_crista = mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_ant_crista_bnd);
flow_sacc_crista = mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_sacc_crista_bnd);
flow_utr_crista = mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_utr_crista_bnd);
flow_vestinlet = mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_vest_inlet_bnd);
% get voltage and electric current density values for all node points
% within vestibular nerve, for all electrode combinations
% ec_vest = mpheval(model,ecTags,'dataset',dset_ec,'selection',sel_vest_dom);

% reverese direction of flow since we want it going from crista towards
% brain
flow_vest_fixed = flow_vest;
flow_vest_fixed.d1 = -1*flow_vest.d1;
flow_vest_fixed.d2 = -1*flow_vest.d2;
flow_vest_fixed.d3 = -1*flow_vest.d3;

%% Generate trajectories for all vestibular divisions
step = [301e-3; 300.5e-3; -1];
numAxons = 50;

[traj_vestinlet_pre, fiberType1, p0_test_inlet] = fiberGenComsol(flow_vest_fixed,flow_vestinlet,numAxons*5,step);

[traj_post_pre, fiberType1, p0_post_crista] = fiberGenComsol(flow_vest_fixed,flow_post_crista,numAxons,step);
[traj_lat_pre, fiberType1, p0_lat_crista] = fiberGenComsol(flow_vest_fixed,flow_lat_crista,numAxons,step);
[traj_ant_pre, fiberType1, p0_ant_crista] = fiberGenComsol(flow_vest_fixed,flow_ant_crista,numAxons,step);
[traj_sacc_pre, fiberType1, p0_sacc_crista] = fiberGenComsol(flow_vest_fixed,flow_sacc_crista,numAxons,step);
[traj_utr_pre, fiberType1, p0_utr_crista] = fiberGenComsol(flow_vest_fixed,flow_utr_crista,numAxons,step);

% remove all the trajectories that aren't long enough (hit the wall of the
% nerve). In the future I need to fix the flow to avoid this happening, or
% change the fiberGenComsol/strream3Comsol function(s) to keep trying new
% starting points until I get the desired number of axons (like a Monte
% Carlo method).
all_trajs = {traj_vestinlet_pre,traj_post_pre,traj_lat_pre,traj_ant_pre,traj_sacc_pre,traj_utr_pre};
for i = 1:length(all_trajs)
    toKeep =[];
    for j = 1:size(all_trajs{i},1)
        if length(all_trajs{i}{j,2}) > 20
            toKeep = [toKeep, j];
        end
    end
    all_trajs{i} = all_trajs{i}(toKeep,:);
    disp([num2str(size(all_trajs{i},1)),' axons succesfully generated in nerve ',num2str(i),'.'])
end
traj_vestinlet = all_trajs{1};
traj_post = all_trajs{2};
traj_lat = all_trajs{3};
traj_ant = all_trajs{4};
traj_sacc = all_trajs{5};
traj_utr = all_trajs{6};

save("trajs_20221103","traj_vestinlet","traj_post","traj_lat","traj_ant","traj_sacc","traj_utr")

%% Testing fiberGenComsol with interpolation to node points
step_vec_test = [301e-3; 300.5e-3; -1]; % units are mm - [301 um; 300.5 um; -1]

[traj_test2, fiberType2, p0_test2] = fiberGenComsol(flow_vest_fixed,flow_ant_crista,50,step_vec_test);

for j = 1:size(traj_test2,1)
    if length(traj_test2{j,2}) > 20
        toKeep = [toKeep, j];
    end
end
traj_test2 = traj_test2(toKeep,:);
disp([num2str(size(traj_test2,1)),' axons succesfully generated.'])
plotFlow(flow_vest_fixed, flow_ant_crista,traj_test2(:,3));
title('Succesful test\_traj2 axons')

%% Extract Ve at node points
% testing mphinterp alone
[var1, curr1] = mphinterp(model,{'V2_7','ec.Jx'},'coord', traj_test2{1,3}, 'dataset', dset_ec);

%% Testing sampleFEM
tic
[solutionBigCell] = sampleFEM(model,vTags,ecTags,dset_ec,traj_test2);
toc
% normalize by total current delivered
for i = 1:length(solutionBigCell)
    for j = 1:size(solutionBigCell{i},1)
        solutionBigCell{i}{j,3} = solutionBigCell{i}{j,3}/current;
    end
end

%% Create parameter cell
% NOTE: the java Axon models expect everything in meters, not mm so make
% sure to convert internode distances, diameters, etc...
numActualAxons = size(solutionBigCell{1},1);
Vthresh = 0.085; % aactivation threshold relative to resting membrane potential, V

parameterTest = cell(9,1);
parameterTest{1} = [numActualAxons; 1; numActualAxons];
parameterTest{2} = 1e-7; % timestep, s
parameterTest{3} = [2e-6; 1e-6;-1]; % active node (nodes of Ranvier) lengths, m
parameterTest{4} = [300e-6; -1]; % passive node (internode) lengths, m
parameterTest{5} = ones(numActualAxons,1)*[1.4e-6, -1]; % fiber diameters at each node, m
parameterTest{6} = rand(numActualAxons,1); % initial state array
parameterTest{7} = Vthresh; % activation threshold voltage
parameterTest{8} = [100; 300]; % limit on fine threshold
parameterTest{9} = 0.01; % precision for finding thresholds, i.e. 0.01 = 1%


%% Save parameter cell, trajectory cell, solution cell, waveform, and total current for simulation...
save("testSolution20221104",'parameterTest','traj_test2','solutionBigCell','waveForm','current')

%% Generate streamlines/axon trajectories straight from stream3Comsol
% step_test = 0.1;
% traj_vestinlet = stream3Comsol(flow_vest.p,flow_vest.t,flow_vest.d1,flow_vest.d2,flow_vest.d3,p0_test_inlet,step_test); % with lowercase basis vector
% % traj2 = stream3Comsol(flow_vest2.p,flow_vest2.t,flow_vest2.d1,flow_vest2.d2,flow_vest2.d3,p0_test,step_test); % with uppercase basis vector
% d1fixed = -1*flow_vest.d1;
% d2fixed = -1*flow_vest.d2;
% d3fixed = -1*flow_vest.d3;
% traj_post = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_post_crista,step_test);
% traj_lat = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_lat_crista,step_test);
% traj_ant = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_ant_crista,step_test);
% traj_sacc = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_sacc_crista,step_test);
% traj_utr = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_utr_crista,step_test);
%% Testing step vector stream3 function
% step_vec_test = [301e-3; 300.5e-3; -1]; % units are mm
% traj_post_test = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_post_crista,step_vec_test);
% figure
% plotFlow(flow_vest,flow_post_crista,traj_post_test,'plotFlow',false)

%% interparc testing
% this is a function I found online that should let me interpolate a curve
% and then choose points along it (based on arclength). This would be for
% having a very small step size to generate the intial streamline for each
% axon and then sample along the streamline to choose nodes. Might result
% in a less zig-zaggy axon.

% interparcTest = interparc(0:0.3:1,traj_lat_crista{1}(1,:),traj_lat_crista{1}(2,:),traj_lat_crista{1}(3,:));
% figure
% plot3(interparcTest(:,1),interparcTest(:,2),interparcTest(:,3),'o-')
%% Plot everything
% plot vestibular inlet results
f1 = plotFlow(flow_vest,flow_vestinlet,traj_vestinlet(:,3));
title(gca,'Vest. Inlet Origin')

% plot crista origin results
f2 = plotFlow(flow_vest_fixed,flow_post_crista,traj_post(:,3));
title(gca,'Post. Crista Origin')
f3 = plotFlow(flow_vest_fixed,flow_lat_crista,traj_lat(:,3));
title(gca,'Lat. Crista Origin')
f4 = plotFlow(flow_vest_fixed,flow_ant_crista,traj_ant(:,3));
title(gca,'Ant. Crista Origin')
f5 = plotFlow(flow_vest_fixed,flow_sacc_crista,traj_sacc(:,3));
title(gca,'Sacc. Crista Origin')
f6 = plotFlow(flow_vest_fixed,flow_utr_crista,traj_utr(:,3));
title(gca,'Utr. Crista Origin')
% plot all the crista trajectories together
flows_crista = {flow_vestinlet,flow_post_crista,flow_lat_crista,flow_ant_crista,flow_sacc_crista,flow_utr_crista};
trajs_crista = {traj_post(:,3),traj_lat(:,3),traj_ant(:,3),traj_sacc(:,3),traj_utr(:,3)};
f7 = plotMultiFlow(flow_vest_fixed,flows_crista,trajs_crista,'plotFlow',false);
title(gca,'Specific Crista Innervations')

%%
toc

%%
% plot with mesh of vestibular nerve
% f9 = plotFlow(flow_vest,flow_vestinlet,traj_vestinlet,'plotNerveMesh',true);
% title(gca,'Vest. Inlet Origin')

%% Save figures
% figs = {f1, f3, f4, f5, f6, f7, f8};
% for i = 1:7
%     saveas(figs{i},['R:\Computational Modeling\Model as of 20220908\nerveTrajTest',num2str(i)])
%     saveas(figs{i},['R:\Computational Modeling\Model as of 20220908\nerveTrajTest',num2str(i)],'png')
% end

%% 
% f = plotFlow(flow_vest,flow_post_crista,'p0',p0_test_post_crista,'plotFlow',false)