function [verts, fiberType] = fiberGenComsol(V_nerve, V_crista, numGen)
%FIBERGENCOMSOL This function generates the vertices (nodes) of axons given
%a comsol model and the vector field defining flow along a nerve and the
%crista to start from. It will randomly distribute the axons evenly along
%the crista surface. It uses the stream3() Matlab function to generate a
%streamline using the vector field.
%   The function takes as arguments V_nerve:
%   the post data output from mpheval for the vector field within a nerve,
%   V_crista: the post data output from mpheval for any variable on the
%   desired crista (this function only uses the coordinates and simpleces
%   returned, not the variable's value), numGen: the total number of axons
%   to generate. It returns verts: a cell array containing the vertices of
%   the fiber trajectory, with each vertex being a node of Ranvier.
%   October 2022, Evan Vesper, VNEL

nStartBnd = size(V_crista.t,2); % number of triangles on the crista
verts = cell(numGen,1); % preallocate size of verts
p0 = verts;
startBnd = randi(nStartBnd,numGen,1); % random starting triangle for each fiber
step = 0.01;

% get vertices of starting triangle
% Comsol simplex returned with start index of 0, so must add 1 to work
% with Matlab's start index of 1
indv = flow_crista.t + int32(ones(3,nStartBnd));
v1 = V_crista.p(:,indv(1,:));
v2 = V_crista.p(:,indv(2,:));
v3 = V_crista.p(:,indv(3,:));
% generate random numbers for placing axon on the starting triangle
a = rand(1,numGen); b = rand(1,numGen);
% generate starting point for streamline
% equation for finding a random point on a triangle in 3D space
p0 = (1-sqrt(a)).*v1 + (sqrt(a)*(1-b)).*v2 + (b*sqrt(a)).*v3;

% figure
for i = 1:numGen


    
%     plot3([v1(1) v2(1) v3(1) v1(1)],[v1(2) v2(2) v3(2) v1(2)],[v1(3) v2(3) v3(3) v1(3)],'b')
%     hold on
%     plot3(p0(1),p0(2),p0(3),'r.')

    % trying my own streamline function...

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

    
    % not yet implemented
    verts = 0;
    fiberType{i} = 0;

end
end
