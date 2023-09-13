function [superSolCell] = electrodeSuperposition(stimSolCell, refSolCell)
%ELECTRODESUPERPOSITION This function adds/subtracts the voltage fields
%from a set of electrode simulations. It creates all combinations of the
%given electrodes and returns a list.
%   This functions works on solutionCells, i.e. the fully exported voltage
%   data from Comsol. It subtracts the voltage field of the reference
%   electrode from that of the stimulating electrode to create 

superSolCell = stimSolCell; % copy solution cell - everything will be the same except the Ve and current vector arrays
nAxon = size(superSolCell,1);

for i = 1:nAxon
    superSolCell{i,3} = stimSolCell{i,3} - refSolCell{i,3}; % subtract ref electrode Ve from stim electrode Ve
    superSolCell{i,4} = stimSolCell{i,4} - refSolCell{i,4}; % same for current desnity vector
end


end