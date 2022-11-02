function [traj, fiberType, p0] = fiberGenComsol(V_nerve, V_crista, numGen, step)
%FIBERGENCOMSOL This function generates the vertices (nodes) of axons given
%a comsol model and the vector field defining flow along a nerve and the
%crista to start from. It will randomly distribute the axons evenly along
%the crista surface. It uses the stream3() Matlab function to generate a
%streamline using the vector field.
%   The function takes as arguments: 
%       V_nerve: the post data output from mpheval for the vector field
%           within a nerve
%       V_crista: the post data output from mpheval for any variable on the
%           desired crista (this function only uses the coordinates and 
%           simpleces returned, not the variable's value)
%       numGen: the total number of axons to generate. 
%       step: column vector of internode distances for each node of
%       Ranvier. To only set first two and fill the rest, use format 
%       [3.05e-6; 3.00e-6 ;-1]
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

% verts = stream3Comsol(V_nerve.p,V_nerve.t,V_nerve.d1,V_nerve.d2,...
%     V_nerve.d3,p0,step);
% To do - put streamline function inside here

    
verts = stream3Comsol(V_nerve.p,V_nerve.t,V_nerve.d1,V_nerve.d2,...
    V_nerve.d3,p0,step);

traj{:,3} = verts;


% not yet implemented
traj = 0;
fiberType{i} = 0;

    % the number of points returned in the vestibular nerve domain is way
    % too big - meshgrid would create a massive (TB size) array with this
    % many points... do I downsample the vector field, or write my own
    % streamline script? which would be easier? streamline script would
    % probably be easier
%     [XX, YY, ZZ] = meshgrid(V_nerve.p(1,:),V_nerve.p(2,:),V_nerve.p(3,:));
    
%     try
%     % generate streamline. Note: V_nerve is pointing distally, so reverse
%     % direction to get streamline going proximally (towards brainstem)
%         path = stream3(XX,YY,ZZ,-1*V_nerve.d1,-1*V_nerve.d2,-1*V_nerve.d3,...
%             p0(1),p0(2),p0(3),step);
%     %     dist = sqrt(sum(path).^2,2));
%     
%         % sample along streamline to get just nodes
%     %     for j = 1:length(dist)
%     %         
%     %         verts{i}(j) = 
%     %     end
%     catch ME
%         disp('Error in stream3\n')
%     end


end

