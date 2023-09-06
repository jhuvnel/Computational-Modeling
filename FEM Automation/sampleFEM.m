function solution = sampleFEM(model, vTags, ecTags, dsetTag, traj, currents)
%sampleFEM extracts FEM solution data (extracellular voltage) along given
%axon trajectories. It can get an arbitrary number of dependent variables
%from the Comsol model as provided as the vTags argument.
%   [solutionCell1, solutionCell2, ..., solutionCelln] = sampleFEM(model, vTags, dsetTag, traj)
%   Arguments
%       model: Comsol model object currently connected through Livelink to
%           grab solution data from
%       vTags: cell array of char vectors. Each cell contains the tag of
%           the desired dependent variable to output (should be one of the
%           voltage solutions).
%       ecTags: cell array of the electrical current physics nodes. Used to
%           extract the current vector at each point. Must be same number
%           of elements as vTags.
%       dsetTag: char vector of the dataset tag to pull solution data from.
%       traj: nAxonx3 trajectory cell array containing {locInd, 
%           internodeDist, nodeCoords} with a row for each axon.
%       current: an n x 1 or 1 x n double array of the total current
%       delivered by electrode (in Amps). The elements must correspond to
%       the ecTags and vTags arrays.
%   Returns
%       solutionCell: A 1xlength(vTags) cell where cell contains
%           an nAxonx5 cell array containing solution data.
%           Format is {locInd, internodeDist, dependentVariable,
%           currentVector, nodeCoords}. locInd, internodeDist, and
%           nodeCoords are copied directly from traj. The number of outputs
%           is equal to the number of cells in vTags.
nVars = numel(vTags);
nTraj = size(traj,1);

solution = cell(1,nVars);
for i = 1:nVars
    solution{i} = cell(nTraj,5);
    JTags = {[ecTags{i},'.Jx'], [ecTags{i},'.Jy'],[ecTags{i},'.Jz']};
    fprintf('Beginning to sample along fiber trajectories for variable %s (%d of %d)...\n',vTags{i},i,nVars)
    for j = 1:nTraj
%         fprintf('Sampling along axon %d of %d.\n',j,nTraj)
        % extract solution data
        var = mphinterp(model, vTags{i},'coord', traj{j,3},'dataset',dsetTag{i});
        % extract current density data
        [Jx, Jy, Jz] = mphinterp(model, JTags,'coord', traj{j,3},'dataset',dsetTag{i});
        solution{i}{j,1} = traj{j,1}; % locIndex
        solution{i}{j,2} = traj{j,2}*1e-3; % internode distance vector (and convert from mm to m!)
        solution{i}{j,3} = (var')/currents(i); % extracellular voltage vector, also transpose so it is a column vector
        solution{i}{j,4} = [Jx; Jy; Jz]; % current density vector array
        solution{i}{j,5} = traj{j,3}*1e-3; % node coordinates (and convert from mm to m!)
    end
    fprintf('Sampling %d of %d done!\n',i,nVars)
end % for i = 1:nVars
end % sampleFEM

