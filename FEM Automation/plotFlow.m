function [fOut] = plotFlow(flow_vest,flow_crista,varargin)
%plotFlow Creates a plot of the flow from a nerve outputted from Comsol.
%Option to plot vector field, crista mesh, starting fiber points, and fiber
%trajectories.
%   Draws and returns a figure with 3D axes with the desired components.
%   Required inputs are plotFlow(flow_vest,flow_crista). An optional 3rd
%   input is streams, which should contain the streamline information for
%   fiber trajectories. Name-value pair arguments are:
%       - 'p0',p0: A 3xn array of the coordinates of starting points of
%       trajectories on the crista mesh.
%       - 'plotFlow',plotFlow: A logical value, set to false to not plot
%       the quiver plot indicating flow in the nerve. Default is true.
%       - 'plotCrista',plotCrista: A logical value, set to flase to not
%       plot the crista surface mesh. Default is true.
%   October 2022, Evan Vesper, VNEL

% TO DO
% Add functionality to plot multiple crista meshes
% Add streamline plotting functionality

% Parse inputs
p = inputParser;
validpoints = @(x) isfloat(x) && (size(x,1)==3);
addRequired(p,'flow_vest',@isstruct)
addRequired(p,'flow_crista',@isstruct)
addOptional(p,'streams',[0;0;0],validpoints)
addParameter(p,'p0',[0;0;0],validpoints)
addParameter(p,'plotFlow',1,@islogical)
addParameter(p,'plotCrista',1,@islogical)
parse(p,flow_vest,flow_crista,varargin{:})


f = figure;
% Plot vector field for visualization/testing
if p.Results.plotflow
    quiver3(flow_vest.p(1,:),flow_vest.p(2,:),flow_vest.p(3,:),...
        flow_vest.d1,flow_vest.d2,flow_vest.d3)
    hold on
    plot3(flow_crista.p(1,:),flow_crista.p(2,:),flow_crista.p(3,:),'r.')
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
if ~strcmp(p.UsingDefaults{1},'p0')
    plot3(p.Results.p0(1,:),p.Results.p0(2,:),p.Results.p0(3,:),'r.');
    hold on
end

fOut = f;
end