%% FEM_data_output.m
% Script for extracting voltage and nerve vector field data from an FEM
% model. The voltage will be used to find an extracellular voltage at each
% node on an axon. The vector fields generated from the curvilinear
% coordinates flow method are used to generate trajectories for axons
% within each nerve.
% First created 10/12/2022, Evan Vesper, VNEL

dset_vest = 'dset3'; % tag for the dataset containing vestibular nerve flow vector field
sel_vest_dom = 'geom1_imp1_Vestibular_Nerve1_dom'; % selection for vestibular nerve domain
sel_vest_outlet_bnd = 'geom1_sel6'; % boundary selection for vestibular nerve outlet (cristas for 3 canals and otolith organs)
sel_post_crista_bnd = 'geom1_sel7';
% need to create selection for each crista!

% get flow vector field values for vestibular nerve
% selection argument pair means fxn will only return vector field data 
% within the selection specified (also the only volume it was actually calculated for)
flow_vest = mpheval(model,{'cc3.vX','cc3.vY','cc3.vY'},'dataset',dset_vest,'selection',sel_vest_dom); 
% should double check what units these vectors are in compared to global
% axes

%% Plot vector field for visualization/testing
figure
quiver3(flow_vest.p(1,:),flow_vest.p(2,:),flow_vest.p(3,:),...
    flow_vest.d1,flow_vest.d2,flow_vest.d3)

%% Canal crista selections - move this to the FEM_create script...
% Posterior?
model.component('comp1').geom('geom1').create('sel7', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel7').label('Posterior Canal Crista');
model.component('comp1').geom('geom1').feature('sel7').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel7').selection('selection').set('fin', [25046-25053, 25123-25126, 25216-25218, 25281, 25338-25340, 25360, 25457-25460, 25467-25469, 25485, 25644, 25645, 25663, 25693-25695, 25781, 25796, 25856-25859, 25887-25889, 25903, 25904, 26168, 26212, 26270, 26271, 26434, 26446, 26447, 26505, 26541, 26550, 26694]);
model.component('comp1').geom('geom1').run('sel7');
% Lateral?
model.component('comp1').geom('geom1').create('sel8', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel8').label('Lateral Canal Crista');
model.component('comp1').geom('geom1').feature('sel8').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel8').selection('selection').set('fin', [28052, 28054, 28078, 28212-28215, 28277-28279, 28328, 28380, 28435, 28436, 28461, 28462, 28494, 28495, 28512-28514, 28579, 28580, 28619, 28620, 29018, 29259-29261, 29370, 29374, 29399-29401, 29547-29549, 29633, 29921, 30142, 30143, 30271]);
model.component('comp1').geom('geom1').run('sel8');
% Anterior?
model.component('comp1').geom('geom1').create('sel9', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel9').label('Anterior Canal Crista');
model.component('comp1').geom('geom1').feature('sel9').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel9').selection('selection').set('fin', [30760, 30761, 30804, 30805, 30936, 31007, 31008, 31013, 31014, 31078, 31079, 31193, 31195, 31196, 31370, 31371, 31514, 31516, 31781, 31782, 31816, 31849, 31850, 32061-32064, 32130, 54883]);
model.component('comp1').geom('geom1').run('sel9');
% Saccule
model.component('comp1').geom('geom1').create('sel10', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel10').label('Saccule Crista');
model.component('comp1').geom('geom1').feature('sel10').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel10').selection('selection').set('fin', [30817-30821, 30981-30983, 31028-31032, 31038-31041, 31046-31049, 31064-31066, 31133, 31201, 31202, 31224-31226, 31248-31250, 31316, 31317, 31366, 31367, 31386, 31387, 31464, 31465, 31482-31486, 31497, 31498, 31504-31511, 31531-31533, 31555, 31564, 31565, 31570-31572, 31636-31638, 31662-31664, 31668, 31669, 31673, 31674, 31717, 31718, 31731, 31732, 31741, 31784-31787, 31793, 31794, 31805-31808, 31821, 31822, 31853, 31906, 31907, 31948, 31949, 31952, 31987-31992, 31996-31998, 32004-32008, 32019, 32020, 32024, 32025, 32031-32033, 32040, 32041, 32082-32084, 32111, 32142, 32171, 32176-32178, 32188-32191, 32199-32205, 32213-32216, 32224, 32226, 32259-32261, 32263-32266, 32325-32327, 32347, 32370-32372, 32385, 32386, 32393-32395, 32424, 32425, 32445, 32449, 32453, 32454, 32487-32489, 32495, 32496, 32504, 32505, 32559-32561, 32578, 32579, 32591, 32636-32639, 32675, 32677-32681, 32683, 32690, 32695, 32696, 32709-32712, 32717-32719, 32765, 32766, 32819, 32820, 32841, 32842, 32845, 32846, 32857-32859, 32874-32879, 32902, 32948, 32949, 32956-32958, 32967, 33000-33002, 33009-33011, 33048, 33049, 33059-33061, 33102, 33103, 33134, 33135, 33142-33144, 33192, 33193, 33212, 33213, 33221, 33223-33226, 33235, 33252-33255, 33259, 33260, 33267, 33268, 33276, 33277, 33282, 33283, 33294-33298, 33313, 33314, 33340, 33341, 33357, 33390-33392, 33406, 33407, 33442, 33443, 33466, 33482, 33483, 33505, 33506, 33547, 33557, 33558, 33561-33563, 33582, 33583, 33615, 33616, 33622-33624, 33635-33637, 33646, 33690-33696, 33740, 33741, 33794, 33817-33819, 33848-33850, 33862, 33863, 33887-33891, 33954, 33955, 33960, 33962, 33963, 33972, 33973, 33975, 34003-34005, 34010, 34011, 34033, 34034, 34070-34072, 34086]);
model.component('comp1').geom('geom1').run('sel10');
% Utricle
model.component('comp1').geom('geom1').create('sel11', 'ExplicitSelection');
model.component('comp1').geom('geom1').feature('sel11').label('Utricle Crista');
model.component('comp1').geom('geom1').feature('sel11').selection('selection').init(2);
model.component('comp1').geom('geom1').feature('sel11').selection('selection').set('fin', [26720-26723, 26815-26817, 26981-26983, 27084, 27085, 27188, 27189, 27251-27253, 27268-27271, 27312, 27313, 27323, 27331, 27332, 27337, 27437-27439, 27582, 27583, 27663-27665, 27707, 27708, 27724, 27770-27772, 27930, 27931, 27955-27959, 27990, 27991, 27993, 27994, 28106-28108, 28162, 28177, 28203-28205, 28318, 28319, 28432, 28433, 28506-28509, 28586, 28587, 28621-28623, 28644, 28645, 28682, 28683, 28737, 28738, 28795, 28796, 28802, 28803, 28960, 29081, 29082, 29102-29104, 29151-29153, 29171, 29181-29184, 29209-29212, 29222-29224, 29253-29255, 29292-29294, 29319-29323, 29336, 29337, 29375-29377, 29421, 29422, 29435-29438, 29459, 29460, 29531, 29563-29566, 29595, 29596, 29604-29606, 29635, 29638-29640, 29665, 29666, 29748-29750, 29789-29791, 29801, 29802, 29821, 29822, 29862, 29863, 29874, 29875, 29899, 29912, 29913, 29925, 29973, 29974, 30049-30051, 30077, 30177, 30178, 30201, 30215-30217, 30332, 30428-30431, 30442, 30443, 30500-30502, 30515, 30516, 30560, 30561, 30567-30569, 30571, 30572, 30619, 30665, 30724-30726, 30752, 30753, 30808, 30809, 30899, 30900, 30903, 30904, 30956, 30969, 31035-31037, 31084-31088, 31093-31095, 31107, 31117-31119, 31125-31127, 31158, 31159, 31166, 31240, 31241, 31247, 31299, 31300, 31303-31305, 31448-31450, 31454-31456, 31476, 31477, 31522, 31561, 31598-31600, 31609, 31610, 31665-31667, 31705, 31746, 31747, 31801, 31802, 31823, 31824, 31843, 31844, 31859, 31860, 31878, 31920, 32047, 32048, 32183, 32184, 32210-32212, 32227-32229, 32238, 32239, 32284, 32285, 32319-32322, 32338-32340, 32423, 32431, 32478, 32479, 32596-32599, 32630, 32691-32693, 32698, 32699, 32755-32757, 32784, 32785, 32790, 32791, 32799, 32847, 32848, 32873, 32883, 32884, 32983-32986, 33018-33023, 33031, 33032, 33073, 33074, 33117, 33118, 33162, 33164, 33168, 33169, 33181, 33182, 33209-33211, 33227, 33228, 33232, 33236, 33237, 33239, 33242, 33320, 33345, 33346, 33393-33395, 33432, 33433, 33473, 33474, 33494, 33511, 33513-33515, 33580, 33596-33598, 33617, 33642, 33643, 33700-33702, 33731, 33748-33750, 33754, 33787-33790, 33823, 33824, 33878-33881, 34036-34038, 34050, 34051, 34138, 34139, 34210, 34211, 34254, 34255, 34276, 34277, 34385, 34387-34389, 34439, 34440, 34495, 34504, 34505, 34547-34549, 34568, 34569, 34583]);
model.component('comp1').geom('geom1').run('sel11');

%%
% c = mphgetcoords(model,<geomtag>,entitytype,<idx>)
% verts = stream3(X,Y,Z,U,V,W,startX,startY,startZ,step);
% generate streamline vertices (axon's nodes)

post_crista_points = mphgetcoords(model,sel_post_crista_bnd,"boundary",model.component('comp1').geom('geom1').feature('sel7').entities(2));

verts = stream3(flow_vest.p(1,:),flow_vest.p(2,:),flow_vest.p(3,:),...
    flow_vest.d1,flow_vest.d2,flow_vest.d3,startX,startY,startZ,step);

hold on
streamline(verts); % plot streamline

% u = mphgetu(model,'soltag','sol3');
% solinfo = mphsolinfo(model,"soltag","sol3");