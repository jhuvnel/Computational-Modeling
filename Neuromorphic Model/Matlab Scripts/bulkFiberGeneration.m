%this function generates in bulk fiber trajectories, use a -1 for all fill conditions in arrays like step and locIndex
%vMatrix = vertex matrix, tMatrix = tet matrix of Nerve ONLY, startBnd = seedSurface, fullBnd = outerNerve surface 
%contour = nerveContour, num2Gen = amount to generate, step = array of internode distances
%locIndex = array of locIndex, offset = distance to basement membrane, endDist = how close to get to last node on nerveContour
%nominalRadius = average radius of the nerve (keep as small as possible), maxIter = maximum allowable iterations for a single fiber generation
%maxOutOfSub = maximum allowable nerve generation failures, fileFlag = whether or not to generate individual files for viewing (if 1 then will generate)
%saveToFileBase = base file name if fileFlag == 1, subTestFlag = if 1 then will NOT test each node for being within the nerve 
%returns a cell of {loc index, 1xNumNodes array of internode distances, 3xNumNodes trajectory array}
%note, this routine needs the m-file saveascii available at mathwork's file exchange
%note, Java likes column vectors, not row vectors
%author = Russ Hayden, 2007, russellhayden@gmail.com

function y = bulkFiberGeneration(vMatrix, tMatrix, startBnd, fullBnd, contour, ...
                                num2Gen, step, locIndex, offset, endDist, nominalRadius, ...
                                maxIter, maxOutOfSub, fileFlag, saveToFileBase, subTestFlag)
    disp ('Preprocessing data...')
    %create a FiberTrajGen object
    g = FiberTrajGen(vMatrix, tMatrix, startBnd, fullBnd, contour);
    disp('Generating Trajectories (may take a long time)...')
    if (subTestFlag == 1)
        g.subdomainTestOff();       %turn off the subdomain test, will go a little faster but not recommended
    end
    r = cell(num2Gen,1);
    flagDone = 0;
    i = 0;
    locIndexIterator = 0;
    maxOutOfSubSum = 0;
    while (flagDone ~= 1)
        i = i + 1;
        locIndexIterator = locIndexIterator + 1;
        if (locIndex(locIndexIterator) == -1)
            locIndexIterator = locIndexIterator - 1;    %take care of fill condition
        end
        disp(['Generating Trajectory ' num2str(i) ' of ' num2str(num2Gen)])
        flagTrajGenSuccess = 0;
        while (flagTrajGenSuccess == 0)
            r{i} = g.generateTrajectory(step, locIndex(locIndexIterator), offset, endDist, nominalRadius, maxIter);
            if (isempty(r{i}))
                %let loop run again
                maxOutOfSubSum = maxOutOfSubSum + 1;
                if (maxOutOfSubSum > maxOutOfSub)
                    error('Error. bulkFiberGeneration has failed due to exceeding maxOutOfSub generate failures.')
                end
            else
                flagTrajGenSuccess = 1;
            end
        end
        if (i == num2Gen)
            flagDone = 1;
        end
    end
    disp('Trajectories generated successfully.')
    %save individual files for viewing in Amira
    if (fileFlag == 1)
        disp('Saving to files...')
        for i = 1:num2Gen
            saveascii(r{i}, [saveToFileBase num2str(i) '.txt'], 10, ' ');
        end
    end
    temp = cell(num2Gen, 3);    
    %now generate the final cell
    iteratorLocInd = 0;
    incrementorLocInd = 1;
    for i = 1:1:num2Gen
        iteratorLocInd = iteratorLocInd + incrementorLocInd;
        if (iteratorLocInd ~= size(locIndex, 1))
            if (locIndex(iteratorLocInd + 1) == -1)
                incrementorLocInd = 0;
            end
        end
        temp{i,1} = locIndex(iteratorLocInd);       %store the locIndex for this fiber
        %create the step vector for this fiber
        tempStep = zeros(size(r{i},2),1);
        iteratorStep = 0;
        incrementorStep = 1;
        for j = 1:1:size(r{i},2)
            iteratorStep = iteratorStep + incrementorStep;
            if (iteratorStep ~= size(step,1))
                if (step(iteratorStep + 1) == -1)
                    incrementorStep = 0;
                end
            end
            tempStep(j) = step(iteratorStep);
        end
        temp{i,3} = r{i};       %store the trajectoy coordinates
    end
        temp{1,2} = tempStep;   %store the step vector (the same for all fibers)
    
    y = temp;

