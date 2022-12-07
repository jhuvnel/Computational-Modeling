%% find centroid of the surface

V_crista = flow_ant_crista;


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
[n1, n2, n3, e21, e22, e23, e11, e12, e13] = mphinterp(model, [basisVecTags, basisVec2Tags, basisVec3Tags], 'coord', surfCentroid, 'dataset', dset_vest);
% note: it shouldn't really change anything, but I rearranged the basis
% vectors so that the surface is projected onto x and y (e1 and e2) of new
% plane, just to look nice. Mathematically it doesn't change anything
normVec = -1*[n1; n2; n3]; % normal vector to plane (z')
e1 = [e11; e12; e13]; % basis vector 1 of plane (x')
e2 = [e21; e22; e23]; % basis vector 2 of plane (y')
%% Plot 3d crista and centroids
f1 = plotFlow(flow_vest_fixed, flow_ant_crista, 'p0', centroids, 'plotFlow', false);
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

for i = 1:nVerts
    
    

end


%% Function definitions

% double check if this works as intended. Should it be comparing every
% edge, or should it stick with comparing vertices?
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
				result(1) = result(0);
				result(0) = i;
            end
        end
    end
end

