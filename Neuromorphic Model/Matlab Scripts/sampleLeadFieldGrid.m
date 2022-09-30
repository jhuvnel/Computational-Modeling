%this function samples a fem solution along a set of points specified by
%gridPoints (created by createLeadFieldGrid.m), this function is very
%similar to sampleModelSolution
%returns a cell = {original gridPoints array, current vector array}
%current vector array = 3xnumPoints, row1 = Jx, row2=Jy,row3=Jz

function y = sampleLeadFieldGrid(fem, gridPoints) 
    temp = cell(2);
    temp{1} = gridPoints;   %store gridPoints with sub-sampled solution
    temp{2} = zeros(3,size(gridPoints,2));
    disp('Beginning to sample model along fiber trajectories.')
    %cycle through all the axons and sample for each
    for i = 1:1:size(gridPoints,2)
        disp(['Sampling point ' num2str(i) ' of ' num2str(size(gridPoints,2))])
        currX = postinterp(fem,'Jx_dc', gridPoints(:,i),'ext',0); %get x component
        currY = postinterp(fem,'Jy_dc', gridPoints(:,i),'ext',0); %get y component
        currZ = postinterp(fem,'Jz_dc', gridPoints(:,i),'ext',0); %get z component
        temp{2}(:,i) = [currX; currY; currZ];      %store the current array
    end
    
    y = temp;
