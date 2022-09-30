%plots the axial current from the first to the last node, with the standard
%deviations, FIRST load in AxialCurrent solution cell
%NOTE: this script was written for the old version of sampleModelSolution.m
%MAKE SURE SAME NUMBER OF NODES FOR ALL AXONS WITHIN A NERVE BRANCH!!,
%otherwise will include zeroes into the mean

%load in the trajectories because all data was found before
%sampleModelSolution.m was fixed
load MRIFE_HorSCC_110Traj_LocInd_6to10;
trajH = traj;
clear traj;
load MRIFE_SupSCC_110Traj_LocInd_6to10;
trajS = traj;
clear traj;
load MRIFE_PosSCC_110Traj_LocInd_6to10;
trajP = traj;
clear traj;

%now take the dot product of each point's current vector with the contour
%segment just after it
for i = 1:11
    for j = 1:(size(horSCC_PE1_LI6to10_SolutionCell{1,4},2)-1)
        trajVector = trajH{i,3}(:,j)-trajH{i,3}(:,j+1);
        trajVector = trajVector/norm(trajVector);
        horAxialCurrent{i,j} = dot(trajVector, horSCC_PE1_LI6to10_SolutionCell{i,4}(:,j));
    end
    for j = 1:(size(supSCC_PE1_LI6to10_SolutionCell{1,4},2)-1)
        trajVector = trajS{i,3}(:,j)-trajS{i,3}(:,j+1);
        trajVector = trajVector/norm(trajVector);
        supAxialCurrent{i,j} = dot(trajVector, supSCC_PE1_LI6to10_SolutionCell{i,4}(:,j));
    end
    for j = 1:(size(posSCC_PE1_LI6to10_SolutionCell{1,4},2)-1)
        trajVector = trajP{i,3}(:,j)-trajP{i,3}(:,j+1);
        trajVector = trajVector/norm(trajVector);
        posAxialCurrent{i,j} = dot(trajVector, posSCC_PE1_LI6to10_SolutionCell{i,4}(:,j));
    end
end

%convert into matrices
horAxialCurrent = cell2mat(horAxialCurrent);
supAxialCurrent = cell2mat(supAxialCurrent);
posAxialCurrent = cell2mat(posAxialCurrent);

%now find means and standard devs
horAxialCurrentMeans = abs(mean(horAxialCurrent));
supAxialCurrentMeans = abs(mean(supAxialCurrent));
posAxialCurrentMeans = abs(mean(posAxialCurrent));
horAxialCurrentSTD = std(horAxialCurrent);
supAxialCurrentSTD = std(supAxialCurrent);
posAxialCurrentSTD = std(posAxialCurrent);

maxNum = max([(horAxialCurrentMeans+horAxialCurrentSTD) (supAxialCurrentMeans+supAxialCurrentSTD) ...
                (posAxialCurrentMeans+posAxialCurrentSTD)]);

%now plot everything (normalized)
plot(1:(size(horSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), horAxialCurrentMeans/maxNum, '-r', ...
    1:(size(horSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), (horAxialCurrentMeans+horAxialCurrentSTD)/maxNum, '--r',...
    1:(size(horSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), (horAxialCurrentMeans-horAxialCurrentSTD)/maxNum, '--r',...
    1:(size(supSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), supAxialCurrentMeans/maxNum, '-g',...
    1:(size(supSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), (supAxialCurrentMeans+supAxialCurrentSTD)/maxNum, '--g',...
    1:(size(supSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), (supAxialCurrentMeans-supAxialCurrentSTD)/maxNum, '--g',...
    1:(size(posSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), posAxialCurrentMeans/maxNum, '-b',...
    1:(size(posSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), (posAxialCurrentMeans+posAxialCurrentSTD)/maxNum, '--b',...
    1:(size(posSCC_PE1_LI6to10_SolutionCell{1,4},2)-1), (posAxialCurrentMeans-posAxialCurrentSTD)/maxNum, '--b');
title('Axial Current Flows, LH=red,LA=green,LP=blue');
xlabel('Node # (node 1 = heminode at crista)');
ylabel('Normalized Axial Current Flow');


    