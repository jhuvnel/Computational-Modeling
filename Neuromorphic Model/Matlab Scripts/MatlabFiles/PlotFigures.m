load('R:\VNEL Alumni Files\Olds-Kevin\modelfem4.mat')
rnames = {};

for i =4:2:9
   rnames{end+1} = fem.appl{1}.bnd.name{i};
end

figure

for l =1:1:3
filename = ['Workspace ',rnames{l},'_comsol_unipol_sim'];
    cd 'R:\VNEL Alumni Files\Olds-Kevin';
    load(filename);

cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
subplot(2,3,l)
run ThresholdPostProcAbder;
disp(l)
end

for l=1:1:length(rnames)
filename = ['Workspace ',rnames{l},'_comsol_common_cruz_sim'];
    cd 'R:\VNEL Alumni Files\Olds-Kevin';
    load(filename);

cd 'R:\VNEL Alumni Files\Olds-Kevin\WORKING COPY\Current Code as of 08-10-07\Matlab Scripts';
 
k=l+3;
subplot(2,3,k)
run ThresholdPostProcAbder;

end
