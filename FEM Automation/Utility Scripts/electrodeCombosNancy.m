function [sol_out, StimElectrodeNames_out, RefElectrodeNames_out] = electrodeCombosNancy(sol_nerve, StimElectrodeNames, RefElectrodeNames)
%ELECTRODECOMBOSNANCY This function creates all the electrode combinations
%for Nancy that Brian Morris used. It works on the sol_cells for just one
%nerve.
%   This copies the first 14 monopolar stim cases, then does all
%   combinations of canal shank electrodes stimulating versus individual
%   common crus electrodes as return. Then, it does all intracanal bipolar
%   pairs for each canal. It returns the stimulating and reference
%   electrode names and a sol_cell for each combination.

% Create temp solution cells for each nerve that will be filled with
% electrode combinations
nCombos = 14 + 11*3 + 12 + 12 + 6; % monopolar, stim to CC (3 cc ref), anterior intracanal bipolar, lateral intracanal bipolar, posterior intracanal bipolar
sol_temp = [];
StimElectrodeNames_temp = [];
RefElectrodeNames_temp = [];
kk = 14;

% Canal electrodes returned through CC electrodes
for i = 1:11
    for j = 12:14
        kk = kk + 1;
        sol_temptemp = electrodeSuperposition(sol_nerve{i},sol_nerve{j});
        sol_temp{kk-14} = sol_temptemp;
        StimElectrodeNames_temp = [StimElectrodeNames_temp, StimElectrodeNames(i)];
        RefElectrodeNames_temp = [RefElectrodeNames_temp, StimElectrodeNames(j)];
    end
end

% Anterior shank combos
[sol_temptemp, names_temp, kk] = electrodeCombos(sol_nerve(1:4), StimElectrodeNames(1:4), kk);
sol_temp = [sol_temp, sol_temptemp];
StimElectrodeNames_temp = [StimElectrodeNames_temp, names_temp(1,:)];
RefElectrodeNames_temp = [RefElectrodeNames_temp, names_temp(2,:)];
% Lateral shank combos
[sol_temptemp, names_temp, kk] = electrodeCombos(sol_nerve(5:8), StimElectrodeNames(5:8), kk);
sol_temp = [sol_temp, sol_temptemp];
StimElectrodeNames_temp = [StimElectrodeNames_temp, names_temp(1,:)];
RefElectrodeNames_temp = [RefElectrodeNames_temp, names_temp(2,:)];
% Posterior shank combos
[sol_temptemp, names_temp, kk] = electrodeCombos(sol_nerve(9:11), StimElectrodeNames(9:11), kk);
sol_temp = [sol_temp, sol_temptemp];
StimElectrodeNames_temp = [StimElectrodeNames_temp, names_temp(1,:)];
RefElectrodeNames_temp = [RefElectrodeNames_temp, names_temp(2,:)];

% Concatenate new combos onto the original monopolar solutions
sol_out = [sol_nerve(1,1:14), sol_temp];
StimElectrodeNames_out = [StimElectrodeNames(1:14), StimElectrodeNames_temp];
RefElectrodeNames_out = [RefElectrodeNames(1:14), RefElectrodeNames_temp];
end