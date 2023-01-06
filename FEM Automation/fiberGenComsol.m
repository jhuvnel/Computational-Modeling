function [traj, fiberType, p0] = fiberGenComsol(V_nerve, V_crista, numGen, step)
%FIBERGENCOMSOL This function generates the vertices (nodes) of axons given
%a comsol model and the vector field defining flow along a nerve and the
%crista to start from. It will randomly distribute the axons evenly along
%the crista surface. It uses the stream3Comsol() Matlab function to
%generate a streamline using the vector field.
%   The function takes as arguments: 
%       V_nerve: the post data output from mpheval for the vector field
%           within a nerve
%       V_crista: the post data output from mpheval for any variable on the
%           desired crista (this function only uses the coordinates and 
%           simpleces returned, not the variable's value)
%       numGen: the total number of axons to generate. 
%       step: column vector of internode distances for each node of
%       Ranvier. To only set first two and fill the rest, use format 
%       [3.05e-3; 3.00e-3 ;-1]
%   Returns:
%       verts: a cell array containing the vertices of
%           the fiber trajectory, with each vertex being a node of Ranvier.
%       fiberType: indicates which fiberType each generated axon is
%       p0: starting points on the crista for each generated axon
%   October 2022, Evan Vesper, VNEL

% returns a cell of {loc index, 1xNumNodes array of internode distances, 3xNumNodes trajectory array}

nStartBnd = size(V_crista.t,2); % number of triangles on the crista
% preallocation
traj = cell(numGen,3);
nStartBnd = size(V_crista.t,2);
p0 = zeros(3,numGen); 

%% find centroid of the surface
v1 = V_crista.p(:,1);
v2 = V_crista.p(:,2);
v3 = V_crista.p(:,3);
areas = abs(cross(v2 - v1, v3 - v1))/2;


%%
startBnd = randi(nStartBnd,numGen,1); % random starting triangle for each fiber

% get vertices of starting triangle

% Comsol simplex returned with start index of 0, so must add 1 to work
% with Matlab's start index of 1
indv = V_crista.t + int32(ones(3,nStartBnd));
v1 = V_crista.p(:,indv(1,startBnd));
v2 = V_crista.p(:,indv(2,startBnd));
v3 = V_crista.p(:,indv(3,startBnd));
% generate random numbers for placing axon on the starting triangle
a = ones(3,1)*rand(1,numGen); b = ones(3,1)*rand(1,numGen);
% generate starting point for streamline
% equation for finding a random point on a triangle in 3D space
p0 = (1-sqrt(a)).*v1 + (sqrt(a).*(1-b)).*v2 + (b.*sqrt(a)).*v3;

%% Just generate streamline with step size of internode distances
[verts, step_out] = stream3Comsol(V_nerve.p,V_nerve.t,V_nerve.d1,V_nerve.d2,...
    V_nerve.d3,p0,step);
% plotFlow(V_nerve,V_crista,verts);
% title('stream3Comsol output (internode step)')

traj(:,2:3) = [step_out, verts];

%% This is WIP of trying to generate streamline with a small step size and then sampling along the curve to find nodes
% step_base = [0.01;-1];
% verts = stream3Comsol(V_nerve.p,V_nerve.t,V_nerve.d1,V_nerve.d2,...
%     V_nerve.d3,p0,step_base);
% figure
% plotFlow(V_nerve,V_crista,verts)
% title('stream3Comsol output (small step size)')

% step_full = [];
% % I believe I could optimize this by dividing remaining arclength by
% % step_fill to find final size of step_full for preallocation.
% for i = 1:numGen
%     if size(verts{i},2) < ceil(1/step_base(1))
%         traj{i,3} = [0;0;0];
%         traj{i,2} = [];
%         warning(['Current trajectory ',num2str(i),' is too short. Filling traj with zeros.'])
%     else
%         arclen = arclength(verts{i}(1,:),verts{i}(2,:),verts{i}(3,:));
%         
%         cumStepLength = zeros(3,1);
%         % Generate cumuluative sum of step vector
%         stepFillFlag = step(end) == -1; % flag for if asked to auto fill step vector
%         if stepFillFlag
%             step_full = step(1:end-1);
%             step_fill  = step(end-1); % step size to auto fill with
%             cumStepLength = cumsum(step_full);
%             while cumStepLength(end) + step(end-1) < arclen
%                 step_full = [step_full; step_fill];
%                 cumStepLength = [cumStepLength; cumStepLength(end)+step_fill];
%             end
%         else % if full step vector is provided (no auto fill)
%             step_full = step;
%             cumStepLength = cumsum(step);
%             
%             % cut off steps at end that would make it longer than actual fiber
%             % trajectory
%             steps_on_curve = cumStepLength<arclen;
%             step_full = step_full(steps_on_curve);
%             cumStepLength = cumStepLength(steps_on_curve);
%         end
%         
%         try
%             % interpolate trajectory at node points
%             relArcLen = cumStepLength/arclen;
%             traj{i,3} = interparc(relArcLen,verts{i}(1,:),verts{i}(2,:),verts{i}(3,:));
%             % output step vector
%             traj{i,2} = step_full;
%         catch ME
%             warning(['Error with interparc for trajectory ',num2str(i),'. Filling traj with zeros.'])
%             traj{i,3} = [0;0;0];
%             traj{i,2} = [];
%         end
% 
%     end
% end


% not yet implemented
% traj{:,1} = ??? % locInd
fiberType = 0;


end

