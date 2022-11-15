javaPath = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel';
% cd(javaPath)
classFiles = dir([javaPath,'\*.class']);
for i = 1:length(classFiles)
    paths{i} = [classFiles(i).folder,'\',classFiles(i).name];
end
javaFiles = dir([javaPath,'\*.class']);
for i = 1:length(javaFiles)
    paths2{i} = [javaFiles(i).folder,'\',javaFiles(i).name];
end

javaaddpath(paths)
javaaddpath(paths2)
javaaddpath(javaPath)
%%

% [~,~,test] = inmem;
% test

import java.util.ArrayList

A = ArrayList;

add(A,5)

A

%% 
% import C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel\AxonSimulate_G_AHPAxon_CVStar0265.class

javaPath = 'C:\Users\Evan\Documents\GitHub\Computational-Modeling\Neuromorphic Model\AxonModel\VNELAxon';
javaclasspath(javaPath)

import VNELAxon.*

% test.getA()

% testobject = test();
VNELAxon.test.getA()