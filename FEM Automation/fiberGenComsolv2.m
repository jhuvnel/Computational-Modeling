function [trajs, p0] = fiberGenComsolv2(V_nerve, V_crista, locIndex, step, basisVecTags, model, dset)
%FIBERGENCOMSOLV2 This function generates the vertices (nodes) of axons
%given a comsol model and the vector field defining flow along a nerve and
%the crista to start from. It will randomly distribute the axons evenly
%along the crista surface dependent on a given locIndex, or normalized
%radius along the crista. It uses the stream3Comsol() function to generate
%a streamline using the vector field.
%   The function takes as arguments: 
%       V_nerve: the post data output from mpheval for the vector field
%           within a nerve
%       V_crista: the post data output from mpheval for any variable on the
%           desired crista (this function only uses the coordinates and
%           simpleces returned, not the variable's value)
%       locIndex: a column vector containing a normalized "radius" along
%           the crista to place each seed node at. The number of rows will
%           be the total number of seed points generated
%       step: column vector of internode distances for each node of
%           Ranvier. To only set first two and fill the rest, use format 
%           [3.05e-3; 3.00e-3;-1]
%       basisVecTags: a 1 x 9 cell array containing the tags for the
%           components of each basis vector in Comsol, in the form of a
%           char vector or string. Should be in the form 
%           {e1x, e1y, e1z, e2x, e2y, e2z, e3x, e3y, e3z} 
%       model: Model object for Comsol model through Livelink. dset: string
%           vector containing the tag for the dataset in model with the
%           flow information for the relevant nerve (same dataset as was
%           used to get V_nerve)
%       
%   Returns:
%       trajs: an n x 3 cell array. Each row contains a set of information
%           for 1 axon (n = number of axons). The first column contains the
%           locIndex. The second column contains a vector of internode
%           distances (the step). The third column contains the vertices of
%           the fiber trajectory, with each vertex being a node of Ranvier.
%       p0: starting points on the crista for each generated axon
%   January 2023, Evan Vesper, VNEL

%% TO DO
% move all of the projection code into a function so that I can save the
% projection axes and don't have to do it every time

% turn off plotting if it works well

% double check everything one more time
%% find centroid of the surface
% get vertices of starting triangle
nTri = size(V_crista.t,2);
% Comsol simplex returned with start index of 0, so must add 1 to work
% with Matlab's start index of 1
indv = V_crista.t + int32(ones(3,nTri));
% get vertices of simplex
v1 = V_crista.p(:,indv(1,:));
v2 = V_crista.p(:,indv(2,:));
v3 = V_crista.p(:,indv(3,:));
verts3d = V_crista.p;
nVerts = size(verts3d,2);

% calculate centroid of each triangle
centroids = (v1 + v2 + v3)/3;
% calculate area of each triangle
cProd = cross(v2 - v1, v3 - v1);
areas = sqrt(cProd(1,:).^2 + cProd(2,:).^2 + cProd(3,:).^2)/2;
% calculate centroid of the entire surface (average of the triangle
% centroids, weighted by triangle area)
trueSurfCentroid = centroids*areas'/sum(areas);

% check if surfCentroid is in the nerve
indv_nerve = V_nerve.t + int32(ones(4,size(V_nerve.t,2)));
verts3d_nerve = V_nerve.p;
TR3d = triangulation(double(indv_nerve)',verts3d_nerve');
centroidTet = pointLocation(TR3d, trueSurfCentroid');
if isnan(centroidTet) % if the centroid is outside the nerve
    nearestCentroid = nearestNeighbor(TR3d, trueSurfCentroid');
    neighbor = verts3d_nerve(:, nearestCentroid); % neighbor vertice coords
    
    % step a little bit into the nerve
    surfCentroid = neighbor + .1* [V_nerve.d1(nearestCentroid); V_nerve.d2(nearestCentroid); V_nerve.d3(nearestCentroid)];
    disp('Warning: Seed surface centroid is outside the nerve. Using closest point instead.')
    
else
    surfCentroid = trueSurfCentroid;
end
%% Extract x-component of curvilinear coordinates at centroid
% mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_vest_inlet_bnd);
[b11, b12, b13, b21, b22, b23, b31, b32, b33] = mphinterp(model, basisVecTags, 'coord', surfCentroid, 'dataset', dset);
% note: it shouldn't really change anything, but I rearranged the basis
% vectors so that the surface is projected onto x and y (e1 and e2) of new
% plane, just to look nice
e1 = -1*[b11; b12; b13]; % normal vector to plane (z')
e2 = [b31; b32; b33]; % basis vector 1 of plane (x')
e3 = [b21; b22; b23]; % basis vector 2 of plane (y')
%% Plot 3d crista and centroids
f1 = plotFlow(V_nerve, V_crista, 'p0', centroids, 'plotFlow', false);
hold on
plot3(surfCentroid(1),surfCentroid(2),surfCentroid(3),'k*')
plot3([surfCentroid(1), surfCentroid(1) + e1(1)*0.1],[surfCentroid(2), surfCentroid(2) + e1(2)*0.1],[surfCentroid(3), surfCentroid(3) + e1(3)*0.1],'g-')
plot3([surfCentroid(1), surfCentroid(1) + e2(1)*0.1],[surfCentroid(2), surfCentroid(2) + e2(2)*0.1],[surfCentroid(3), surfCentroid(3) + e2(3)*0.1],'r-')
plot3([surfCentroid(1), surfCentroid(1) + e3(1)*0.1],[surfCentroid(2), surfCentroid(2) + e3(2)*0.1],[surfCentroid(3), surfCentroid(3) + e3(3)*0.1],'k-')
title('3D Crista Surface with centroids')
axis equal
ax = gca; 
% legend('Crista surface mesh', 'Centroids of crista triangles', 'Centroid of mesh', 'Direction of projection plane') 
f1.Position = [100 100 560 420];
view(ax, e1)
rotate3d(f1)
drawnow

% Check if user approves of projection...
projAngle = ax.View;
warnbox = warndlg('Rotate the axes until you are satisfied with the projection. Hit ok when done.','Choose projection angle');
waitfor(warnbox);
if projAngle ~= ax.View
    % replace the basis vectors to match the current viewing angle
    [viewaz, viewel] = view(); % view() handles angles in degrees, not radians!
    viewaz = viewaz - 90; % make azimuth referenced to -y axis since the axis.View property has a different azimuth definition than sph2cart() function
    
    % create new basis vectors from transform
    % Modified Gram-Schmidt Method
    [e1(1), e1(2), e1(3)] = sph2cart(deg2rad(viewaz), deg2rad(viewel), 1);  % spherical coords are in radians
    e2 = e2 - e1*dot(e1, e2)/dot(e1,e1);
    e3 = e3 - e1*dot(e1, e3)/dot(e1,e1);
    
    e3 = e3 - e2*dot(e2, e3)/dot(e2,e2);

    e2 = e2/norm(e2);
    e3 = e3/norm(e3);
end
%% Plot old and new basis vectors
% figure
% plot3([0, -1*b11], [0, -1*b12], [0, -1*b13], '.g-')
% hold on
% plot3([0, b31], [0, b32], [0, b33], '.r-')
% plot3([0, b21], [0, b22], [0, b23], '.k-')
% 
% plot3([0, e1(1)], [0, e1(2)], [0, e1(3)], 'xg-')
% plot3([0, e2(1)], [0, e2(2)], [0, e2(3)], 'xr-')
% plot3([0, e3(1)], [0, e3(2)], [0, e3(3)], 'xk-')
% axis equal
%% Flatten crista surface by projecting onto a plane
% The plane to be projected on will be perpendicular to direction of flow
% in nerve at the centroid of the crista surface mesh

% the plane is defined by the normal vector normVec
% let the centroid of the surface be the origin of the new plane
% orthonormal basis vectors, e1 and e2, are already defined by curvilinear
% coordinates from Comsol

s = dot(e1*ones(1,nVerts), verts3d - surfCentroid); % normal distance from 3d point to plane (not actually needed)
t1 = dot(e2*ones(1,nVerts), verts3d - surfCentroid); % coordinate 1 for projected points
t2 = dot(e3*ones(1,nVerts), verts3d - surfCentroid); % coordinate 2 for projected points
verts2d = [t1; t2];


%% Plot flattened crista surface
f2 = figure;

for i = 1:nTri
    t14 = [t1(:,indv(1,i)), t1(:,indv(2,i)), t1(:,indv(3,i)), t1(:,indv(1,i))];
    t24 = [t2(:,indv(1,i)), t2(:,indv(2,i)), t2(:,indv(3,i)), t2(:,indv(1,i))];
    plot(t14, t24, '-b.')
    if i == 1
        hold on
    end
end
plot(0,0,'g*')
plot([0 0.1], [0 0], 'r')
plot([0 0], [0 0.1], 'k')
axis equal
title('Flattened Crista Mesh')
f2.Position = [100 100 560 420];
drawnow
%% Find the outer edge of the flattened surface

indSimplexOuterEdge = outerEdge(indv); % refers to indeces of the original/2d verts for each edge
origEdgeVerts2d1 = verts2d(:, indSimplexOuterEdge(1,:));
origEdgeVerts2d2 = verts2d(:, indSimplexOuterEdge(2,:));
for i = 1:size(indSimplexOuterEdge,2)
    plot([origEdgeVerts2d1(1,i), origEdgeVerts2d2(1,i)],[origEdgeVerts2d1(2,i), origEdgeVerts2d2(2,i)], '-m')
%     pause(0.1)
end
%% Extract and sort vertices along perimeter of flattened crista
% convert from "simplex" indeces for each edge to just the indeces of all the outer edge verts
% [indEdgeVerts, ~, ~] = unique(indSimplexOuterEdge(:)); 
% edgeVerts2d = verts2d(:,indEdgeVerts);

% % put outer edge vertices into clockwise order - NOTE this only works if
% % the outer edge is convex and there are no holes in the mesh!
% theta = atan2(edgeVerts2d(2,:), edgeVerts2d(1,:));
% [~, sortedInds] = sort(theta);
% edgeVerts2d = edgeVerts2d(:,sortedInds);

%% Choose outer edge segment to place seed axis on
% note - with this method, the edges calculated here will not be in order,
% but the specific edge each point lands on should still work
numGen = length(locIndex);

% calculate cumulative sum of the length of each edge segment for weighting
edgeVectors =  [origEdgeVerts2d1(1,:)-origEdgeVerts2d2(1,:); origEdgeVerts2d1(2,:)-origEdgeVerts2d2(2,:)]; 
edgeLengths = sqrt( (edgeVectors(1,:)).^2 + (edgeVectors(2,:)).^2 );
edgeLengthsCum = cumsum(edgeLengths);
perimeter = edgeLengthsCum(end);

edgeVectorsNorm = edgeVectors./([1;1] * (sqrt((edgeVectors(1,:).^2 + edgeVectors(2,:).^2)))); % normalize into unit vectors

% % randomly generate position along perimeter
% edgeArcLen = perimeter*rand(numGen,1); % random length along perimeter
% edgeLogic = cumsum(edgeLengthsCum >= edgeArcLen,2) == 1; % determine which edge segment each length is on
% [edgeSeedInd, ~] = find(edgeLogic');
% edgeSeedPos = edgeLengthsCum(edgeSeedInd)' - edgeArcLen; % length along each edge segment to place the seed vertice
% 
% 
% edgeVectorsNorm = edgeVectors./([1;1] * (sqrt((edgeVectors(1,:).^2 + edgeVectors(2,:).^2)))); % normalize into unit vectors
% edgeSeedVerts = origEdgeVerts2d2(:,edgeSeedInd) + edgeVectorsNorm(:,edgeSeedInd).*([1;1]*edgeSeedPos');
% 
% % the centroid is already the origin of the coordinate system, so
% % edgeSeedVerts is already a ray from the centroid to the outer edge
% seedNodes2d = edgeSeedVerts.*([1;1]*locIndex')/10;

%% Generate final seed point on flattened crista
% check if seed points are on the crista - will catch those generated off
% the crista due to convexity
% create triangulation object to use Matlab's built-in functions
TR2d = triangulation(double(indv)',verts2d');

check = true;
maxiter = 1000; % max iterations
iter = 1;
badSeeds = true(numGen,1);
edgeArcLen = zeros(numGen, 1);
edgeSeedPos = zeros(numGen, 1);
edgeSeedVerts = zeros(2, numGen); 
seedNodes2d = zeros(2, numGen);
while check
    % randomly generate position along perimeter
    edgeArcLen(badSeeds) = perimeter*rand(sum(badSeeds),1); % random length along perimeter

    % this redoes the calculations for good seed points, but it isn't very
    % computationally intensive so it should be fine
    edgeLogic = cumsum(edgeLengthsCum >= edgeArcLen,2) == 1; % determine which edge segment each length is on
    [edgeSeedInd, ~] = find(edgeLogic');
    edgeSeedPos(badSeeds) = edgeLengthsCum(edgeSeedInd(badSeeds))' - edgeArcLen(badSeeds); % length along each edge segment to place the seed vertice
    
    
   
    edgeSeedVerts(:, badSeeds) = origEdgeVerts2d2(:,edgeSeedInd(badSeeds)) + edgeVectorsNorm(:,edgeSeedInd(badSeeds)).*([1;1]*edgeSeedPos(badSeeds)');
    
    % the centroid is already the origin of the coordinate system, so
    % edgeSeedVerts is already a ray from the centroid to the outer edge
    seedNodes2d(:, badSeeds) = edgeSeedVerts(:, badSeeds).*([1;1]*locIndex(badSeeds)')/10;
    
    % Find which triangle each point is in
    seedTris = pointLocation(TR2d,seedNodes2d'); % indeces of the triangles that seed points are on - returns NaN if not in a triangle (off crista)

    badSeeds = isnan(seedTris);
%     sum(badSeeds)
    if sum(badSeeds) == 0
        check = false; % all seeds on crista, good to go
    elseif iter >= maxiter
        check = 0;
        warning('Max iterations for seed generation reached.')
    end

    % plot seed nodes as they are updated
    pedgeBad = plot(edgeSeedVerts(1,badSeeds),edgeSeedVerts(2,badSeeds),'.r');
    pseedBad = plot(seedNodes2d(1,badSeeds),seedNodes2d(2,badSeeds),'*r');
    pedgeGood = plot(edgeSeedVerts(1,~badSeeds),edgeSeedVerts(2,~badSeeds),'.g');
    pseedGood = plot(seedNodes2d(1,~badSeeds),seedNodes2d(2,~badSeeds),'*g');
    pause(0.5)
    delete([pedgeBad, pseedBad, pedgeGood, pseedGood])
    

    iter = iter + 1;
end

% Plot edgeSeedNodes and seedNodes
% to just plot all the edgeSeedVerts at once
plot(edgeSeedVerts(1,:),edgeSeedVerts(2,:),'.g')
plot(seedNodes2d(1,:),seedNodes2d(2,:),'*r')

%% Plot outer edge
% 
% % using the "simplex" mapping
% f3 = figure;
% for i = 1:size(indSimplexOuterEdge,2)
%     plot([t1(indSimplexOuterEdge(1,i)), t1(indSimplexOuterEdge(2,i))], [t2(indSimplexOuterEdge(1,i)), t2(indSimplexOuterEdge(2,i))],'.-b');
%     if i == 1
%         hold on
%     end
% end
% title('Outer edge (flattened)')
% 
% % using sorted edge vertices
% % f3 = figure;
% % plot(edgeVerts2d(1,[1:end,1]),edgeVerts2d(2,[1:end,1]),'.-b')


%% Choose outer edge segment to place seed on
% % calculate cumulative sum of the length of each edge segment for weighting
% numGen = length(locIndex);
% 
% % since we know this shape is a closed loop, just match last vert to first
% % vert to close the shape
% edgeLengths = cumsum( sqrt( (edgeVerts2d(1,:)-edgeVerts2d(1,[2:end, 1])).^2 + (edgeVerts2d(2,:)-edgeVerts2d(2,[2:end, 1])).^2 ) );
% perimeter = edgeLengths(end);
% 
% % randomly generate position along perimeter
% edgeArcLen = perimeter*rand(numGen,1); % random length along perimeter
% edgeLogic = cumsum(edgeLengths >= edgeArcLen,2) == 1; % determine which edge segment each length is on
% [edgeSeedInd, ~] = find(edgeLogic');
% edgeSeedPos = edgeLengths(edgeSeedInd)' - edgeArcLen; % length along each edge segment to place the seed vertice
% 
% edgeVectors =  edgeVerts2d(:,:)-edgeVerts2d(:,[2:end, 1]); % find vector defining orientation of each edge
% edgeVectors = edgeVectors./([1;1] * (sqrt((edgeVectors(1,:).^2 + edgeVectors(2,:).^2)))); % normalize into unit vectors
% edgeSeedVerts = edgeVerts2d(:,edgeSeedInd) - edgeVectors(:,edgeSeedInd).*([1;1]*edgeSeedPos'); % reverse from the clockwise-most point on the edge

%% Plot outer edge of the crista and generated seed nodes
% f4 = figure;
% tempEdgeVerts2d = edgeVerts2d(:,[1:end,1]);
% for i = 1:size(edgeVerts2d,2)
%     if i == 1
%         plot(tempEdgeVerts2d(1,i),tempEdgeVerts2d(2,i),'*k')
%         hold on
%         plot(tempEdgeVerts2d(1,i:i+1),tempEdgeVerts2d(2,i:i+1),'-k')
%         title('Crista and seeds (flattened)')
%     else
%         plot(tempEdgeVerts2d(1,i:i+1),tempEdgeVerts2d(2,i:i+1),'.-b')
%     end
% %     pause(0.1)
%     thisEdgeSeeds = find(edgeSeedInd==i);
%     plot(edgeSeedVerts(1,thisEdgeSeeds),edgeSeedVerts(2,thisEdgeSeeds),'.m')
% %     pause(0.1)
% end
% axis equal
% 
% % to just plot all the edgeSeedVerts at once
% % plot(edgeSeedVerts(1,:),edgeSeedVerts(2,:),'.r')
% plot(seedNodes2d(1,:),seedNodes2d(2,:),'*r')
% 
% % for i = 1:size(edgeVerts2d,2)
% %     thisEdgeSeeds = find(edgeSeedInd==i);
% %     for j = 1:length(thisEdgeSeeds)
% %         plot([edgeSeedVerts(1,thisEdgeSeeds(j)), 0], [edgeSeedVerts(2,thisEdgeSeeds(j)), 0],'--m')
% %         plot(seedNodes2d(1,thisEdgeSeeds(j)),seedNodes2d(2,thisEdgeSeeds(j)),'*r');
% %         pause(0.1)
% %     end
% % end
% 
% f4.Position = [100 100 560 420];
% drawnow

%% Map to 3D
seedNodes3d = mapto3D(seedNodes2d, indv, verts2d, verts3d);

%%
% figure
% plot([triVert1(1) triVert2(1) triVert3(1) triVert1(1)], [triVert1(2) triVert2(2) triVert3(2) triVert1(2)])
% hold on
% plot(seedNodes2d(1,1),seedNodes2d(2,1),'*k')


%% Generate streamlines
step = [50e-3; -1];
[axonVerts, step_out] = stream3Comsol(V_nerve.p,V_nerve.t,V_nerve.d1,V_nerve.d2,...
    V_nerve.d3,seedNodes3d,step);

% at this point, step_out is the same as hardcoded step

%% Plot 3d points and streamlines
% % plot3d(f1.CurrentAxes, seedNodes3d(1,:), seedNodes3d(2,:), seedNodes3d(3,:), '*')
% 
% f5 = plotFlow(V_nerve, V_crista, 'p0', seedNodes3d, 'plotFlow', false);
% title('3D Crista with Seed Nodes')
% for i = 1:numGen
%     plot3(axonVerts{i}(1,:),axonVerts{i}(2,:),axonVerts{i}(3,:),'-g.')
% 
% end

%% This is WIP of trying to generate streamline with a small step size and then sampling along the curve to find nodes
% step_base = [0.01;-1];
% verts = stream3Comsol(V_nerve.p,V_nerve.t,V_nerve.d1,V_nerve.d2,...
%     V_nerve.d3,p0,step_base);
% figure
% plotFlow(V_nerve,V_crista,verts)
% title('stream3Comsol output (small step size)')

step_full = [];
% I believe I could optimize this by dividing remaining arclength by
% step_fill to find final size of step_full for preallocation.
for i = 1:numGen
    if size(axonVerts{i},2) < ceil(1/step_base(1))
        traj{i,3} = [0;0;0];
        traj{i,2} = [];
        warning(['Current trajectory ',num2str(i),' is too short. Filling traj with zeros.'])
    else
        arclen = arclength(axonVerts{i}(1,:),axonVerts{i}(2,:),axonVerts{i}(3,:));
        
        cumStepLength = zeros(3,1);
        % Generate cumuluative sum of step vector
        stepFillFlag = step(end) == -1; % flag for if asked to auto fill step vector
        if stepFillFlag
            step_full = step(1:end-1);
            step_fill  = step(end-1); % step size to auto fill with
            cumStepLength = cumsum(step_full);
            while cumStepLength(end) + step(end-1) < arclen
                step_full = [step_full; step_fill];
                cumStepLength = [cumStepLength; cumStepLength(end)+step_fill];
            end
        else % if full step vector is provided (no auto fill)
            step_full = step;
            cumStepLength = cumsum(step);
            
            % cut off steps at end that would make it longer than actual fiber
            % trajectory
            steps_on_curve = cumStepLength<arclen;
            step_full = step_full(steps_on_curve);
            cumStepLength = cumStepLength(steps_on_curve);
        end
        
        try
            % interpolate trajectory at node points
            relArcLen = cumStepLength/arclen;
            traj{i,3} = interparc(relArcLen,axonVerts{i}(1,:),axonVerts{i}(2,:),axonVerts{i}(3,:));
            % output step vector
            traj{i,2} = step_full;
        catch ME
            warning(['Error with interparc for trajectory ',num2str(i),'. Filling traj with zeros.'])
            traj{i,3} = [0;0;0];
            traj{i,2} = [];
        end

    end
end

%% Return output variables
locIndexOut = cell(numGen,1);
for i = 1:numGen
    locIndexOut{i} = locIndex(i);
end
trajs = [locIndexOut, step_out, axonVerts];
p0 = seedNodes3d;

%% Function definitions

function result = edgeNeighbors(v1Ind, v2Ind, indv)
    % This function returns the indices of the triangles bordering an edge
    % defined by two inputted vertices. The inputted vertices should
    % actually be connected on an edge. Returns result = [-1; x] if it is
    % on the edge of a surface (ie only one neighboring triangle)
    result = [-1; -1]; % if this edge is on the outside of the surface, then one of these will stay -1
	% cycle through all of the triangles
    for kk = 1:size(indv,2)
        if any(indv(:,kk) == v1Ind) % checks if first vertice is shared
            if any(indv(:,kk) == v2Ind) % checks if second vertice is shared
				% found one, add it to the list
				result(2) = result(1);
				result(1) = kk;
            end
        end
    end
end

function indOuterEdge = outerEdge(indv)
    % This functions returns the indeces of the outer edges of a given
    % 2-simplex surface. The output format will be a 2 x numEdgeSegments
    % array where each column contains the indeces of the the two vertices
    % defining the edge. The edges are not in order.
    indOuterEdge = [];

    for kk = 1:size(indv,2)
        
        vertA = indv(1,kk);
        vertB = indv(2,kk);
        vertC = indv(3,kk);
    
        adjacent = edgeNeighbors(vertA,vertB,indv); % check 1st edge
        if (adjacent(1) == -1 || adjacent(2) == -1)
            indOuterEdge  = [indOuterEdge, [vertA; vertB]];
        end
        adjacent = edgeNeighbors(vertA,vertC,indv); % check 2nd edge
        if (adjacent(1) == -1 || adjacent(2) == -1)
            indOuterEdge  = [indOuterEdge, [vertA; vertC]];
        end
        adjacent = edgeNeighbors(vertB,vertC,indv); % check 3rd edge
        if (adjacent(1) == -1 || adjacent(2) == -1)
            indOuterEdge  = [indOuterEdge, [vertB; vertC]];
        end
    end
end

function seedNodes3d = mapto3D(seedNodes2d, indv, verts2d, verts3d)
    nSeed = size(seedNodes2d,2);
    % create triangulation object to use Matlab's built-in functions
    TR2d = triangulation(double(indv)',verts2d');
    % Find which triangle each point is in. The triangles have the same IDs in
    % 2d and 3d
    seedTris = pointLocation(TR2d,seedNodes2d'); % indeces of the triangles that seed points are on
    
    triVertInds = indv(:,seedTris);
    
    vec1P2d = zeros(2,nSeed);
    seedNodes3d = zeros(3,nSeed);
    
    for kk = 1:nSeed
        % find seed point coordinates in 2d
        % find vertices of triangle that seed point is on
        triVert1 = verts2d(:, triVertInds(1,kk));
        triVert2 = verts2d(:, triVertInds(2,kk));
        triVert3 = verts2d(:, triVertInds(3,kk));
        
        % find coordinate axes (2 sides of triangle)
        vec12 = triVert2 - triVert1;
        vec13 = triVert3 - triVert1;
    
        dist12 = norm(vec12);
        dist13 = norm(vec13);
        
        % normalize vectors
        vec12 = vec12/dist12;
        vec13 = vec13/dist13;
    
        % make the vectors orthonormal
        vec13 = vec13 - vec12*(dot(vec13,vec12));
        vec13 = vec13/norm(vec13);
    
        dist13 = dot(vec13, triVert3 - triVert1); % redo max distance in orthogonal coordinate system
        
        % find coordinates of seed point
        vec1P2d(:,kk) = seedNodes2d(:,kk) - triVert1;
        coord1 = dot(vec1P2d(:,kk), vec12)/dist12;
        coord2 = dot(vec1P2d(:,kk), vec13)/dist13;
    
        % find seed point coordinates in 3d
        % get triangle vertices in 3d
        triVert1 = verts3d(:, triVertInds(1,kk));
        triVert2 = verts3d(:, triVertInds(2,kk));
        triVert3 = verts3d(:, triVertInds(3,kk));
    
        % find coordinate axes (2 sides of triangle)
        vec12 = triVert2 - triVert1;
        vec13 = triVert3 - triVert1;
    
        dist12 = norm(vec12);
        dist13 = norm(vec13);
        
        % normalize vectors
        vec12 = vec12/dist12;
        vec13 = vec13/dist13;
    
        % make the vectors orthonormal
        vec13 = vec13 - vec12*(dot(vec13,vec12));
        vec13 = vec13/norm(vec13);
    
        dist13 = dot(vec13, triVert3 - triVert1); % redo max distance in orthogonal coordinate system
        
        seedNodes3d(:,kk) = triVert1 + vec12*(coord1*dist12) + vec13*(coord2*dist13);
    end
end

end