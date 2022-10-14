%% FEM_data_output.m
% Script for extracting voltage and nerve vector field data from an FEM
% model. The voltage will be used to find an extracellular voltage at each
% node on an axon. The vector fields generated from the curvilinear
% coordinates flow method are used to generate trajectories for axons
% within each nerve.
% First created 10/12/2022, Evan Vesper, VNEL

geom_tag = 'geom1';
dset_vest = 'dset3'; % tag for the dataset containing vestibular nerve flow vector field
sel_vest_dom = 'geom1_imp1_Vestibular_Nerve1_dom'; % selection for vestibular nerve domain
sel_vest_outlet_bnd = 'geom1_sel6'; % boundary selection for vestibular nerve outlet (cristas for 3 canals and otolith organs)
% boundary selections for individual crista
sel_post_crista_bnd = 'geom1_sel7'; % posterior canal crista
sel_lat_crista_bnd = 'geom1_sel8'; % lateral canal crista
sel_ant_crista_bnd = 'geom1_sel9'; % anterior canal crista
sel_sacc_crista_bnd = 'geom1_sel10'; % saccule crista
sel_utr_crista_bnd = 'geom1_sel11'; % utricle crista

% get flow vector field values for vestibular nerve
% selection argument pair means fxn will only return vector field data 
% within the selection specified (also the only volume it was actually calculated for)
flow_vest = mpheval(model,{'cc3.vX','cc3.vY','cc3.vY'},'dataset',dset_vest,'selection',sel_vest_dom); 
flow_crista = mpheval(model,{'cc3.vX','cc3.vY','cc3.vY'},'dataset',dset_vest,'selection',sel_post_crista_bnd);
% should double check what units these vectors are in compared to global
% axes

% have coordinates on crista and simplex mesh from mpheval - just need to
% figure out how to generate points on this simplex mesh that aren't just
% the vertices already provided

%% Plot vector field for visualization/testing
figure
quiver3(flow_vest.p(1,:),flow_vest.p(2,:),flow_vest.p(3,:),...
    flow_vest.d1,flow_vest.d2,flow_vest.d3)

figure
plot3(flow_crista.p(1,:),flow_crista.p(2,:),flow_crista.p(3,:),'.')

%%
% c = mphgetcoords(model,<geomtag>,entitytype,<idx>)
% verts = stream3(X,Y,Z,U,V,W,startX,startY,startZ,step);
% generate streamline vertices (axon's nodes)

post_crista_points = mphgetcoords(model,geom_tag,"boundary",2); % this is hopelessly not working

%%
verts = stream3(flow_vest.p(1,:),flow_vest.p(2,:),flow_vest.p(3,:),...
    flow_vest.d1,flow_vest.d2,flow_vest.d3,startX,startY,startZ,step);

hold on
streamline(verts); % plot streamline

% u = mphgetu(model,'soltag','sol3');
% solinfo = mphsolinfo(model,"soltag","sol3");