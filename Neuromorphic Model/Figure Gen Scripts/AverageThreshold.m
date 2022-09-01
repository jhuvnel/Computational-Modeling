%find the average threshold of axons, may specify for only the
%cathodal or only anodal pulses, or only a certain kind of Fiber Type, or a
%specific nerve branch


%select which nerve(s) you would like to look at and include in the
%calculation (1 = include, 0 = exclude)
nerveFlag = [0 1 1 0 0]; %['LA' 'LH' 'LP' 'LU' 'LS']

%select what fiber types you are concerned with
typeFlag = [0 0 1]; %['Irregulars' 'Dimorphic' 'Regulars']

%now place a "scale limiter", which will cause only fibers below this
%threshold to be considered (obviously don't want to consider fibers being
%stimulated by 100 Amps of current or something), the cap will be
%currentStandard*scaleLimiter (usually 200uA * scaleLimiter)
scaleLimiter = 10;
minScale = 0.01;

%now define the time limits that should be considered, this way you can 
%look only at "cathodic" or "anodic", or all
timeStart = 3500;%0;%3500;%100;
timeStop = 10000;%10000;%3500;




nodeArray = [0 0];
thresholdArray = 0;

%go through each thing

if (nerveFlag(2) == 1)
    if (typeFlag(3) == 1)
    nodeArray = [nodeArray; horSCC_SimCell{1,1}{5,1}];
    thresholdArray = [thresholdArray; horSCC_SimCell{1,1}{4,1}];
    nodeArray = [nodeArray; horSCC_SimCell{1,2}{5,1}];
    thresholdArray = [thresholdArray; horSCC_SimCell{1,2}{4,1}];
    end
    
    if (typeFlag(2) == 1)
    nodeArray = [nodeArray; horSCC_SimCell{1,3}{5,1}];
    thresholdArray = [thresholdArray; horSCC_SimCell{1,3}{4,1}];
    nodeArray = [nodeArray; horSCC_SimCell{1,5}{5,1}];
    thresholdArray = [thresholdArray; horSCC_SimCell{1,5}{4,1}];
    nodeArray = [nodeArray; horSCC_SimCell{1,6}{5,1}];
    thresholdArray = [thresholdArray; horSCC_SimCell{1,6}{4,1}];
    end
    
    if (typeFlag(1) == 1)
    nodeArray = [nodeArray; horSCC_SimCell{1,4}{5,1}];
    thresholdArray = [thresholdArray; horSCC_SimCell{1,4}{4,1}];
    end
end

if (nerveFlag(3) == 1)
    if (typeFlag(3) == 1)
    nodeArray = [nodeArray; posSCC_SimCell{1,1}{5,1}];
    thresholdArray = [thresholdArray; posSCC_SimCell{1,1}{4,1}];
    nodeArray = [nodeArray; posSCC_SimCell{1,2}{5,1}];
    thresholdArray = [thresholdArray; posSCC_SimCell{1,2}{4,1}];
    end
    
    if (typeFlag(2) == 1)
    nodeArray = [nodeArray; posSCC_SimCell{1,3}{5,1}];
    thresholdArray = [thresholdArray; posSCC_SimCell{1,3}{4,1}];
    nodeArray = [nodeArray; posSCC_SimCell{1,5}{5,1}];
    thresholdArray = [thresholdArray; posSCC_SimCell{1,5}{4,1}];
    nodeArray = [nodeArray; posSCC_SimCell{1,6}{5,1}];
    thresholdArray = [thresholdArray; posSCC_SimCell{1,6}{4,1}];
    end
    
    if (typeFlag(1) == 1)
    nodeArray = [nodeArray; posSCC_SimCell{1,4}{5,1}];
    thresholdArray = [thresholdArray; posSCC_SimCell{1,4}{4,1}];
    end
end

if (nerveFlag(1) == 1)
    if (typeFlag(3) == 1)
    nodeArray = [nodeArray; supSCC_SimCell{1,1}{5,1}];
    thresholdArray = [thresholdArray; supSCC_SimCell{1,1}{4,1}];
    nodeArray = [nodeArray; supSCC_SimCell{1,2}{5,1}];
    thresholdArray = [thresholdArray; supSCC_SimCell{1,2}{4,1}];
    end
    
    if (typeFlag(2) == 1)
    nodeArray = [nodeArray; supSCC_SimCell{1,3}{5,1}];
    thresholdArray = [thresholdArray; supSCC_SimCell{1,3}{4,1}];
    nodeArray = [nodeArray; supSCC_SimCell{1,5}{5,1}];
    thresholdArray = [thresholdArray; supSCC_SimCell{1,5}{4,1}];
    nodeArray = [nodeArray; supSCC_SimCell{1,6}{5,1}];
    thresholdArray = [thresholdArray; supSCC_SimCell{1,6}{4,1}];
    end
    
    if (typeFlag(1) == 1)
    nodeArray = [nodeArray; supSCC_SimCell{1,4}{5,1}];
    thresholdArray = [thresholdArray; supSCC_SimCell{1,4}{4,1}];
    end
end
    
if (nerveFlag(4) == 1)
    if (typeFlag(3) == 1)
    nodeArray = [nodeArray; utricle_SimCell{1,1}{5,1}];
    thresholdArray = [thresholdArray; utricle_SimCell{1,1}{4,1}];
    end
    
    if (typeFlag(2) == 1)
    nodeArray = [nodeArray; utricle_SimCell{1,2}{5,1}];
    thresholdArray = [thresholdArray; utricle_SimCell{1,2}{4,1}];
    nodeArray = [nodeArray; utricle_SimCell{1,3}{5,1}];
    thresholdArray = [thresholdArray; utricle_SimCell{1,3}{4,1}];
    nodeArray = [nodeArray; utricle_SimCell{1,4}{5,1}];
    thresholdArray = [thresholdArray; utricle_SimCell{1,4}{4,1}];
    nodeArray = [nodeArray; utricle_SimCell{1,5}{5,1}];
    thresholdArray = [thresholdArray; utricle_SimCell{1,5}{4,1}];
    nodeArray = [nodeArray; utricle_SimCell{1,6}{5,1}];
    thresholdArray = [thresholdArray; utricle_SimCell{1,6}{4,1}];
    end
    
    if (typeFlag(1) == 1)
    nodeArray = [nodeArray; utricle_SimCell{1,7}{5,1}];
    thresholdArray = [thresholdArray; utricle_SimCell{1,7}{4,1}];
    end
end
   
if (nerveFlag(5) == 1)
    if (typeFlag(3) == 1)
    nodeArray = [nodeArray; saccule_SimCell{1,1}{5,1}];
    thresholdArray = [thresholdArray; saccule_SimCell{1,1}{4,1}];
    end
    
    if (typeFlag(2) == 1)
    nodeArray = [nodeArray; saccule_SimCell{1,2}{5,1}];
    thresholdArray = [thresholdArray; saccule_SimCell{1,2}{4,1}];
    nodeArray = [nodeArray; saccule_SimCell{1,3}{5,1}];
    thresholdArray = [thresholdArray; saccule_SimCell{1,3}{4,1}];
    nodeArray = [nodeArray; saccule_SimCell{1,4}{5,1}];
    thresholdArray = [thresholdArray; saccule_SimCell{1,4}{4,1}];
    nodeArray = [nodeArray; saccule_SimCell{1,5}{5,1}];
    thresholdArray = [thresholdArray; saccule_SimCell{1,5}{4,1}];
    nodeArray = [nodeArray; saccule_SimCell{1,6}{5,1}];
    thresholdArray = [thresholdArray; saccule_SimCell{1,6}{4,1}];
    end
    
    if (typeFlag(1) == 1)
    nodeArray = [nodeArray; saccule_SimCell{1,7}{5,1}];
    thresholdArray = [thresholdArray; saccule_SimCell{1,7}{4,1}];
    end
end

%remove the first row from result cells
nodeArray = nodeArray(2:size(nodeArray,1),:);
thresholdArray = thresholdArray(2:size(thresholdArray,1),:);

%convert each array to double for maximum compatibility
nodeArray = double(nodeArray);
thresholdArray = double(thresholdArray);

%now apply the remaining user defined constraints
indexes = find(thresholdArray < scaleLimiter);
nodeArray = nodeArray(indexes, :);
thresholdArray = thresholdArray(indexes);
indexes = find(thresholdArray > minScale);
nodeArray = nodeArray(indexes, :);
thresholdArray = thresholdArray(indexes);
indexes = find(nodeArray(:,2) < timeStop);
nodeArray = nodeArray(indexes, :);
thresholdArray = thresholdArray(indexes);
indexes = find(nodeArray(:,2) > timeStart);
nodeArray = nodeArray(indexes, :);
thresholdArray = thresholdArray(indexes);

thresholdMean = mean(thresholdArray);
thresholdSTDDEV = std(thresholdArray);

disp(['Mean Threshold: ' num2str(thresholdMean) ' +/- ' num2str(thresholdSTDDEV)...
                                            ',  n = ' num2str(max(size(thresholdArray)))]);
disp(['Range: ' num2str(min(thresholdArray)) ' to ' num2str(max(thresholdArray))]);
disp('Remember that these are scale values of the standard current setting.');


