%this function takes a fiber trajectory cell traj (generated from bulkFiberGeneration.m or fiberGen.m)
%and samples the solved model fem, current is the total amount of current (in Amps)
%injected through the electrodes (the output will be scaled to the condition of a 1A stimulus)
%output is another cell corresponding to the extracellular voltage of the axons
%output = {locInd, numAxonsxnumNodes array of internode distance, numAxonsxnumNodes array of extracellular voltage,
%numAxons x numNodesx3 current vector} (this last one only if outputFlag == 1)
%if outputFlag == 1 then the current vector at each point will also be
%found and added into the fourth spot in the output cell
%NOTE that this increases processing time significantly

function y = sampleModelSolution(fem, traj, current, outputFlag)
    numAxons = size(traj,1);
    temp = cell(numAxons, 5);
    disp('Beginning to sample model along fiber trajectories.')
    %cycle through all the axons and sample for each
    for i = 1:1:numAxons
        temp{i,1} = traj{i,1};      %locIndex
        samplePoints = traj{i,3};
        disp(['Sampling along fiber track ' num2str(i) ' of ' num2str(numAxons)])
        modelValues = postinterp(fem,'V', samplePoints,'ext',0); %get potential value
        temp{i,3} = (modelValues')/current;    %extracellular voltage array, use a column vector
        if (outputFlag == 1)
            %now find the current vector at each point
            currX = postinterp(fem,'Jx_dc', samplePoints,'ext',0)/current; %get x component
            currY = postinterp(fem,'Jy_dc', samplePoints,'ext',0)/current; %get y component
            currZ = postinterp(fem,'Jz_dc', samplePoints,'ext',0)/current; %get z component
            temp{i,4} = [currX; currY; currZ];      %store the current array
        end
    end
    temp{1,5} = traj;   %ADDED LATER, store all of traj just in case its need in the future
    temp{1,2} = traj{1,2};      %store step array (same for all fibers)
    y = temp;