% function [traj] = stream3Comsol(model,dataset,vTags,p0,step)
function [verts, step_out, insideTet] = stream3Comsol(XYZ,tets,u,v,w,p0,step)
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
stepFillFlag = 0;
if step(end) == -1
    stepFillFlag = 1;
end

maxIter = 100000; % max number of steps per fiber
verts = cell(np0,1);
step_out = verts;
insideTet = verts;

for i = 1:np0
    % can't preallocate size of traj with while loop. Maybe could make an
    % estimate of the needed number of points in traj based on the step size
    % and expected path if this is increasing time a lot
    p = p0(:,i);
    verts{i}(:,1) = p;
    step_out{i}(1) = step(1);
    insideTet{i} = pointLocation(TR,p');
    k = 1;
    % while condition is that the last point was inside the vector field's mesh
    stepFlag = 1;
    while stepFlag
        k = k+1;

        % Evaluate interpolation function
        uq = Fu(p(1),p(2),p(3));
        vq = Fv(p(1),p(2),p(3));
        wq = Fw(p(1),p(2),p(3));
        vecq = [uq; vq; wq];

        % Advance one step
        if stepFillFlag && ((length(step)-1) >= k) % autofill condition based on step vector
            p = p + step(k)*vecq;
            step_out{i}(k,1) = step(k);
        else
            p = p + step(end-1)*vecq;
            step_out{i}(k,1) = step(end-1);
        end
        
        % check if new point is within the nerve domain
        inside  = pointLocation(TR,p');
        stepFlag = (~isnan(inside)) && (k<maxIter);
        
        % Don't save last point if it leaves the nerve domain
        if stepFlag
            verts{i}(:,k) = p;
            insideTet{i}(k) = inside;
        end

    end % while stepFlag
end % for 1:np0

end % stream3Comsol