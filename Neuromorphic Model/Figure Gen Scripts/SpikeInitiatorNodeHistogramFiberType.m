%plot a histogram of where spike initiation occured, can limit to only
%cathodal or only anodal pulses, or only a certain kind of Fiber Type, or a
%specific nerve branch


%select which nerve(s) you would like to look at and include in the
%histogram (1 = include, 0 = exclude)
nerveFlag = [0 1 0 0 0]; %['LA' 'LH' 'LP' 'LU' 'LS']
%select what fiber types you are concerned with
typeFlag = [1 1 1]; %['Irregulars' 'Dimorphic' 'Regulars']

%now place a "scale limiter", which will cause only fibers below this
%threshold to be considered (obviously don't want to consider fibers being
%stimulated by 100 Amps of current or something), the cap will be
%currentStandard*scaleLimiter (usually 200uA * scaleLimiter)
scaleLimiter = 10;
minScale = 0.01;

%now define the time limits that should be considered, this way you can 
%look only at "cathodic" or "anodic", or all
timeStart = 100;%0;%3500;%100;
timeStop = 10000;%10000;%3500;


%save the sim cells so that we can return them to their original state
%afterward
horSCC_SimCell_original = horSCC_SimCell;
posSCC_SimCell_original = posSCC_SimCell;
supSCC_SimCell_original = supSCC_SimCell;
utricle_SimCell_original = utricle_SimCell;
saccule_SimCell_original = saccule_SimCell;



nodeArray = [0 0];
thresholdArray = 0;

%go through each thing

if (nerveFlag(2) == 1)
    %normalize length of each axon first
    for j = 1:6
        for i = 1:max(size(horSCC_SimCell{1,j}{4,1}))
            horSCC_SimCell{1,j}{5,1}(i,1) = horSCC_SimCell{1,j}{5,1}(i,1)/max(size(horSCC_SimCell{1,j}{2,1}{i,3}));
        end
    end
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
    %normalize length of each axon first
    for j = 1:6
        for i = 1:max(size(posSCC_SimCell{1,j}{4,1}))
            posSCC_SimCell{1,j}{5,1}(i,1) = posSCC_SimCell{1,j}{5,1}(i,1)/max(size(posSCC_SimCell{1,j}{2,1}{i,3}));
        end
    end
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
    %normalize length of each axon first
    for j = 1:6
        for i = 1:max(size(supSCC_SimCell{1,j}{4,1}))
            supSCC_SimCell{1,j}{5,1}(i,1) = supSCC_SimCell{1,j}{5,1}(i,1)/max(size(supSCC_SimCell{1,j}{2,1}{i,3}));
        end
    end
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
    %normalize length of each axon first
    for j = 1:7
        for i = 1:max(size(utricle_SimCell{1,j}{4,1}))
            utricle_SimCell{1,j}{5,1}(i,1) = utricle_SimCell{1,j}{5,1}(i,1)/max(size(utricle_SimCell{1,j}{2,1}{i,3}));
        end
    end

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
    %normalize length of each axon first
    for j = 1:7
        for i = 1:max(size(saccule_SimCell{1,j}{4,1}))
            saccule_SimCell{1,j}{5,1}(i,1) = saccule_SimCell{1,j}{5,1}(i,1)/max(size(saccule_SimCell{1,j}{2,1}{i,3}));
        end
    end

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

%convert each array to double, because "hist" won't accept int32 data
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

%plot
result = nodeArray(:,1);
[N,X] = hist(result, 100);
hist(result, 100);
xlabel('Normalized length, 0 = neuroepithilium, 1 = brain');
ylabel('Number of spikes generated');



%set back to the original states
horSCC_SimCell = horSCC_SimCell_original;
posSCC_SimCell = posSCC_SimCell_original;
supSCC_SimCell = supSCC_SimCell_original;
utricle_SimCell = utricle_SimCell_original;
saccule_SimCell = saccule_SimCell_original;
clear horSCC_SimCell_original;
clear posSCC_SimCell_original;
clear supSCC_SimCell_original;
clear utricle_SimCell_original;
clear saccule_SimCell_original;

