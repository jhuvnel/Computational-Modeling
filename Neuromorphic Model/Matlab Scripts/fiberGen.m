%this function takes in all the required info to produce a fiber trajectory
%cell (used for sampleModelSolution.  This function wraps 
%bulkFiberGeneration so that you don't have to manually input the mesh
%vertices, instead you can supply the ASCII amira mesh file's name
%contourFileName = file name of the stored contour you want to use
%ALL OTHER INPUTS: please read the documentation for bulkFiberGeneration
%remember that java like column vectors, not row vectors
%author = Russell Hayden, russhayden@hotmail.com, 2007

function y = fiberGen(nerveMeshFileName, startBndIndex, outerBndIndex, contourFileName, ...
                       num2Gen, step, locIndex, offset, endDist, nominalRadius, ...
                         maxIter, maxOutOfSub, fileFlag, saveToFileBase, subTestFlag)
    disp(['Attempting to open: ' contourFileName])
    contour = load(contourFileName);
    disp('Contour loaded successfully.')
    disp(['Attempting to convert mesh: ' nerveMeshFileName])
    conv = AmiraGridConvert(nerveMeshFileName);
    conv.convert();
    conv.closeFile();
    %get the data matrices for the mesh
    vMatrix = conv.vMatrix;
    tMatrix = conv.tMatrix;
    bndMat = conv.bndMatrix;
    bndIDMat = conv.bndID;
    %assemble the required surfaces
    startBnd = bndMat(:, find(bndIDMat == startBndIndex));
    fullBnd = bndMat(:, find(bndIDMat == outerBndIndex));
    disp(['Success in converting ' nerveMeshFileName ', beginning to create ' num2str(num2Gen) ' trajectories'])
    %wrap bulkFiberGeneration
    result = bulkFiberGeneration(vMatrix, tMatrix, startBnd, fullBnd, contour, ...
                                num2Gen, step, locIndex, offset, endDist, nominalRadius, ...
                                maxIter, maxOutOfSub, fileFlag, saveToFileBase, subTestFlag);
    disp('Done.')
    y = result;