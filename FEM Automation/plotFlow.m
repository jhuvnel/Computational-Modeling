function [fOut] = plotFlow(flow_vest,flow_crista,varargin)
%plotFlow Creates a plot of the flow from a nerve outputted from Comsol.
%Option to plot vector field, crista mesh, starting fiber points, and fiber
%trajectories.
%   Draws and returns a figure with 3D axes with the desired components.
%   Required inputs are:
%       flow_vest: the post data output from mpheval for the vector field
%           within a nerve
%       V_crista: the post data output from mpheval for any variable on the
%           desired crista (this function only uses the coordinates and 
%           simpleces returned, not the variable's value)
%   Optional 3rd input:
%       traj: contains the trajectory information for axons and must be a
%           cell array containing a vector of 3D points.
%   
%   Name-value pair arguments are:
%       'p0',p0: A 3xn array of the coordinates of starting points of
%           trajectories on the crista mesh.
%       'plotFlow',plotFlow: A logical value, set to false to not plot
%           the quiver plot indicating flow in the nerve. Default is true.
%       'plotNerveMesh',plotNerveMesh: A logical value, set to true to plot
%           the mesh of flow_vest, which would be plotting the mesh of the
%           nerve. Default is false. WARNING - Matlab doesn't handle
%           plotting a large number of tets well. Probably best not to use
%           this capability
%       'plotCrista',plotCrista: A logical value, set to false to not
%           plot the crista surface mesh. Default is true.
%       'plotCristaFlow',plotCristaFlow: A logical value, set to true to
%           plot the vector field at the crista mesh points. Default is 
%           false.
%   October 2022, Evan Vesper, VNEL


% Parse inputs
p = inputParser;
validtraj = @(x) iscell(x);
validpoints = @(x) isfloat(x) && (size(x,1)==3);
addRequired(p,'flow_vest',@isstruct)
addRequired(p,'flow_crista',@isstruct)
addOptional(p,'traj',{[0;0;0]},validtraj)
addParameter(p,'p0',[0;0;0],validpoints)
addParameter(p,'plotFlow',1,@islogical)
addParameter(p,'plotNerveMesh',0,@islogical)
addParameter(p,'plotCrista',1,@islogical)
addParameter(p,'plotCristaFlow',0,@islogical)
parse(p,flow_vest,flow_crista,varargin{:})


f = figure;
% Plot vector field in nerve domain
if p.Results.plotFlow
    quiver3(flow_vest.p(1,:),flow_vest.p(2,:),flow_vest.p(3,:),...
        flow_vest.d1,flow_vest.d2,flow_vest.d3)
    hold on
end
% Plot nerve mesh - WARNING - Matlab really doesn't handle plotting this
% many tets well. Don't recommend using on the whole nerve
if p.Results.plotNerveMesh
    nTet = size(flow_vest.t,2);
    indv = flow_vest.t + int32(ones(4,nTet));
    % plot nerve 3-simpleces/tetrahedrons
    for i = 1:nTet
        indvi = indv(:,i);
        for j = 1:4 % for each face of the tetrahedron
            indvj = 1:4;
            indvj(j) = [];
            p4 = [flow_vest.p(:,indvi(indvj)), flow_vest.p(:,indvi(indvj)),...
                flow_vest.p(:,indvi(indvj)), flow_vest.p(:,indvi(indvj))];
            plot3(p4(1,:),p4(2,:),p4(3,:),'k')
            if (i == 1) && (j == 1)
                hold on
            end
        end
    end
end
% Plot crista vector field
if p.Results.plotCristaFlow
    plot3(flow_crista.p(1,:),flow_crista.p(2,:),flow_crista.p(3,:),'r.')
    hold on
end
% Plot crista mesh
if p.Results.plotCrista
    nStartBnd = size(flow_crista.t,2);
    indv = flow_crista.t + int32(ones(3,nStartBnd));
    % plot crista 2-simpleces
    for i = 1:nStartBnd
        indvi = indv(:,i);
        p4 = [flow_crista.p(:,indvi(1)), flow_crista.p(:,indvi(2)),...
            flow_crista.p(:,indvi(3)), flow_crista.p(:,indvi(1))];
        plot3(p4(1,:),p4(2,:),p4(3,:),'b')
        if i == 1
            hold on
        end
    end
end
% Plot starting points
if ~sum(strcmp(p.UsingDefaults{1},'p0'))
    plot3(p.Results.p0(1,:),p.Results.p0(2,:),p.Results.p0(3,:),'r.');
    hold on
end
% Plot trajectories
if ~sum(strcmp(p.UsingDefaults{1},'traj'))
    for i = 1:size(p.Results.traj,1)
        plot3(gca,p.Results.traj{i}(1,:),p.Results.traj{i}(2,:),p.Results.traj{i}(3,:),'-r.')
        if i == 1
            hold on
        end
    end
end

fOut = f;
end