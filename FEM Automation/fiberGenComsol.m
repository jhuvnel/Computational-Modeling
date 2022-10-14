function [verts, fiberType] = fiberGenComsol(model, U_nerve,inputArg2)
%FIBERGENCOMSOL Summary of this function goes here
%   Detailed explanation goes here


verts = stream3(U_nerve.p(1,:),U_nerve.p(2,:),U_nerve.p(3,:),...
    U_nerve.d1,U_nerve.d2,U_nerve.d3,startX,startY,startZ,step);


outputArg1 = inputArg1;
outputArg2 = inputArg2;
end

