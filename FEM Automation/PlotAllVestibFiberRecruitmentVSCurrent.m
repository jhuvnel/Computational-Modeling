function [f, ] = PlotAllVestibFiberRecruitmentVSCurrent(inputArg1,inputArg2)
%PLOTALLVESTIBFIBERRECRUITMENTVSCURRENT Summary of this function goes here
%   Detailed explanation goes here


%plot fiber recruitment of all SCC and utricle/saccule and plot against
%stimulus current strength

%set currentScaleCorrection before you plot
%currentScaleCorrection = 1;%1/100;
currentRange = linspace(0,10,500);  %e.g. 0 to 10 results in 0 to 2mA
current = 200e-6*currentScaleCorrection;    %200uA is standard
flagNormalizeToNumFibers = 1;
sccNumFibers = 505;
otoNumFibers = 450;

horSum = zeros(1,size(currentRange,2));
posSum = zeros(1,size(currentRange,2));
supSum = zeros(1,size(currentRange,2));
utrSum = zeros(1,size(currentRange,2));
sacSum = zeros(1,size(currentRange,2));

for i = 1:size(currentRange,2)
    horSum(i) = size(find(horSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,1}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,2}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,3}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,4}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,5}{4,1} <= 0),1);
    horSum(i) = horSum(i) + size(find(horSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    horSum(i) = horSum(i) - size(find(horSCC_SimCell{1,6}{4,1} <= 0),1);


    posSum(i) = size(find(posSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,1}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,2}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,3}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,4}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,5}{4,1} <= 0),1);
    posSum(i) = posSum(i) + size(find(posSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    posSum(i) = posSum(i) - size(find(posSCC_SimCell{1,6}{4,1} <= 0),1);

    supSum(i) = size(find(supSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,1}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,2}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,3}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,4}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,5}{4,1} <= 0),1);
    supSum(i) = supSum(i) + size(find(supSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    supSum(i) = supSum(i) - size(find(supSCC_SimCell{1,6}{4,1} <= 0),1);
    
    utrSum(i) = size(find(utricle_SimCell{1,1}{4,1} < currentRange(i)),1);
    utrSum(i) = utrSum(i) - size(find(utricle_SimCell{1,1}{4,1} <= 0),1);
    utrSum(i) = utrSum(i) + size(find(utricle_SimCell{1,2}{4,1} < currentRange(i)),1);
    utrSum(i) = utrSum(i) - size(find(utricle_SimCell{1,2}{4,1} <= 0),1);
    utrSum(i) = utrSum(i) + size(find(utricle_SimCell{1,3}{4,1} < currentRange(i)),1);
    utrSum(i) = utrSum(i) - size(find(utricle_SimCell{1,3}{4,1} <= 0),1);
    utrSum(i) = utrSum(i) + size(find(utricle_SimCell{1,4}{4,1} < currentRange(i)),1);
    utrSum(i) = utrSum(i) - size(find(utricle_SimCell{1,4}{4,1} <= 0),1);
    utrSum(i) = utrSum(i) + size(find(utricle_SimCell{1,5}{4,1} < currentRange(i)),1);
    utrSum(i) = utrSum(i) - size(find(utricle_SimCell{1,5}{4,1} <= 0),1);
    utrSum(i) = utrSum(i) + size(find(utricle_SimCell{1,6}{4,1} < currentRange(i)),1);
    utrSum(i) = utrSum(i) - size(find(utricle_SimCell{1,6}{4,1} <= 0),1);
    utrSum(i) = utrSum(i) + size(find(utricle_SimCell{1,7}{4,1} < currentRange(i)),1);
    utrSum(i) = utrSum(i) - size(find(utricle_SimCell{1,7}{4,1} <= 0),1);
   
    sacSum(i) = size(find(saccule_SimCell{1,1}{4,1} < currentRange(i)),1);
    sacSum(i) = sacSum(i) - size(find(saccule_SimCell{1,1}{4,1} <= 0),1);
    sacSum(i) = sacSum(i) + size(find(saccule_SimCell{1,2}{4,1} < currentRange(i)),1);
    sacSum(i) = sacSum(i) - size(find(saccule_SimCell{1,2}{4,1} <= 0),1);
    sacSum(i) = sacSum(i) + size(find(saccule_SimCell{1,3}{4,1} < currentRange(i)),1);
    sacSum(i) = sacSum(i) - size(find(saccule_SimCell{1,3}{4,1} <= 0),1);
    sacSum(i) = sacSum(i) + size(find(saccule_SimCell{1,4}{4,1} < currentRange(i)),1);
    sacSum(i) = sacSum(i) - size(find(saccule_SimCell{1,4}{4,1} <= 0),1);
    sacSum(i) = sacSum(i) + size(find(saccule_SimCell{1,5}{4,1} < currentRange(i)),1);
    sacSum(i) = sacSum(i) - size(find(saccule_SimCell{1,5}{4,1} <= 0),1);
    sacSum(i) = sacSum(i) + size(find(saccule_SimCell{1,6}{4,1} < currentRange(i)),1);
    sacSum(i) = sacSum(i) - size(find(saccule_SimCell{1,6}{4,1} <= 0),1);
    sacSum(i) = sacSum(i) + size(find(saccule_SimCell{1,7}{4,1} < currentRange(i)),1);
    sacSum(i) = sacSum(i) - size(find(saccule_SimCell{1,7}{4,1} <= 0),1);
        
end
f = figure;
if (flagNormalizeToNumFibers ~= 1)
    plot(currentRange*current, horSum, '-r', currentRange*current, posSum, '-b', currentRange*current, supSum, '-g',...
      currentRange*current, utrSum, ':k', currentRange*current, sacSum, '--k'); 
    title('Horizontal (red), posterior (blue), superior (green), utricle (..black), saccule(--black)');
    xlabel('current in amps');
    ylabel('number of fibers stimulated');
    maxNum = max([horSum posSum supSum utrSum sacSum]);
    axis([0 current*max(currentRange) 0 maxNum])
end
if (flagNormalizeToNumFibers == 1)
    horSum = 100*horSum/sccNumFibers;    supSum = 100*supSum/sccNumFibers;    posSum = 100*posSum/sccNumFibers;
    utrSum = 100*utrSum/otoNumFibers;   sacSum = 100*sacSum/otoNumFibers;
    plot(currentRange*current, horSum, '-r', currentRange*current, posSum, '-b', currentRange*current, supSum, '-g',...
      currentRange*current, utrSum, ':k', currentRange*current, sacSum, '--k'); 
    title('Horizontal (red), posterior (blue), superior (green), utricle (..black), saccule(--black)');
    xlabel('current in amps');
    ylabel('% Activation');
    maxNum = max([horSum posSum supSum utrSum sacSum]);
    axis([0 current*max(currentRange) 0 maxNum])
end
end

