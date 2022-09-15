 % FEM__analysis_20220908.m
%
% Model exported on Jun 28 2022, 11:03 by COMSOL 6.0.0.318.

import com.comsol.model.*
import com.comsol.model.util.*



[model, model_path] = FEM_create_20220908;

%% Electric Currents Physics

% electrodes1_2 - CC electrode, electrodes1_1 - Posterior 1, electrodes1_3
% - Anterior 1, electrodes1_4 - Anterior 2, electrodes1_5 - Horizontal 1,
% electrodes1_6 - Posterior 2, electrodes1_7 - Horizontal 2
% ModelUtil.showProgress(true); %activates progress bar
RefElectrodes = [{'electrodes1_2'}];
RefElectrodeNames = [{'CC'}];
StimElectrodes = [{'electrodes1_1'}, {'electrodes1_3'}, {'electrodes1_4'}, {'electrodes1_5'}, {'electrodes1_6'}, {'electrodes1_7'}];
StimElectrodeNames = [{'Posterior1'}, {'Anterior1'}, {'Anterior2'},{'Horizontal1'},{'Posterior2'},{'Horizontal2'}];
nRef = length(RefElectrodes);
nStim = length(StimElectrodes);

ECs = cell(length(RefElectrodes),length(StimElectrodes));

for i = 1:nRef
    for j = 1:nStim
        % create ec physics for each electrode combination. Naming is
        % 'ec#_#' where first # is ref electrode, 2nd # is stim electrode
        ECs{i,j} = model.component('comp1').physics.create(['ec',RefElectrodes{i}(end),'_',StimElectrodes{j}(end)], 'ConductiveMedia', 'geom1');
        ECs{i,j}.field('electricpotential').field(['V',RefElectrodes{i}(end),'_',StimElectrodes{j}(end)]); % name output variable
        ECs{i,j}.label(['Electric Currents ',StimElectrodeNames{j},' ',RefElectrodeNames{i},' ref']);
        % Set stimulating electrode as voltage source
        ECs{i,j}.create('pot1', 'ElectricPotential', 2);
        ECs{i,j}.feature('pot1').selection.named(['geom1_imp1_',StimElectrodes{j},'_bnd']);
        ECs{i,j}.feature('pot1').set('V0', 1);
        % Set reference electrode as ground
        ECs{i,j}.create('gnd1', 'Ground', 2);
        ECs{i,j}.feature('gnd1').selection.named(['geom1_imp1_',RefElectrodes{i},'_bnd']);   
    end
end

% not sure if it matters if the mesh is run before or after the physics
% nodes are created - to be safe, run it after
model.component('comp1').mesh('mesh1').run;

% to remove a physics component
% model.component('comp1').physics.remove(tag)
%% Studies
model.study.create('std1');
model.study('std1').create('stat', 'Stationary');
model.study('std1').label('Study 1 - Facial CC');
model.study('std1').feature('stat').setEntry('activate', 'cc2', false);
model.study('std1').feature('stat').setEntry('activate', 'cc3', false);


model.study.create('std2');
model.study('std2').create('stat', 'Stationary');
model.study('std2').label('Study 2 - Cochlear CC');
model.study('std2').feature('stat').setEntry('activate', 'cc', false);
model.study('std2').feature('stat').setEntry('activate', 'cc3', false);


model.study.create('std3');
model.study('std3').create('stat', 'Stationary');
model.study('std3').label('Study 3 - Vestibular CC');
model.study('std3').feature('stat').setEntry('activate', 'cc', false);
model.study('std3').feature('stat').setEntry('activate', 'cc2', false);

stdEC = model.study.create('std4');
model.study('std4').create('stat', 'Stationary');
model.study('std4').label('Study 4 - Electric Currents');
model.study('std4').feature('stat').setEntry('activate', 'cc', false);
model.study('std4').feature('stat').setEntry('activate', 'cc2', false);
model.study('std4').feature('stat').setEntry('activate', 'cc3', false);

% Set CC studies not to solve for EC
for i = 1:nRef
    for j = 1:nStim
        model.study('std1').feature('stat').setEntry('activate', ECs{i,j}.tag, false);
        model.study('std2').feature('stat').setEntry('activate', ECs{i,j}.tag, false);
        model.study('std3').feature('stat').setEntry('activate', ECs{i,j}.tag, false);
    end
end

% run the studies. Since no solution nodes were created, it just uses the
% default solver and computes results for each study
model.study('std1').run;
model.study('std2').run;
model.study('std3').run;
stdEC.run;

%% Solutions and Plot Groups

model.result.create('pg1', 'PlotGroup3D');
model.result('pg1').label('Vector Field (cc)');
model.result('pg1').set('titlecolor', 'black');
model.result('pg1').set('edgecolor', 'black');
model.result('pg1').set('legendcolor', 'black');
model.result('pg1').set('data', 'dset1');
model.result('pg1').feature.create('str1', 'Streamline');
model.result('pg1').feature('str1').set('posmethod', 'uniform');
model.result('pg1').feature('str1').set('udist', 0.03);
model.result('pg1').feature('str1').set('linetype', 'line');
model.result('pg1').feature('str1').set('smooth', 'internal');
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('maxlen', Inf);
model.result('pg1').feature('str1').set('maxtime', Inf);
model.result('pg1').feature('str1').set('data', 'parent');

model.result.create('pg2', 'PlotGroup3D');
model.result('pg2').set('data', 'dset1');
model.result('pg2').label('Coordinate system (cc)');
model.result('pg2').create('sys1', 'CoordSysVolume');
model.result('pg2').feature('sys1').set('sys', 'cc_cs');

model.result.create('pg3', 'PlotGroup3D');
model.result('pg3').label('Vector Field (cc2)');
model.result('pg3').set('titlecolor', 'black');
model.result('pg3').set('edgecolor', 'black');
model.result('pg3').set('legendcolor', 'black');
model.result('pg3').set('data', 'dset2');
model.result('pg3').feature.create('str1', 'Streamline');
model.result('pg3').feature('str1').set('expr', {'cc2.vX' 'cc2.vY' 'cc2.vZ'});
model.result('pg3').feature('str1').set('posmethod', 'uniform');
model.result('pg3').feature('str1').set('udist', 0.03);
model.result('pg3').feature('str1').set('linetype', 'line');
model.result('pg3').feature('str1').set('smooth', 'internal');
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('maxlen', Inf);
model.result('pg3').feature('str1').set('maxtime', Inf);
model.result('pg3').feature('str1').set('data', 'parent');
model.result.create('pg4', 'PlotGroup3D');
model.result('pg4').set('data', 'dset2');
model.result('pg4').label('Coordinate system (cc2)');
model.result('pg4').create('sys1', 'CoordSysVolume');
model.result('pg4').feature('sys1').set('sys', 'cc2_cs');

model.result.create('pg5', 'PlotGroup3D');
model.result('pg5').label('Vector Field (cc3)');
model.result('pg5').set('titlecolor', 'black');
model.result('pg5').set('edgecolor', 'black');
model.result('pg5').set('legendcolor', 'black');
model.result('pg5').set('data', 'dset3');
model.result('pg5').feature.create('str1', 'Streamline');
model.result('pg5').feature('str1').set('expr', {'cc3.vX' 'cc3.vY' 'cc3.vZ'});
model.result('pg5').feature('str1').set('posmethod', 'uniform');
model.result('pg5').feature('str1').set('udist', 0.03);
model.result('pg5').feature('str1').set('linetype', 'line');
model.result('pg5').feature('str1').set('smooth', 'internal');
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('maxlen', Inf);
model.result('pg5').feature('str1').set('maxtime', Inf);
model.result('pg5').feature('str1').set('data', 'parent');
model.result.create('pg6', 'PlotGroup3D');
model.result('pg6').set('data', 'dset3');
model.result('pg6').label('Coordinate system (cc3)');
model.result('pg6').create('sys1', 'CoordSysVolume');
model.result('pg6').feature('sys1').set('sys', 'cc3_cs');

%% Create Results Plots
% creates a plotgroup for each EC study where just the electric potential
% is shown
for i = 1:nRef
    for j = 1:nStim
        pg{i,j} = model.result.create(['pg',RefElectrodes{i}(end),'_',StimElectrodes{j}(end)], 'PlotGroup3D');
        pg{i,j}.label(['Electrical Potential ',RefElectrodes{i}(end),'_',StimElectrodes{j}(end)]);
        pg{i,j}.set('data','dset4');
        % specify which domains to display
        pg{i,j}.selection.geom('geom1',3);
        pg{i,j}.selection.set([5 7 9 10 11 12 13 14 15 16 17 18]);

        surf{i,j} = pg{i,j}.feature.create(['surf',RefElectrodes{i}(end),'_',StimElectrodes{j}(end)], 'Surface');
        surf{i,j}.set('expr',['V',RefElectrodes{i}(end),'_',StimElectrodes{j}(end)]);

    end
end

%% Electric Field norm plot
% model.result.create('pg8', 'PlotGroup3D');
% model.result('pg8').label('Electric Field Norm (ec)');
% model.result('pg8').set('frametype', 'spatial');
% model.result('pg8').set('showlegendsmaxmin', true);
% model.result('pg8').set('data', 'dset4');
% model.result('pg8').feature.create('mslc1', 'Multislice');
% model.result('pg8').feature('mslc1').set('showsolutionparams', 'on');
% model.result('pg8').feature('mslc1').set('solutionparams', 'parent');
% model.result('pg8').feature('mslc1').set('expr', 'ec.normE');
% model.result('pg8').feature('mslc1').set('multiplanexmethod', 'coord');
% model.result('pg8').feature('mslc1').set('xcoord', 'ec.CPx');
% model.result('pg8').feature('mslc1').set('multiplaneymethod', 'coord');
% model.result('pg8').feature('mslc1').set('ycoord', 'ec.CPy');
% model.result('pg8').feature('mslc1').set('multiplanezmethod', 'coord');
% model.result('pg8').feature('mslc1').set('zcoord', 'ec.CPz');
% model.result('pg8').feature('mslc1').set('colortable', 'Prism');
% model.result('pg8').feature('mslc1').set('colortabletrans', 'nonlinear');
% model.result('pg8').feature('mslc1').set('colorcalibration', -0.8);
% model.result('pg8').feature('mslc1').set('showsolutionparams', 'on');
% model.result('pg8').feature('mslc1').set('data', 'parent');
% model.result('pg8').feature.create('strmsl1', 'StreamlineMultislice');
% model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
% model.result('pg8').feature('strmsl1').set('solutionparams', 'parent');
% model.result('pg8').feature('strmsl1').set('expr', {'ec.Ex' 'ec.Ey' 'ec.Ez'});
% model.result('pg8').feature('strmsl1').set('multiplanexmethod', 'coord');
% model.result('pg8').feature('strmsl1').set('xcoord', 'ec.CPx');
% model.result('pg8').feature('strmsl1').set('multiplaneymethod', 'coord');
% model.result('pg8').feature('strmsl1').set('ycoord', 'ec.CPy');
% model.result('pg8').feature('strmsl1').set('multiplanezmethod', 'coord');
% model.result('pg8').feature('strmsl1').set('zcoord', 'ec.CPz');
% model.result('pg8').feature('strmsl1').set('titletype', 'none');
% model.result('pg8').feature('strmsl1').set('posmethod', 'uniform');
% model.result('pg8').feature('strmsl1').set('udist', 0.02);
% model.result('pg8').feature('strmsl1').set('maxlen', 0.4);
% model.result('pg8').feature('strmsl1').set('maxtime', Inf);
% model.result('pg8').feature('strmsl1').set('inheritcolor', false);
% model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
% model.result('pg8').feature('strmsl1').set('maxtime', Inf);
% model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
% model.result('pg8').feature('strmsl1').set('maxtime', Inf);
% model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
% model.result('pg8').feature('strmsl1').set('maxtime', Inf);
% model.result('pg8').feature('strmsl1').set('showsolutionparams', 'on');
% model.result('pg8').feature('strmsl1').set('maxtime', Inf);
% model.result('pg8').feature('strmsl1').set('data', 'parent');
% model.result('pg8').feature('strmsl1').set('inheritplot', 'mslc1');
% model.result('pg8').feature('strmsl1').feature.create('col1', 'Color');
% model.result('pg8').feature('strmsl1').feature('col1').set('expr', 'ec.normE');
% model.result('pg8').feature('strmsl1').feature('col1').set('colortable', 'PrismDark');
% model.result('pg8').feature('strmsl1').feature('col1').set('colorlegend', false);
% model.result('pg8').feature('strmsl1').feature('col1').set('colortabletrans', 'nonlinear');
% model.result('pg8').feature('strmsl1').feature('col1').set('colorcalibration', -0.8);
% model.result('pg8').feature('strmsl1').feature.create('filt1', 'Filter');
% model.result('pg8').feature('strmsl1').feature('filt1').set('expr', '!isScalingSystemDomain');
%% Create Matlab figures of CC streamline plots


model.result('pg1').run;
model.result('pg2').run;

% plot CC vector fields
f = figure;
mphplot(model,'pg1');
f.Position = [1,41,1920,963];
f.Children.View = [-16.8946   58.8382];
drawnow
pause(.1)

model.result('pg3').run;
model.result('pg4').run;
f = figure;
mphplot(model,'pg3');
f.Position = [1,41,1920,963];
f.Children.View = [62.7874   21.2297];
drawnow
pause(.1)

model.result('pg5').run;
model.result('pg6').run;
f = figure;
mphplot(model,'pg5');
f.Position = [1,41,1920,963];
f.Children.View = [-123.3212  -25.8513];
drawnow
pause(.1)

% plot voltage maps
%View-Posterior- -1.796443704652980e+02,-78.917368147238932
%CameraPosition -2.263851178121255,22.01258091423081,-109.4993852491663
%0.138486451767768,83.580861013292292
%-2.099179622124298,-12.203111052044948,112.7812814407596
% solEC.runAll;
%% Create Matlab figures of EC Plots

for i = 1:nRef
    for j = 1:nStim
        pg{i,j}.run;
        f = figure; % plot in a matlab figure
        mphplot(model,pg{i,j}.tag,'rangenum',1)

        f.Position = [1,41,1920,963];
        ax = f.Children;
%         if contains(StimElectrodeNames(j),{'Post'})
%             ax.View = [-1.796443704652980e+02 -78.917368147238932];
%         else
%             ax.View = [0.138486451767768 83.580861013292292];
%         end
        title(ax(2),['Electrical Potential for ',StimElectrodeNames{j},' Stimulating, ',RefElectrodeNames{i},' Reference']);
        drawnow
        pause(.1)
    end
end

%% Save
mphsave(model,[model_path,'\FEM_20220908_solved'])