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

%% Set tags and extract data from Comsol
tic
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
velTags = {'cc3.vX','cc3.vY','cc3.vY'}; % velocity field, but this doesn't generate proper trajectories
vTags = {'cc3.e1x','cc3.e1y','cc3.e1z'}; % basis vector 1 (along the axon)
vTagsFac = {'cc2.e1x','cc2.e1y','cc2.e1z'}; % facial nerve
vTagsCoch = {'cc.e1x','cc.e1y','cc.e1z'}; % cochlear nerve
dset_facial = 'dset2';
dset_coch = 'dset1';
% tags for electric currents
ectags = {'V2_1','V2_3','V2_4','V2_5','V2_6','V2_7',...
    'ec.Jx','ec.Jy','ec.Jz',...
    'ec2.Jx','ec2.Jy','ec2.Jz',...
    'ec3.Jx','ec3.Jy','ec3.Jz',...
    'ec4.Jx','ec4.Jy','ec4.Jz',...
    'ec5.Jx','ec5.Jy','ec5.Jz',...
    'ec6.Jx','ec6.Jy','ec6.Jz'};
dset_ec = 'dset4'; % dataset for electric currents


% get flow vector field values for vestibular nerve
% selection argument pair means fxn will only return vector field data 
% within the selection specified (also the only volume it was actually calculated for)
flow_vest = mpheval(model,vTags,'dataset',dset_vest,'selection',sel_vest_dom); % lowercase

flow_post_crista = mpheval(model,vTags,'dataset',dset_vest,'selection',sel_post_crista_bnd);
flow_lat_crista = mpheval(model,vTags,'dataset',dset_vest,'selection',sel_lat_crista_bnd);
flow_ant_crista = mpheval(model,vTags,'dataset',dset_vest,'selection',sel_ant_crista_bnd);
flow_sacc_crista = mpheval(model,vTags,'dataset',dset_vest,'selection',sel_sacc_crista_bnd);
flow_utr_crista = mpheval(model,vTags,'dataset',dset_vest,'selection',sel_utr_crista_bnd);
flow_vestinlet = mpheval(model,vTags,'dataset',dset_vest,'selection',sel_vest_inlet_bnd);
% get voltage and electric current density values for all node points
% within vestibular nerve, for all electrode combinations
ec_vest = mpheval(model,ectags,'dataset',dset_ec,'selection',sel_vest_dom);

%% Generate starting points on crista
[verts1, fiberType1, p0_test_inlet] = fiberGenComsol(flow_vest,flow_vestinlet,50);

[verts1, fiberType1, p0_test_post_crista] = fiberGenComsol(flow_vest,flow_post_crista,50);
[verts1, fiberType1, p0_test_lat_crista] = fiberGenComsol(flow_vest,flow_lat_crista,50);
[verts1, fiberType1, p0_test_ant_crista] = fiberGenComsol(flow_vest,flow_ant_crista,50);
[verts1, fiberType1, p0_test_sacc_crista] = fiberGenComsol(flow_vest,flow_sacc_crista,50);
[verts1, fiberType1, p0_test_utr_crista] = fiberGenComsol(flow_vest,flow_utr_crista,50);

%% Generate streamlines/axon trajectories
step_test = 0.1;
traj_vestinlet = stream3Comsol(flow_vest.p,flow_vest.t,flow_vest.d1,flow_vest.d2,flow_vest.d3,p0_test_inlet,step_test); % with lowercase basis vector
% traj2 = stream3Comsol(flow_vest2.p,flow_vest2.t,flow_vest2.d1,flow_vest2.d2,flow_vest2.d3,p0_test,step_test); % with uppercase basis vector
d1fixed = -1*flow_vest.d1;
d2fixed = -1*flow_vest.d2;
d3fixed = -1*flow_vest.d3;
traj_post_crista = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_test_post_crista,step_test);
traj_lat_crista = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_test_lat_crista,step_test);
traj_ant_crista = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_test_ant_crista,step_test);
traj_sacc_crista = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_test_sacc_crista,step_test);
traj_utr_crista = stream3Comsol(flow_vest.p,flow_vest.t,d1fixed,d2fixed,d3fixed,p0_test_utr_crista,step_test);
%% Plot everything
% lowercase basis vector results
f1 = plotFlow(flow_vest,flow_vestinlet,traj_vestinlet);
title(gca,'Vest. Inlet Origin')
% uppercase basis vector results
% f2 = plotFlow(flow_vest2,flow_crista,traj2);
% title(gca,'Vest. Inlet Origin with uppercase basis vector')

% plot crista origin results
f3 = plotFlow(flow_vest,flow_post_crista,traj_post_crista);
title(gca,'Post. Crista Origin')
f4 = plotFlow(flow_vest,flow_lat_crista,traj_lat_crista);
title(gca,'Lat. Crista Origin')
f5 = plotFlow(flow_vest,flow_ant_crista,traj_ant_crista);
title(gca,'Ant. Crista Origin')
f6 = plotFlow(flow_vest,flow_sacc_crista,traj_sacc_crista);
title(gca,'Sacc. Crista Origin')
f7 = plotFlow(flow_vest,flow_utr_crista,traj_utr_crista);
title(gca,'Utr. Crista Origin')
%% Plot all the crista trajectories together
flows_crista = {flow_vestinlet,flow_post_crista,flow_lat_crista,flow_ant_crista,flow_sacc_crista,flow_utr_crista};
trajs_crista = {traj_post_crista,traj_lat_crista,traj_ant_crista,traj_sacc_crista,traj_utr_crista};
f8 = plotMultiFlow(flow_vest,flows_crista,trajs_crista,'plotFlow',false);
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