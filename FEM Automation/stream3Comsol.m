% function [traj] = stream3Comsol(model,dataset,vTags,p0,step)
function [traj, insideTet] = stream3Comsol(XYZ,tets,u,v,w,p0,step)
%stream3Comsol Generates a streamline given a vector field and starting
%points as inputs. Outputs vertices of the trajectory with the given step
%size. Uses Newton's method to generate the streamline.
%   The input XYZ coordinates and u,v,w, vector field components must be in
%   row format, i.e. each column corresponds to one point and each row in
%   XYZ corresponds to one dimension. p0 should be an array of starting
%   point coordinates in row format, with each column being one point and
%   each row being a dimension. step should be a scalar indicating the step
%   size.
%   October 2022, Evan Vesper, VNEL

% Matlab fxns expect column format
XYZ = XYZ'; tets = tets'; u = u'; v = v'; w = w'; 
% Create interpolation function over scattered vector field
% scattered interpolation - this may be redoing some of the work that
% Comsol already did in creating the mesh, but it is a quick solution
% and it runs pretty quickly
Fu = scatteredInterpolant(XYZ,u);
Fv = scatteredInterpolant(XYZ,v);
Fw = scatteredInterpolant(XYZ,w);

np0 = size(p0,2);
nTet = size(tets,1);
% create triangulation object for the vector field's mesh
TR = triangulation(double(tets) + ones(nTet,4), XYZ);

traj = cell(np0,1);
insideTet = traj;

for i = 1:np0
    % can't preallocate size of traj with while loop. Maybe could make an
    % estimate of the needed number of points in traj based on the step size
    % and expected path if this is increasing time a lot
    traj{i} = zeros(3,1); 
    p = p0(:,i);
    traj{i}(:,1) = p;
    insideTet{i} = pointLocation(TR,p');
    k = 1;
    % while condition is that the last point was inside the vector field's mesh
    while ~isnan(insideTet{i}(k))
        k = k+1;

        % Evaluate interpolation function
        uq = Fu(p(1),p(2),p(3));
        vq = Fv(p(1),p(2),p(3));
        wq = Fw(p(1),p(2),p(3));
        vecq = [uq; vq; wq];

        % Advance one step
        p = p + step*vecq;
        traj{i}(:,k) = p;

        % Test if the new point is within the nerve domain/mesh where
        % vector field is defined
        insideTet{i}(k) = pointLocation(TR,p');
    end
end

end