%this file tests findUniqueVert routin in class FiberTrajGen
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AmiraMeshImport');
clear java      %reload the class, incase we messed with it
path('C:\COMSOL33\multiphysics;C:\COMSOL33\demo',path);     %to use meshplot

%vMatrix = [0 1 0 0 1; 0 0 1 0 1; 0 0 0 1 1];
load vMatrix;
load bndMatrix;
load bndIDMatrix;
load newTMatrix;

    el = cell(1,0);
    el{1} = struct('type','tet','elem',newTMatrix);
    m = femmesh(vMatrix,el);
    m = meshenrich(m, 'faceparam','off');   %faceparam fails for complicated meshes
%plot3(vMatrix(1,:),vMatrix(2,:),vMatrix(3,:));
%tMatrix = [1;2;3;4];
%bndMatrix = [1 4;...
%             2 3;...
%             3 2];
%dMatrix = [1];

meshplot(m);
