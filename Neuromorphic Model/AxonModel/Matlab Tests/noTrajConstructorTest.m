%testing the new non-trajectory generating Axon classes
clear all;
javaaddpath('D:\Programming\Java Workspace Eclipse\AxonModel');
clear java      %reload the class, incase we messed with it

step = [1; -1];
nodeDiam = [3; -1];
nodeLenA = [5; -1];
nodeLenP = [10; -1];
numNodes = 30;
timeInc = 1e-7;
numTimeSteps = 100;

axonP = SENN_AxonP(step, nodeDiam, nodeLenA, nodeLenP, numNodes, timeInc, numTimeSteps);
axonI = SENN_AxonI(step, nodeDiam, nodeLenA, nodeLenP, numNodes, timeInc, numTimeSteps);

