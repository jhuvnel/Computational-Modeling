function [fullSolCell, namesList, kk] = electrodeCombos(solCells,electrodeNames,kk)
%ELECTRODECOMBOS This function superimposes all combinations of inputted
%electrodes. Take solution cells as inputs.
%   Use this function to create all combinations of stimulating/reference
%   electrodes electric potential fields.
N = length(solCells); 
K=2;
Plist = nchoosek(1:N,K);
Plist = reshape(Plist(:,perms(1:K)),[],K);
Plist = sortrows(Plist);
stim = Plist(:,1);
ref = Plist(:,2);
P = length(stim);

% UNFINISHED?
fullSolCell = cell(1,P);
namesList = cell(1,P);

for i = 1:P
    kk = kk + 1;
    
    superSolCell = electrodeSuperposition(solCells{stim{i}},solCells{ref{i}});
    
    % return electrode tags and names in order
    fullSolCell{1,i} = superSolCell;
    namesList{1,i} = electrodeNames{stim(i)};
    namesList{2,i} = electrodeNames{ref(i)};
end

end