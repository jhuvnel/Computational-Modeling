%this function takes in a sampleModelSolution cell and passes the 
%extracellular voltages to a AxonSimulate class

function uploadVe(simCell, AxonSimClass, numAxons)
    for i = 1:1:numAxons
        AxonSimClass.uploadVe(simCell{i,3},i-1);
    end
    return;