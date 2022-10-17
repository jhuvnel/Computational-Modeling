function [traj] = stream3Comsol(X,Y,Z,U,V,W,p0,step)
%stream3Comsol Generates a streamline given a vector field and starting
%points as inputs. Outputs vertices of the trajectory with the given step
%size. Uses Newton's method to generate the streamline.
%   Detailed explanation goes here
%   October 2022, Evan Vesper, VNEL

% Implement newton's method or something to create the streamline. Should
% be pretty simple (I hope). Also should add some functionality to stop
% when it reaches the end of where the vector field is defined. Also add
% some functionality to take a maximum step size.
nSteps = 1000;
traj = zeros(3,nSteps);
for i = 1:nSteps
    % Steps to implement:
    % 1) Find vector field direction at current point (interpolate)
    % 2) Calculate vector of one step in the correct direction
    % 3) Add step vector to last point
    % 4) Loop
end

traj = 0;
end