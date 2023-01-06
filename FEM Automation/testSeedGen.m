close all

%% Fiber generation parameters
numGen = 50;
% locIndex probably should be a different distribution based on type of
% fiber. This is just for testing!!!
locIndex = 10*rand(numGen,1);


basisVecTagsVest = {'cc3.e1x','cc3.e1y','cc3.e1z'}; % basis vector 1 (along the axon)
basisVec2TagsVest = {'cc3.e2x','cc3.e2y','cc3.e2z'}; % basis vector 2 (orthogonal to other two vectors)
basisVec3TagsVest = {'cc3.e3x','cc3.e3y','cc3.e3z'}; % basis vector 3 (orthogonal to other two vectors)


%% find centroid of the surface
V_crista = flow_lat_crista;
V_nerve = flow_vest_fixed;
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
surfCentroid = centroids*areas'/sum(areas);

%% Extract x-component of curvilinear coordinates at centroid
% mpheval(model,basisVecTags,'dataset',dset_vest,'selection',sel_vest_inlet_bnd);
[b11, b12, b13, b21, b22, b23, b31, b32, b33] = mphinterp(model, [basisVecTagsVest, basisVec2TagsVest, basisVec3TagsVest], 'coord', surfCentroid, 'dataset', dset_vest);
% note: it shouldn't really change anything, but I rearranged the basis
% vectors so that the surface is projected onto x and y (e1 and e2) of new
% plane, just to look nice
normVec = -1*[b11; b12; b13]; % normal vector to plane (z')
e1 = [b31; b32; b33]; % basis vector 1 of plane (x')
e2 = [b21; b22; b23]; % basis vector 2 of plane (y')
%% Plot 3d crista and centroids
f1 = plotFlow(V_nerve, V_crista, 'p0', centroids, 'plotFlow', false);
hold on
plot3(surfCentroid(1),surfCentroid(2),surfCentroid(3),'g*')
plot3([surfCentroid(1), surfCentroid(1) + normVec(1)*0.1],[surfCentroid(2), surfCentroid(2) + normVec(2)*0.1],[surfCentroid(3), surfCentroid(3) + normVec(3)*0.1],'g-')
plot3([surfCentroid(1), surfCentroid(1) + e1(1)*0.1],[surfCentroid(2), surfCentroid(2) + e1(2)*0.1],[surfCentroid(3), surfCentroid(3) + e1(3)*0.1],'r-')
plot3([surfCentroid(1), surfCentroid(1) + e2(1)*0.1],[surfCentroid(2), surfCentroid(2) + e2(2)*0.1],[surfCentroid(3), surfCentroid(3) + e2(3)*0.1],'k-')
title('3D Crista Surface with centroids')
axis equal
% legend('Crista surface mesh', 'Centroids of crista triangles', 'Centroid of mesh', 'Direction of projection plane') 

%% Flatten crista surface by projecting onto a plane
% The plane to be projected on will be perpendicular to direction of flow
% in nerve at the centroid of the crista surface mesh

% the plane is defined by the normal vector normVec
% let the centroid of the surface be the origin of the new plane
% orthonormal basis vectors, e1 and e2, are already defined by curvilinear
% coordinates from Comsol

s = dot(normVec*ones(1,nVerts), verts3d - surfCentroid); % normal distance from 3d point to plane (not actually needed?)
t1 = dot(e1*ones(1,nVerts), verts3d - surfCentroid); % coordinate 1 for projected points
t2 = dot(e2*ones(1,nVerts), verts3d - surfCentroid); % coordinate 2 for projected points
verts2d = [t1; t2];


%% Plot flattened crista surface
f2 = figure;

for i = 1:nTri
    t14 = [t1(:,indv(1,i)), t1(:,indv(2,i)), t1(:,indv(3,i)), t1(:,indv(1,i))];
    t24 = [t2(:,indv(1,i)), t2(:,indv(2,i)), t2(:,indv(3,i)), t2(:,indv(1,i))];
    plot(t14, t24, '*-b')
    if i == 1
        hold on
    end
end
plot(0,0,'g*')
plot([0 0.1], [0 0], 'r')
plot([0 0], [0 0.1], 'k')
axis equal
title('Flattened Crista Mesh')
%% Find the outer edge of the flattened surface

indSimplexOuterEdge = []; % refers to indeces of the original/2d verts for each edge

for i = 1:nTri
    
    vertA = indv(1,i);
    vertB = indv(2,i);
    vertC = indv(3,i);

    adjacent = edgeNeighbors(vertA,vertB,indv);
    if (adjacent(1) == -1 || adjacent(2) == -1)
        indSimplexOuterEdge  = [indSimplexOuterEdge, [vertA; vertB]];
    end
    adjacent = edgeNeighbors(vertA,vertC,indv);
    if (adjacent(1) == -1 || adjacent(2) == -1)
        indSimplexOuterEdge  = [indSimplexOuterEdge, [vertA; vertC]];
    end
    adjacent = edgeNeighbors(vertB,vertC,indv);
    if (adjacent(1) == -1 || adjacent(2) == -1)
        indSimplexOuterEdge  = [indSimplexOuterEdge, [vertB; vertC]];
    end
end

%% Extract and sort vertices along perimeter of flattened crista
% convert from "simplex" indeces for each edge to just the indeces of all the outer edge verts
[indEdgeVerts, ia, ic] = unique(indSimplexOuterEdge(:)); 
edgeVerts2d = verts2d(:,indEdgeVerts);

% put outer edge vertices into clockwise order
theta = atan2(edgeVerts2d(2,:), edgeVerts2d(1,:));
[theta, sortedInds] = sort(theta);
edgeVerts2d = edgeVerts2d(:,sortedInds);

%% Plot outer edge

% using the "simplex" mapping
% f3 = figure;
% for i = 1:size(indSimplexOuterEdge,2)
%     plot([t1(indSimplexOuterEdge(1,i)), t1(indSimplexOuterEdge(2,i))], [t2(indSimplexOuterEdge(1,i)), t2(indSimplexOuterEdge(2,i))],'.-b');
%     if i == 1
%         hold on
%     end
% end
% title('Outer edge (flattened)')

% using sorted edge vertices
% f3 = figure;
% plot(edgeVerts2d(1,[1:end,1]),edgeVerts2d(2,[1:end,1]),'.-b')


%% Choose outer edge segment to place seed on
% calculate cumulative sum of the length of each edge segment for weighting

% simplex mapping
% edgeLengths = cumsum( sqrt( (verts2d(1,indSimplexOuterEdge(1,:))-verts2d(1,indSimplexOuterEdge(2,:))).^2 + (verts2d(2,indSimplexOuterEdge(1,:))-verts2d(2,indSimplexOuterEdge(2,:))).^2 ));

% sorted mapping
% since we know this shape is a closed loop, just match last vert to first
% vert to close the shape
edgeLengths = cumsum( sqrt( (edgeVerts2d(1,:)-edgeVerts2d(1,[2:end, 1])).^2 + (edgeVerts2d(2,:)-edgeVerts2d(2,[2:end, 1])).^2 ) );
perimeter = edgeLengths(end);

% randomly generate position along perimeter
edgeArcLen = perimeter*rand(numGen,1); % random length along perimeter
edgeLogic = cumsum(edgeLengths >= edgeArcLen,2) == 1; % determine which edge segment each length is on
[edgeSeedInd, ~] = find(edgeLogic');
% edgeSeedInd = edgeSeedInd - 1; % shift indeces back 1 so that 
edgeSeedPos = edgeLengths(edgeSeedInd)' - edgeArcLen; % length along each edge segment to place the seed vertice

% simplex mapping
% edgeVectors =  verts2d(:,indSimplexOuterEdge(1,edgeSeedInd)) - verts2d(:,indSimplexOuterEdge(2,edgeSeedInd)); 
% edgeVectors = edgeVectors./([1;1] * (sqrt((edgeVectors(1,:).^2 + edgeVectors(2,:).^2)))); % normalize into unit vectors
% edgeSeedVerts = verts2d(:,indSimplexOuterEdge(1,edgeSeedInd)) + edgeVectors.*([1;1]*edgeSeedPos');

% sorted mapping
edgeVectors =  edgeVerts2d(:,:)-edgeVerts2d(:,[2:end, 1]); 
edgeVectors = edgeVectors./([1;1] * (sqrt((edgeVectors(1,:).^2 + edgeVectors(2,:).^2)))); % normalize into unit vectors
edgeSeedVerts = edgeVerts2d(:,edgeSeedInd) - edgeVectors(:,edgeSeedInd).*([1;1]*edgeSeedPos'); % reverse from the clockwise-most point on the edge


%% Generate final seed point on flattened crista
% the centroid is already the origin of the coordinate system, so
% edgeSeedVerts is already a ray from the centroid to the outer edge

seedNodes2d = edgeSeedVerts.*([1;1]*locIndex')/10;

%% Plot outer edge of the crista and generated seed nodes
f4 = figure;
tempEdgeVerts2d = edgeVerts2d(:,[1:end,1]);
for i = 1:size(edgeVerts2d,2)
    if i == 1
        plot(tempEdgeVerts2d(1,i),tempEdgeVerts2d(2,i),'*k')
        hold on
        plot(tempEdgeVerts2d(1,i:i+1),tempEdgeVerts2d(2,i:i+1),'-k')
        title('Crista and seeds (flattened)')
    else
        plot(tempEdgeVerts2d(1,i:i+1),tempEdgeVerts2d(2,i:i+1),'.-b')
    end
    pause(0.1)
    thisEdgeSeeds = find(edgeSeedInd==i);
    plot(edgeSeedVerts(1,thisEdgeSeeds),edgeSeedVerts(2,thisEdgeSeeds),'.m')
    pause(0.1)
end
axis equal

% to just plot all the edgeSeedVerts at once
% plot(edgeSeedVerts(1,:),edgeSeedVerts(2,:),'.r')

for i = 1:size(edgeVerts2d,2)
    thisEdgeSeeds = find(edgeSeedInd==i);
    for j = 1:length(thisEdgeSeeds)
        plot([edgeSeedVerts(1,thisEdgeSeeds(j)), 0], [edgeSeedVerts(2,thisEdgeSeeds(j)), 0],'--m')
        plot(seedNodes2d(1,thisEdgeSeeds(j)),seedNodes2d(2,thisEdgeSeeds(j)),'*r');
        pause(0.1)
    end
end

%% Map to 3D
% create triangulation objects to use Matlab's built-in functions
TR3d = triangulation(double(indv)',verts3d');
TR2d = triangulation(double(indv)',verts2d');
% Find which triangle each point is in. The triangles have the same IDs in
% 2d and 3d
seedTris = pointLocation(TR2d,seedNodes2d'); % indeces of the triangles that seed points are on
seedTriNormals = faceNormal(TR3d, seedTris); % normal vectors to the face of the seed triangles

triVertInds = indv(:,seedTris);

vec1P2d = zeros(2,numGen);
seedNodes3d = zeros(3,numGen);

for i = 1:numGen
    % find seed point coordinates in 2d
    % find vertices of triangle that seed point is on
    triVert1 = verts2d(:, triVertInds(1,i));
    triVert2 = verts2d(:, triVertInds(2,i));
    triVert3 = verts2d(:, triVertInds(3,i));
    
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
    vec1P2d(:,i) = seedNodes2d(:,i) - triVert1;
    coord1 = dot(vec1P2d(:,i), vec12)/dist12;
    coord2 = dot(vec1P2d(:,i), vec13)/dist13;

    % find seed point coordinates in 3d
    % get triangle vertices in 3d
    triVert1 = verts3d(:, triVertInds(1,i));
    triVert2 = verts3d(:, triVertInds(2,i));
    triVert3 = verts3d(:, triVertInds(3,i));

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
    
    seedNodes3d(:,i) = triVert1 + vec12*(coord1*dist12) + vec13*(coord2*dist13);
end
%%
% figure
% plot([triVert1(1) triVert2(1) triVert3(1) triVert1(1)], [triVert1(2) triVert2(2) triVert3(2) triVert1(2)])
% hold on
% plot(seedNodes2d(1,1),seedNodes2d(2,1),'*k')


%% Generate streamlines

[axonVerts, step_out] = stream3Comsol(V_nerve.p,V_nerve.t,V_nerve.d1,V_nerve.d2,...
    V_nerve.d3,seedNodes3d,step);

%% Plot 3d points and streamlines
% plot3d(f1.CurrentAxes, seedNodes3d(1,:), seedNodes3d(2,:), seedNodes3d(3,:), '*')

f5 = plotFlow(V_nerve, V_crista, 'p0', seedNodes3d, 'plotFlow', false);
title('3D Crista with Seed Nodes')
for i = 1:numGen
    plot3(axonVerts{i}(1,:),axonVerts{i}(2,:),axonVerts{i}(3,:),'-g.')

end
%% Function definitions

function result = edgeNeighbors(v1Ind, v2Ind, indv)
    % This function returns the indices of the triangles bordering an edge
    % defined by two inputted vertices. The inputted vertices should
    % actually be connected on an edge. Returns result = [-1; x] if it is
    % on the edge of a surface/
    result = [-1; -1]; % if this edge is on the outside of the surface, then one of these will stay -1
	% cycle through all of the triangles
	for i = 1:size(indv,2)
		if any(indv(:,i) == v1Ind)
			if any(indv(:,i) == v2Ind)
				% found one, add it to the list
				result(2) = result(1);
				result(1) = i;
            end
        end
    end
end