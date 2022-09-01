path('R:\Abder-Hedj\WORKING COPY\Current Code as of 08-10-07\AxonModel\Matlab Tests',path)
path('R:\Abder-Hedj\WORKING COPY\Current Code as of 08-10-07\Figure Gen Scripts',path)
path('R:\Abder-Hedj\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts',path)
path('R:\Abder-Hedj\WORKING COPY\Current Data as of 08-10-07\MRIFE Electrode Design Axon Simulations',path)
path('R:\Abder-Hedj\WORKING COPY\Current Data as of 08-10-07\MRIFE Validation Axon Simulations',path)
path('R:\Abder-Hedj\RH_Documents\Current Data as of 08-10-07\MRIFE Validation FEM Simulations',path)

javaaddpath({'R:\Abder-Hedj\WORKING COPY\Current Code as of 08-10-07\AmiraMeshImport',...
    'R:\Abder-Hedj\WORKING COPY\Current Code as of 08-10-07\AxonModel',...
    'R:\Abder-Hedj\RH_Documents\WorkInProgress\ScriptsInProgress',...
    'R:\Abder-Hedj'},'-end')

load('R:\VNEL Alumni Files\Olds-Kevin\modelfem4.mat')
names = {};

for i =5:2:9
   names{end+1} = fem.appl{1}.bnd.name{i};
end

listOfSubdoms = fem.appl{1}.equ.name;
clear fem;

for j = 1:length(names)
    filename = [names{j},'_comsol_common_cruz_sim'];
    cd 'R:\VNEL Alumni Files\Olds-Kevin';
    load(filename);
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
    current = abs(integrateCurrent(fem, getIndCell(listOfSubdoms,names{j})));
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Data as of 08-10-07\MRIFE Validation FEM Simulations';
    run SampleModelScript;
    cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Data as of 08-10-07\MRIFE Validation Axon Simulations';
    load ParametersAndWaveform200uA200uS.mat;
    run FullThresholdScriptAbder;
   % cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
   % run ThresholdPostProcAbder;   
    cd 'R:\VNEL Alumni Files\Olds-Kevin';
    % hgsave(['Results Figure ',filename]);
    save(['Workspace ',filename]);
    clear h*;
    clear p*;
    clear s*;
    clear f*;
    clear t*;
    clear w*;
    clear c*;
    clear e*;
    clear a*;
    clear i*;
    clear f*;
    close all;
end