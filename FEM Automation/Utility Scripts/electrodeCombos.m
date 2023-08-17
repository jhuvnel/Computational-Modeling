function [ECs, voltageTags, electrodeList, namesList, kk] = electrodeCombos(electrodes,electrodeNames,ECs,voltageTags,kk,model)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
N = length(electrodes); 
K=2;
Plist = nchoosek(1:N,K);
Plist = reshape(Plist(:,perms(1:K)),[],K);
Plist = sortrows(Plist);
stim = Plist(:,1);
ref = Plist(:,2);
P = length(stim);

electrodeList = cell(1,P);
namesList = cell(1,P);

for i = 1:P
    kk = kk + 1;
    
    voltageTags{kk} = ['V',num2str(kk)];
    % create ec physics for each electrode combination. Naming is
    % 'ec#_#' where first # is ref electrode, 2nd # is stim electrode
    ECs{kk} = model.component('comp1').physics.create(['ec',num2str(kk)], 'ConductiveMedia', 'geom1');
    ECs{kk}.field('electricpotential').field(voltageTags{kk}); % name output variable
    ECs{kk}.label(['Electric Currents ',electrodeNames{stim(i)},' ',electrodeNames{ref(i)},' ref']);
    % Set stimulating electrode as voltage source
    ECs{kk}.create('pot1', 'ElectricPotential', 2);
    ECs{kk}.feature('pot1').selection.named([electrodes{stim(i)}]);
    ECs{kk}.feature('pot1').set('V0', 1);
    % Set reference electrode as ground
    ECs{kk}.create('gnd1', 'Ground', 2);
    ECs{kk}.feature('gnd1').selection.named([electrodes{ref(i)}]);   
    
    % return electrode tags and names in order
    electrodeList{1,i} = electrodes{stim(i)};
    electrodeList{2,i} = electrodes{ref(i)};
    namesList{1,i} = electrodes{stim(i)};
    namesList{2,i} = electrodes{ref(i)};
end

end