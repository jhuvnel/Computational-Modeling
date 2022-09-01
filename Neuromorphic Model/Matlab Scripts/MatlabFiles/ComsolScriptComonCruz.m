clear fem;
load('R:\VNEL Alumni Files\Olds-Kevin\modelfem4.mat')
for i = 5:1:9
    clear fem;
    load('R:\VNEL Alumni Files\Olds-Kevin\modelfem4.mat')
    name1 = fem.appl{1}.bnd.name{i};
    namestr = [name1,'_comsol_common_cruz_sim'];
    fem.appl{1}.bnd.type{i} = 'V';
    fem.appl{1}.bnd.V0{i} = 1;
    fem.appl{1}.equ.sigma{i+2} = 100000;
    fem.appl{1}.bnd.type{13} = 'V';
    fem.appl{1}.bnd.V0{13} = '-1';
    fem.appl{1}.equ.sigma{13+2} = 100000;
    fem = multiphysics(fem);
    fem.xmesh = meshextend(fem);
    fem.sol = femstatic(fem,'linsolver','cg','prefun','amg','prepar',{'amgauto',5});
    save(namestr,'fem');
end