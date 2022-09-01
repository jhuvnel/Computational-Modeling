%plot fiber Type recruitment vs current (so you can compare recruitment of
%irregs vs. regs, etc.)


%select which nerve(s) you would like to look at and include in the
%percentages (1 = include, 0 = exclude)
typeFlag = [0 0 0 1 1]; %['LA' 'LH' 'LP' 'LU' 'LS']

%set currentScaleCorrection before you plot
currentScaleCorrection = 1;%1/100;
currentRange = linspace(0,10,500);  %e.g. 0 to 10 results in 0 to 2mA
current = 200e-6*currentScaleCorrection;    %200uA is standard
irregNumFibersSCC = 55;
regNumFibersSCC = 100;
dimNumFibersSCC = 350;
irregNumFibersUS = 50;
regNumFibersUS = 100;
dimNumFibersUS = 300;



irrSum = zeros(1,size(currentRange,2));
regSum = zeros(1,size(currentRange,2));
dimSum = zeros(1,size(currentRange,2));
irregTot = typeFlag(1)*irregNumFibersSCC+typeFlag(2)*irregNumFibersSCC+typeFlag(3)*irregNumFibersSCC...
            +typeFlag(4)*irregNumFibersUS+typeFlag(5)*irregNumFibersUS;
dimTot = typeFlag(1)*dimNumFibersSCC+typeFlag(2)*dimNumFibersSCC+typeFlag(3)*dimNumFibersSCC...
            +typeFlag(4)*dimNumFibersUS+typeFlag(5)*dimNumFibersUS;
regTot = typeFlag(1)*regNumFibersSCC+typeFlag(2)*regNumFibersSCC+typeFlag(3)*regNumFibersSCC...
            +typeFlag(4)*regNumFibersUS+typeFlag(5)*regNumFibersUS;
        
        

for i = 1:size(currentRange,2)
    
    %
    if (typeFlag(2) == 1)
    regSum(i) = regSum(i) + size(find(horSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(horSCC_SimCell{1,1}{4,1} <= 0),1);
    regSum(i) = regSum(i) + size(find(horSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(horSCC_SimCell{1,2}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(horSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(horSCC_SimCell{1,3}{4,1} <= 0),1);
    
    irrSum(i) = irrSum(i) + size(find(horSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    irrSum(i) = irrSum(i) - size(find(horSCC_SimCell{1,4}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(horSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(horSCC_SimCell{1,5}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(horSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(horSCC_SimCell{1,6}{4,1} <= 0),1);
    end

    if (typeFlag(3) == 1)
    regSum(i) = regSum(i) + size(find(posSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(posSCC_SimCell{1,1}{4,1} <= 0),1);
    regSum(i) = regSum(i) + size(find(posSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(posSCC_SimCell{1,2}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(posSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(posSCC_SimCell{1,3}{4,1} <= 0),1);
    
    irrSum(i) = irrSum(i) + size(find(posSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    irrSum(i) = irrSum(i) - size(find(posSCC_SimCell{1,4}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(posSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(posSCC_SimCell{1,5}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(posSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(posSCC_SimCell{1,6}{4,1} <= 0),1);
    end

    if (typeFlag(1) == 1)
    regSum(i) = regSum(i) + size(find(supSCC_SimCell{1,1}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(supSCC_SimCell{1,1}{4,1} <= 0),1);
    regSum(i) = regSum(i) + size(find(supSCC_SimCell{1,2}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(supSCC_SimCell{1,2}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(supSCC_SimCell{1,3}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(supSCC_SimCell{1,3}{4,1} <= 0),1);
    
    irrSum(i) = irrSum(i) + size(find(supSCC_SimCell{1,4}{4,1} < currentRange(i)),1);
    irrSum(i) = irrSum(i) - size(find(supSCC_SimCell{1,4}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(supSCC_SimCell{1,5}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(supSCC_SimCell{1,5}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(supSCC_SimCell{1,6}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(supSCC_SimCell{1,6}{4,1} <= 0),1);
    end
    
    if (typeFlag(4) == 1)
    regSum(i) = regSum(i) + size(find(utricle_SimCell{1,1}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(utricle_SimCell{1,1}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(utricle_SimCell{1,2}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(utricle_SimCell{1,2}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(utricle_SimCell{1,3}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(utricle_SimCell{1,3}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(utricle_SimCell{1,4}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(utricle_SimCell{1,4}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(utricle_SimCell{1,5}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(utricle_SimCell{1,5}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(utricle_SimCell{1,6}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(utricle_SimCell{1,6}{4,1} <= 0),1);
    
    irrSum(i) = irrSum(i) + size(find(utricle_SimCell{1,7}{4,1} < currentRange(i)),1);
    irrSum(i) = irrSum(i) - size(find(utricle_SimCell{1,7}{4,1} <= 0),1);
    end
   
    if (typeFlag(5) == 1)
    regSum(i) = regSum(i) + size(find(saccule_SimCell{1,1}{4,1} < currentRange(i)),1);
    regSum(i) = regSum(i) - size(find(saccule_SimCell{1,1}{4,1} <= 0),1);
    
    dimSum(i) = dimSum(i) + size(find(saccule_SimCell{1,2}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(saccule_SimCell{1,2}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(saccule_SimCell{1,3}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(saccule_SimCell{1,3}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(saccule_SimCell{1,4}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(saccule_SimCell{1,4}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(saccule_SimCell{1,5}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(saccule_SimCell{1,5}{4,1} <= 0),1);
    dimSum(i) = dimSum(i) + size(find(saccule_SimCell{1,6}{4,1} < currentRange(i)),1);
    dimSum(i) = dimSum(i) - size(find(saccule_SimCell{1,6}{4,1} <= 0),1);
    
    irrSum(i) = irrSum(i) + size(find(saccule_SimCell{1,7}{4,1} < currentRange(i)),1);
    irrSum(i) = irrSum(i) - size(find(saccule_SimCell{1,7}{4,1} <= 0),1);
    end
        
end
    irrSum = 100*irrSum/irregTot;
    regSum = 100*regSum/regTot;
    dimSum = 100*dimSum/dimTot;

    plot(currentRange*current, regSum, '-r', currentRange*current, irrSum, '-b',...
                                                                      currentRange*current, dimSum, '-k'); 
    title('Regulars (red), Irregulars (blue), Dimorphic Afferents (black)');
    xlabel('current in amps');
    ylabel('% Activation (reg=r, irreg = b, dimorph = black');
    maxNum = max([regSum irrSum dimSum]);
    axis([0 current*max(currentRange) 0 maxNum])



